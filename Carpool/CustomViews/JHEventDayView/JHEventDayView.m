//
//  JHEventDayView.m
//  Carpool
//
//  Created by JH Lee on 4/15/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import "JHEventDayView.h"

@implementation JHEventDayView

#define VIEW_MAX_HEIGHT     2500
#define VIEW_TOP_MARGIN     20
#define VIEW_BOTTOM_MARGIN  10
#define VIEW_SCROLL_SECOND  2

- (void)initViews {
    m_sclMain = [[UIScrollView alloc] initWithFrame:CGRectZero];
    m_sclMain.contentSize = CGSizeMake(CGRectGetWidth(self.bounds), VIEW_MAX_HEIGHT);
    m_sclMain.showsVerticalScrollIndicator = NO;
    m_sclMain.showsHorizontalScrollIndicator = NO;
    [self addSubview:m_sclMain];
    
    m_viewTime = [[UIView alloc] initWithFrame:CGRectZero];
    m_viewTime.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"#d1d1d1"];
    [m_sclMain addSubview:m_viewTime];
    
    m_viewMain = [[UIView alloc] initWithFrame:CGRectZero];
    m_viewMain.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"#F2F2F2"];
    [m_sclMain addSubview:m_viewMain];
    
    m_aryHourString = @[@"12AM", @"1AM", @"2AM", @"3AM", @"4AM", @"5AM", @"6AM", @"7AM", @"8AM", @"9AM", @"10AM", @"11AM", @"12PM",
                        @"1PM", @"2PM", @"3PM", @"4PM", @"5PM", @"6PM", @"7PM", @"8PM", @"9PM", @"10PM", @"11PM", @"12AM"];
    
    if ([self.dataSource respondsToSelector:@selector(hourTitlesInDayView:)]) {
        m_aryHourString = [self.dataSource hourTitlesInDayView:self];
    }
    
    m_aryEventColor = @[[UIColor hx_colorWithHexRGBAString:@"#5BC0DE"], [UIColor hx_colorWithHexRGBAString:@"#5F9EA0"], [UIColor hx_colorWithHexRGBAString:@"#A52A2A"],
                        [UIColor hx_colorWithHexRGBAString:@"#BDB76B"], [UIColor hx_colorWithHexRGBAString:@"#556B2F"], [UIColor hx_colorWithHexRGBAString:@"#8FBC8F"],
                        [UIColor hx_colorWithHexRGBAString:@"#2F4F4F"], [UIColor hx_colorWithHexRGBAString:@"#00BFFF"], [UIColor hx_colorWithHexRGBAString:@"#DAA520"],
                        [UIColor hx_colorWithHexRGBAString:@"#CD5C5C"], [UIColor hx_colorWithHexRGBAString:@"#F08080"], [UIColor hx_colorWithHexRGBAString:@"#ADD8E6"],
                        [UIColor hx_colorWithHexRGBAString:@"#FFB6C1"], [UIColor hx_colorWithHexRGBAString:@"#FFA07A"], [UIColor hx_colorWithHexRGBAString:@"#20B2AA"],
                        [UIColor hx_colorWithHexRGBAString:@"#3CB371"], [UIColor hx_colorWithHexRGBAString:@"#C71585"], [UIColor hx_colorWithHexRGBAString:@"#6B8E23"],
                        [UIColor hx_colorWithHexRGBAString:@"#DB7093"], [UIColor hx_colorWithHexRGBAString:@"#CD853F"], [UIColor hx_colorWithHexRGBAString:@"#FA8072"],
                        [UIColor hx_colorWithHexRGBAString:@"#8B4513"], [UIColor hx_colorWithHexRGBAString:@"#2E8B57"], [UIColor hx_colorWithHexRGBAString:@"#F5DEB3"],
                        [UIColor hx_colorWithHexRGBAString:@"#9ACD32"], [UIColor hx_colorWithHexRGBAString:@"#87CEFA"], [UIColor hx_colorWithHexRGBAString:@"#778899"],
                        [UIColor hx_colorWithHexRGBAString:@"#B0C4DE"], [UIColor hx_colorWithHexRGBAString:@"#BA55D3"], [UIColor hx_colorWithHexRGBAString:@"#4682B4"]
                        ];
    if ([self.dataSource respondsToSelector:@selector(eventColorsInDayView:)]) {
        m_aryEventColor = [self.dataSource eventColorsInDayView:self];
    }
    
    m_hourHeight = (VIEW_MAX_HEIGHT - VIEW_TOP_MARGIN - VIEW_BOTTOM_MARGIN) / (m_aryHourString.count - 1);
    m_minimumHeight = m_hourHeight * 0.75;
    
    if(self.hour_line_color == nil) {
        self.hour_line_color = [UIColor hx_colorWithHexRGBAString:@"#B6B6B6"];
    }
    
    if(self.minute_line_color == nil) {
        self.minute_line_color = [UIColor hx_colorWithHexRGBAString:@"#D6D6D6"];
    }
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onLongPressDayView:)];
    [self addGestureRecognizer:longPress];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if(self) {
        // Drawing code
        [self initViews];
        
        //resize main views
        m_sclMain.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
        m_viewTime.frame = CGRectMake(0, 0, 40, VIEW_MAX_HEIGHT);
        m_viewMain.frame = CGRectMake(40, 0, CGRectGetWidth(self.bounds) - 40, VIEW_MAX_HEIGHT);
        
        for(int nIndex = 0; nIndex < m_aryHourString.count; nIndex++) {
            CGFloat nY = nIndex * m_hourHeight + VIEW_TOP_MARGIN;
            
            //add hour text
            UILabel *lblHours = [[UILabel alloc] initWithFrame:CGRectMake(0, nY - CGRectGetWidth(m_viewTime.bounds) / 2, CGRectGetWidth(m_viewTime.bounds), CGRectGetWidth(m_viewTime.bounds))];
            lblHours.font = [UIFont fontWithName:@"Helvetica Neue" size:12.f];
            lblHours.textColor = [UIColor blackColor];
            lblHours.textAlignment = NSTextAlignmentCenter;
            lblHours.text = m_aryHourString[nIndex];
            [m_viewTime addSubview:lblHours];
            
            UIBezierPath *path = [UIBezierPath bezierPath];
            [path moveToPoint:CGPointMake(0, nY)];
            [path addLineToPoint:CGPointMake(CGRectGetWidth(m_viewMain.bounds), nY)];
            
            CAShapeLayer *shapeLayer = [CAShapeLayer layer];
            shapeLayer.path = [path CGPath];
            shapeLayer.strokeColor = self.hour_line_color.CGColor;
            shapeLayer.lineWidth = 1.0;
            shapeLayer.fillColor = [[UIColor clearColor] CGColor];
            
            [m_viewMain.layer addSublayer:shapeLayer];
            
            if(nIndex < m_aryHourString.count - 1) {
                UIBezierPath *path = [UIBezierPath bezierPath];
                [path moveToPoint:CGPointMake(0, nY + m_hourHeight / 2)];
                [path addLineToPoint:CGPointMake(CGRectGetWidth(m_viewMain.bounds), nY + m_hourHeight / 2)];
                
                CAShapeLayer *shapeLayer = [CAShapeLayer layer];
                shapeLayer.path = [path CGPath];
                shapeLayer.strokeColor = self.minute_line_color.CGColor;
                shapeLayer.lineWidth = 1.0;
                shapeLayer.fillColor = [[UIColor clearColor] CGColor];
                
                [m_viewMain.layer addSublayer:shapeLayer];
            }
        }
    }
    return self;
}

