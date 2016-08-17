//
//  EventEditViewController.h
//  Carpool
//
//  Created by JH Lee on 4/23/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChooseRepeatViewController.h"

@interface EventEditViewController : UIViewController<UIAlertViewDelegate> {
    EventObj        *tempEvent;
    EventDetailObj  *tempEventDetail;
}

@property (weak, nonatomic) IBOutlet UILabel        *m_lblTitle;
@property (weak, nonatomic) IBOutlet UITextField    *m_txtEventTitle;
@property (weak, nonatomic) IBOutlet UILabel        *m_lblStartDate;
@property (weak, nonatomic) IBOutlet UILabel        *m_lblStartWeek;
@property (weak, nonatomic) IBOutlet UILabel        *m_lblStartTime;
@property (weak, nonatomic) IBOutlet UILabel        *m_lblEndDate;
@property (weak, nonatomic) IBOutlet UILabel        *m_lblEndWeek;
@property (weak, nonatomic) IBOutlet UILabel        *m_lblEndTime;
@property (weak, nonatomic) IBOutlet UILabel        *m_lblPassengers;
@property (weak, nonatomic) IBOutlet UILabel        *m_lblRepeats;
@property (weak, nonatomic) IBOutlet UILabel        *m_lblAlerts;

@property (nonatomic, retain) EventObj              *m_objEvent;
@property (nonatomic, retain) EventDetailObj        *m_objEventDetail;

- (IBAction)onClickBtnInviteDrivers:(id)sender;
- (IBAction)onClickBtnRemoveDrivers:(id)sender;
- (IBAction)onClickBtnCancel:(id)sender;
- (IBAction)onClickBtnDone:(id)sender;
- (IBAction)onTapStartTime:(id)sender;
- (IBAction)onTapEndTime:(id)sender;
- (IBAction)onTapRepeats:(id)sender;
- (IBAction)onTapAlerts:(id)sender;
- (IBAction)onTapPassengers:(id)sender;

@end
