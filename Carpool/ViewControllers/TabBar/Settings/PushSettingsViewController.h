//
//  PushSettingsViewController.h
//  Carpool
//
//  Created by JH Lee on 4/29/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PushSettingsViewController : UIViewController {
    NSArray             *m_aryDays;
    NSInteger           m_nDaySelectedIndex;
    
    NSMutableArray     *m_aryHours;
    NSInteger           m_nHourSelectedIndex;
}

@property (weak, nonatomic) IBOutlet UILabel *m_lblDays;
@property (weak, nonatomic) IBOutlet UILabel *m_lblHours;

- (IBAction)onChangePushSetting:(id)sender;
- (IBAction)onClickBtnBack:(id)sender;
- (IBAction)onClickComboDays:(id)sender;
- (IBAction)onClickComboHours:(id)sender;

@end
