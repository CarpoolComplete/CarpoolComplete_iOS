//
//  SettingsViewController.h
//  Carpool
//
//  Created by JH Lee on 4/29/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UISwitch *m_swtSync;

- (IBAction)onClickBtnPushNotification:(id)sender;
- (IBAction)onClickBtnRateApp:(id)sender;
- (IBAction)onClickBtnResetPassword:(id)sender;
- (IBAction)onChangeSyncSetting:(id)sender;
- (IBAction)onClickBtnSetting:(id)sender;
- (IBAction)onClickBtnUpgradeAccount:(id)sender;

@end