- (void)setScrollEnabled:(BOOL)enabled {
    m_sclMain.scrollEnabled = enabled;
}

- (void)layoutSubviews {
    firstView = nil;
    
    // draw valide views with same width
    NSInteger nMaxDrawLevel = [self getMaxDrawLevel];
    NSInteger nWidth = CGRectGetWidth(m_viewMain.bounds) / nMaxDrawLevel;
    NSInteger nEvents = m_viewMain.subviews.count;
    
    JHEventView *currentView = nil;
    JHEventView *prevView = nil;
    
    for(int nI = 0; nI < nEvents; nI++) {
        currentView = m_viewMain.subviews[nI];
        if(![currentView isKindOfClass:[JHEventView class]]) {
            continue;
        }
        
        currentView.draw_level = 0;
        
        if(!firstView) {
            firstView = currentView;
        }
        
        NSInteger nViewHeight = m_hourHeight * [currentView.m_event durationInMinutes] / 60.f;
        if(nViewHeight < m_minimumHeight) {
            nViewHeight = m_minimumHeight;
        }
        
        for(int nJ = 0; nJ < nMaxDrawLevel; nJ++) {
            BOOL isInteraction = NO;
            currentView.frame = CGRectMake(nJ * nWidth,
                                           m_hourHeight * [currentView.m_event minutesSinceMidnight] / 60.f + VIEW_TOP_MARGIN,
                                           nWidth - 1,
                                           nViewHeight);
            currentView.draw_level = nJ;
            
            for(int nK = 0; nK < nI; nK++) {
                prevView = m_viewMain.subviews[nK];
                if(![prevView isKindOfClass:[JHEventView class]]) {
                    continue;
                }
                
                if(CGRectIntersectsRect(currentView.frame, prevView.frame)) {
                    isInteraction = YES;
                    break;
                }
            }
            
            if(!isInteraction) {
                break;
            }
        }
    }
    
    //adjust view size
    
    for(int nI = 0; nI < nEvents; nI++) {
        currentView = m_viewMain.subviews[nI];
        if(![currentView isKindOfClass:[JHEventView class]]) {
            continue;
        }
        
        for(int nJ = currentView.draw_level; nJ < nMaxDrawLevel - 1; nJ++) {
            BOOL isInteraction = NO;
            CGRect viewRect = currentView.frame;
            viewRect.size.width += nWidth;
            
            for(int nK = 0; nK < nEvents; nK++) {
                prevView = m_viewMain.subviews[nK];
                if(![prevView isKindOfClass:[JHEventView class]]
                   || prevView == currentView) {
                    continue;
                }
                
                if(CGRectIntersectsRect(viewRect, prevView.frame)) {
                    isInteraction = YES;
                    break;
                }
            }
            
            if(isInteraction) {
                break;
            } else {
                currentView.frame = viewRect;
            }
        }
    }
}

