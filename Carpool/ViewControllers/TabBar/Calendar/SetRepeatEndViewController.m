//
//  SetRepeatEndViewController.m
//  Carpool
//
//  Created by JH Lee on 4/18/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import "SetRepeatEndViewController.h"

@interface SetRepeatEndViewController ()

@end

@implementation SetRepeatEndViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //FSCalendarAppearanceSetting
    self.m_monthView.appearance.todayColor = [UIColor blueColor];
    self.m_monthView.appearance.selectionColor = [UIColor hx_colorWithHexRGBAString:@"#FB9C49"];
    
    tempEvent = [[EventObj alloc] initWithEventObj:self.selected_event];
    if(tempEvent.event_id.integerValue == 0
       && tempEvent.event_repeat_type == EVENT_REPEAT_CUSTOM) {
        [tempEvent.event_custom_repeat_dates addObject:[self.m_monthView stringFromDate:tempEvent.event_repeat_start_at format:@"yyyy-MM-dd"]];
    }
    
    self.m_lblCalendarDate.text = [self.m_monthView stringFromDate:self.m_monthView.currentPage format:@"MMMM yyyy"];
    [self setEndDate:tempEvent.event_repeat_end_at];
    
    if(tempEvent.event_repeat_no_end) {
        self.m_swtSetRepeatEnd.on = NO;
        [self onSwitchCalendar:self.m_swtSetRepeatEnd];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)onClickBtnDone:(id)sender {
    if(tempEvent.event_repeat_type == EVENT_REPEAT_CUSTOM
       && tempEvent.event_custom_repeat_dates.count > 0) {
        self.selected_event.event_custom_repeat_dates = tempEvent.event_custom_repeat_dates;
    }
    
    self.selected_event.event_repeat_end_at = tempEvent.event_repeat_end_at;
    self.selected_event.event_repeat_no_end = tempEvent.event_repeat_no_end;
    [self.navigationController popToViewController:[GlobalService sharedInstance].push_start_vc animated:YES];
}

- (IBAction)onClickBtnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onSwitchCalendar:(id)sender {
    UISwitch *swtCalendar = (UISwitch *)sender;
    if(swtCalendar.on) {
        tempEvent.event_repeat_end_at = tempEvent.event_repeat_start_at;
    } else {
        tempEvent.event_repeat_end_at = [tempEvent.event_repeat_start_at dateByAddingYears:10];
    }
    self.m_viewContainer.hidden = !swtCalendar.on;
    tempEvent.event_repeat_no_end = !swtCalendar.on;
}

- (IBAction)onClickBtnPrev:(id)sender {
    NSDate *currentMonth = self.m_monthView.currentPage;
    NSDate *previousMonth = [self.m_monthView dateBySubstractingMonths:1 fromDate:currentMonth];
    [self.m_monthView setCurrentPage:previousMonth animated:YES];
}

- (IBAction)onClickBtnNext:(id)sender {
    NSDate *currentMonth = self.m_monthView.currentPage;
    NSDate *nextMonth = [self.m_monthView dateByAddingMonths:1 toDate:currentMonth];
    [self.m_monthView setCurrentPage:nextMonth animated:YES];
}

#pragma mark - FSCalendarDelegate
- (void)calendarCurrentPageDidChange:(FSCalendar *)calendar {
    self.m_lblCalendarDate.text = [calendar stringFromDate:calendar.currentPage format:@"MMMM yyyy"];
}

- (UIImage *)calendar:(FSCalendar *)calendar imageForDate:(NSDate *)date {
    if([self isValidDate:date]) {
        return [UIImage imageNamed:@"event_alert_check.png"];
    } else {
        return nil;
    }
}

