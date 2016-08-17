//
//  JHEventDayView.h
//  Carpool
//
//  Created by JH Lee on 4/15/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHEvent.h"
#import "JHEventView.h"

@protocol JHEventDayViewDataSource, JHEventDayViewDelegate;

IB_DESIGNABLE @interface JHEventDayView : UIView<JHEventViewDelegate> {
    NSArray             *m_aryHourString;
    NSArray             *m_aryEventColor;
    NSMutableArray      *m_aryEventViews;
    
    UIScrollView        *m_sclMain;
    UIView              *m_viewTime;
    UIView              *m_viewMain;
    CGFloat             m_hourHeight;
    CGFloat             m_minimumHeight;
    CAShapeLayer        *m_todayLayer;
    
    JHEventView         *m_newEventView;
    JHEventView         *firstView;
}

@property (nonatomic, retain) IBInspectable UIColor                 *hour_line_color;
@property (nonatomic, retain) IBInspectable UIColor                 *minute_line_color;

@property (nonatomic, retain) IBOutlet id<JHEventDayViewDataSource> dataSource;
@property (nonatomic, retain) IBOutlet id<JHEventDayViewDelegate>   delegate;

@property (nonatomic, copy) NSDate                                  *view_date;

- (void)scrollToJHEvent:(JHEvent *)event;
- (NSDate *)dateFromPoint:(CGPoint)point;
- (CGPoint)getCurrentPoint;
- (void)setContentOffset:(CGPoint)point animated:(BOOL)animated;
- (void)setScrollEnabled:(BOOL)enabled;

@end

@protocol JHEventDayViewDataSource <NSObject>

@required
- (NSArray *)eventsInDayView:(JHEventDayView *)dayView;

@optional
- (NSArray *)hourTitlesInDayView:(JHEventDayView *)dayView;
- (NSArray *)eventColorsInDayView:(JHEventDayView *)dayView;

@end

@protocol JHEventDayViewDelegate <NSObject>

@optional

- (void)dayView:(JHEventDayView *)dayView didSelectedEvent:(JHEvent *)event;
- (void)dayView:(JHEventDayView *)dayView createNewEvent:(JHEvent *)event;
- (void)dayView:(JHEventDayView *)dayView didChangedEvent:(JHEvent *)event Driver:(NSNumber *)driver_id isTo:(BOOL)isTo;

@end