- (NSInteger)getMaxDrawLevel {
    NSInteger nEvents = m_viewMain.subviews.count;
    NSInteger maxDrawLevel = 0;
    
    JHEventView *currentView = nil;
    JHEventView *nextView = nil;
    
    for(int nI = 0; nI < nEvents; nI++) {
        currentView = m_viewMain.subviews[nI];
        
        if(![currentView isKindOfClass:[JHEventView class]]) {
            continue;
        }
        
        NSInteger nDrawLevel = 0;
        for(int nJ = 0; nJ < nEvents; nJ++) {
            nextView = m_viewMain.subviews[nJ];
            
            if(![nextView isKindOfClass:[JHEventView class]]
               || currentView == nextView) {
                continue;
            }
            
            if([currentView.m_event.event_start_at isBetweenDates:nextView.m_event.event_start_at andDate:nextView.m_event.event_end_at]) {
                nDrawLevel++;
            }
        }
        
        if(nDrawLevel > maxDrawLevel) {
            maxDrawLevel = nDrawLevel;
        }
    }
    
    return maxDrawLevel + 1;
}

- (void)scrollToJHEvent:(JHEvent *)event {
    JHEventView *selectedEventView = nil;
    for(JHEventView *viewEvent in m_viewMain.subviews) {
        if([viewEvent isKindOfClass:[JHEventView class]]) {
            if([event compareJHEvent:viewEvent.m_event]) {
                selectedEventView = viewEvent;
                break;
            }
        }
    }
    
    if(selectedEventView) {
        [self setContentOffset:CGPointMake(0, CGRectGetMinY(selectedEventView.frame) - VIEW_TOP_MARGIN) animated:YES];
    }
}

- (void)setContentOffset:(CGPoint)point animated:(BOOL)animated {
    if(point.y < 0) {
        if(self.view_date.today) {
            point.y = [[NSDate date] minutesFromDate:[NSDate date].dateAtBeginningOfDay] / 60.f * m_hourHeight;
        } else if (firstView) {
            point.y = CGRectGetMinY(firstView.frame) - VIEW_TOP_MARGIN;
        } else {
            point.y = m_sclMain.contentOffset.y;
        }
    }
    
    if(point.y > VIEW_MAX_HEIGHT - CGRectGetHeight(self.frame)) {
        point.y = VIEW_MAX_HEIGHT - CGRectGetHeight(self.frame);
    }
    
    [m_sclMain setContentOffset:point animated:animated];
}

- (CGPoint)getCurrentPoint {
    return m_sclMain.contentOffset;
}