- (BOOL)calendar:(FSCalendar *)calendar shouldSelectDate:(NSDate *)date {
    if([tempEvent.event_repeat_start_at.dateAtBeginningOfDay compare:date] == NSOrderedDescending
       || [[NSDate date].dateAtBeginningOfDay compare:date] == NSOrderedDescending) {
        return NO;
    }
    
    if(tempEvent.event_repeat_type == EVENT_REPEAT_CUSTOM) {
        NSString *custom_date = [self.m_monthView stringFromDate:date format:@"yyyy-MM-dd"];
        if([tempEvent.event_custom_repeat_dates containsObject:custom_date]) {
            [tempEvent.event_custom_repeat_dates removeObject:custom_date];
        } else {
            [tempEvent.event_custom_repeat_dates addObject:custom_date];
        }
        
        if(tempEvent.event_custom_repeat_dates.count > 0) {
            tempEvent.event_custom_repeat_dates = [[[[NSSet setWithArray:tempEvent.event_custom_repeat_dates] allObjects] sortedArrayUsingSelector:@selector(compare:)] mutableCopy];
            tempEvent.event_repeat_end_at = [[GlobalService sharedInstance] dateFromString:tempEvent.event_custom_repeat_dates[tempEvent.event_custom_repeat_dates.count - 1]
                                                                                withFormat:@"yyyy-MM-dd"];
        }
        
    } else {
        tempEvent.event_repeat_end_at = date;
    }
    
    [self setEndDate:tempEvent.event_repeat_end_at];
    
    [calendar reloadData];
    
    return NO;
}

- (void)setEndDate:(NSDate *)date {
    NSString *strRepeatEndDate = [self.m_monthView stringFromDate:date format:@"dd MMMM EEEE"];
    NSArray *aryRepeatEndDateComponents = [strRepeatEndDate componentsSeparatedByString:@" "];
    self.m_lblEndDate.text = aryRepeatEndDateComponents[0];
    self.m_lblEndWeek.text = [NSString stringWithFormat:@"%@\n%@", aryRepeatEndDateComponents[1], aryRepeatEndDateComponents[2]];
}

- (BOOL)isValidDate:(NSDate *)date {
    BOOL isValid = NO;
    
    NSString *strDate = [self.m_monthView stringFromDate:date format:@"yyyy-MM-dd"];
    if([tempEvent.event_deleted_dates containsObject:strDate]
       || [tempEvent.event_repeat_start_at.dateAtBeginningOfDay compare:date] == NSOrderedDescending) {
        return NO;
    }
    
    if(tempEvent.event_repeat_type == EVENT_REPEAT_CUSTOM) {
        
        if([tempEvent.event_custom_repeat_dates containsObject:strDate]) {
            isValid = YES;
        }
        
    } else {    // repeat
        if([tempEvent.event_repeat_end_at compare:date] != NSOrderedAscending)  {
            switch (tempEvent.event_repeat_type) {
                case EVENT_REPEAT_EVERY_DAY:
                    isValid = YES;
                    break;
                    
                case EVENT_REPEAT_EVERY_WEEKDAY:
                    if([self.m_monthView weekdayOfDate:date] != 1
                       && [self.m_monthView weekdayOfDate:date] != 7) {
                        isValid = YES;
                    }
                    break;
                    
                case EVENT_REPEAT_WEEKLY:
                    if([self.m_monthView weekdayOfDate:tempEvent.event_repeat_start_at] == [self.m_monthView weekdayOfDate:date]) {
                        isValid = YES;
                    }
                    break;
                    
                case EVENT_REPEAT_OTHER_WEEKLY:
                    if([self.m_monthView weekdayOfDate:tempEvent.event_repeat_start_at] == [self.m_monthView weekdayOfDate:date]) {
                        if(([self.m_monthView weekOfDate:date] - [self.m_monthView weekOfDate:tempEvent.event_repeat_start_at]) % 2 == 0) {
                            isValid = YES;
                        }
                    }
                    break;
                    
                case EVENT_REPEAT_EVERY_MONTH:
                    if([self.m_monthView dayOfDate:tempEvent.event_repeat_start_at] == [self.m_monthView dayOfDate:date]) {
                        isValid = YES;
                    }
                    
                    break;
                    
                default:
                    break;
            }
        }
    }
    
    return isValid;
}

@end
