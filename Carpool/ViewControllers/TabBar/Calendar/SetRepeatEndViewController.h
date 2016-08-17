//
//  SetRepeatEndViewController.h
//  Carpool
//
//  Created by JH Lee on 4/18/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHView.h"

@interface SetRepeatEndViewController : UIViewController {
    EventObj    *tempEvent;
}

@property (weak, nonatomic) IBOutlet JHView         *m_viewContainer;
@property (weak, nonatomic) IBOutlet UILabel        *m_lblEndDate;
@property (weak, nonatomic) IBOutlet UILabel        *m_lblEndWeek;
@property (weak, nonatomic) IBOutlet UILabel        *m_lblCalendarDate;
@property (weak, nonatomic) IBOutlet UISwitch       *m_swtSetRepeatEnd;
@property (weak, nonatomic) IBOutlet FSCalendar     *m_monthView;

@property (nonatomic, retain) EventObj              *selected_event;

- (IBAction)onClickBtnDone:(id)sender;
- (IBAction)onClickBtnBack:(id)sender;
- (IBAction)onSwitchCalendar:(id)sender;
- (IBAction)onClickBtnPrev:(id)sender;
- (IBAction)onClickBtnNext:(id)sender;

@end