- (void)setView_date:(NSDate *)view_date {
    _view_date = view_date;
    
    if(m_todayLayer) {
        [m_todayLayer removeFromSuperlayer];
        m_todayLayer = nil;
    }
    
    if(view_date.today) {  // if view date is today
        // draw current time line
        CGFloat nY = [[NSDate date] minutesFromDate:view_date] / 60.f * m_hourHeight + VIEW_TOP_MARGIN;
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(0, nY)];
        [path addLineToPoint:CGPointMake(CGRectGetWidth(m_viewMain.bounds), nY)];
        
        m_todayLayer = [CAShapeLayer layer];
        m_todayLayer.path = [path CGPath];
        m_todayLayer.strokeColor = [UIColor redColor].CGColor;
        m_todayLayer.lineWidth = 1.0;
        m_todayLayer.fillColor = [[UIColor clearColor] CGColor];
        
        [m_viewMain.layer addSublayer:m_todayLayer];
        
        [self setNeedsLayout];
    }
    
    [self reloadData];
}

- (void)reloadData {
    for(UIView *view in m_viewMain.subviews) {
        if([view isKindOfClass:[JHEventView class]]) {
            [view removeFromSuperview];
        }
    }
    
    NSArray *aryEvents = [self.dataSource eventsInDayView:self];
    for(JHEvent *event in aryEvents) {
        JHEventView *viewEvent = [[[NSBundle mainBundle] loadNibNamed:@"JHEventView" owner:nil options:nil] objectAtIndex:0];
        [viewEvent setViewWithEvent:event];
        viewEvent.delegate = self;
        
        [m_viewMain addSubview:viewEvent];
    }
    
    [self setNeedsLayout];
}

- (void)onLongPressDayView:(UILongPressGestureRecognizer *)gesture {
    CGPoint point = [gesture locationInView:m_sclMain];
    if (gesture.state == UIGestureRecognizerStateBegan) {
        JHEvent *new_event = [[JHEvent alloc] createNewEvent];
        new_event.event_display_at = self.view_date;
        new_event.event_start_at = [self dateFromPoint:point];
        new_event.event_end_at = [new_event.event_start_at dateByAddingHours:1];
        
        m_newEventView = [[[NSBundle mainBundle] loadNibNamed:@"JHEventView" owner:nil options:nil] objectAtIndex:0];
        m_newEventView.alpha = 0.5f;
        [m_newEventView setViewWithEvent:new_event];
        m_newEventView.delegate = self;
        
        [m_viewMain addSubview:m_newEventView];
        
        [self setNeedsLayout];
        
    } else if(gesture.state == UIGestureRecognizerStateChanged) {
        NSDate *new_date = [self dateFromPoint:point];
        JHEvent *new_event = m_newEventView.m_event;
        
        if([new_date compare:new_event.event_start_at] != NSOrderedSame) {
            new_event.event_start_at = new_date;
            new_event.event_end_at = [new_date dateByAddingHours:1];
            [m_newEventView setViewWithEvent:new_event];
            
            [self setNeedsLayout];
        }
        
    } else if(gesture.state == UIGestureRecognizerStateEnded) {
        [m_newEventView removeFromSuperview];
        [self setNeedsLayout];
        
        if([self.delegate respondsToSelector:@selector(dayView:createNewEvent:)]) {
            [self.delegate dayView:self createNewEvent:m_newEventView.m_event];
        }
        
        m_newEventView = nil;
    }
}

- (NSDate *)dateFromPoint:(CGPoint)point {
    int nHour = (point.y - VIEW_TOP_MARGIN) / (m_hourHeight / 2);
    
    NSDate *start_at = [self.view_date dateBySettingHours:nHour / 2];
    start_at = [start_at dateByAddingMinutes:(nHour % 2) * 30];
    
    return start_at;
}

#pragma mark - JHEventViewDelegate

- (void)onTapEvent:(JHEvent *)event {
    if([self.delegate respondsToSelector:@selector(dayView:didSelectedEvent:)]) {
        [self.delegate dayView:self didSelectedEvent:event];
    }
}

- (void)onTapToHandle:(JHEvent *)event driverId:(NSNumber *)driver_id {
    if([self.delegate respondsToSelector:@selector(dayView:didChangedEvent:Driver:isTo:)]) {
        [self.delegate dayView:self didChangedEvent:event Driver:driver_id isTo:YES];
    }
}

- (void)onTapFromHandle:(JHEvent *)event driverId:(NSNumber *)driver_id {
    if([self.delegate respondsToSelector:@selector(dayView:didChangedEvent:Driver:isTo:)]) {
        [self.delegate dayView:self didChangedEvent:event Driver:driver_id isTo:NO];
    }
}

@end
