//
//  SettingsViewController.m
//  Carpool
//
//  Created by JH Lee on 4/29/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.m_swtSync.on = [GlobalService sharedInstance].user_setting.settings_sync;
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

- (IBAction)onClickBtnPushNotification:(id)sender {
    UIViewController *pushVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PushSettingsViewController"];
    [self.navigationController pushViewController:pushVC animated:YES];
}

- (IBAction)onClickBtnRateApp:(id)sender {

}

- (IBAction)onClickBtnResetPassword:(id)sender {
    UIViewController *resetPasswordVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ResetPasswordViewController"];
    [self.navigationController pushViewController:resetPasswordVC animated:YES];
}

- (IBAction)onChangeSyncSetting:(id)sender {
    UISwitch *swtSync = (UISwitch *)sender;
    [GlobalService sharedInstance].user_setting.settings_sync = swtSync.isOn;
    [[GlobalService sharedInstance] saveSetting];
}

- (IBAction)onClickBtnSetting:(id)sender {
    [self.sideMenuViewController presentLeftMenuViewController];
}

- (IBAction)onClickBtnUpgradeAccount:(id)sender {
    UIViewController *upgradeAccountVC = [self.storyboard instantiateViewControllerWithIdentifier:@"UpgradeViewController"];
    [self.navigationController pushViewController:upgradeAccountVC animated:YES];
}

@end
