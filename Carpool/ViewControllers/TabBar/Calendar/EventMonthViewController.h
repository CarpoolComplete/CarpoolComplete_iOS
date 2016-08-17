//
//  EventMonthViewController.h
//  Carpool
//
//  Created by JH Lee on 4/16/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FSCalendar/FSCalendar.h>
#import "EventTableViewCell.h"

@interface EventMonthViewController : UIViewController<EventTableViewCellDelegate> {
    NSArray *m_arySelectedDateEvents;
}

@property (weak, nonatomic) IBOutlet UILabel *m_lblDisplayMonth;
@property (weak, nonatomic) IBOutlet FSCalendar *m_monthView;
@property (weak, nonatomic) IBOutlet UITableView *m_tblEvent;

- (IBAction)onClickBtnMenu:(id)sender;
- (IBAction)onClickBtnPrev:(id)sender;
- (IBAction)onClickBtnNext:(id)sender;
- (IBAction)onClickBtnAddEvent:(id)sender;

@end
