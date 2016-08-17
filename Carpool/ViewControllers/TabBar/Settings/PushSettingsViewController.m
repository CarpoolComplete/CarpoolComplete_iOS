//
//  PushSettingsViewController.m
//  Carpool
//
//  Created by JH Lee on 4/29/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import "PushSettingsViewController.h"
#import <ActionSheetPicker-3.0/ActionSheetStringPicker.h>

@interface PushSettingsViewController ()

@end

@implementation PushSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    m_aryDays = @[@"1", @"2", @"3", @"4", @"5"];
    self.m_lblDays.text = [NSString stringWithFormat:@"%d", (int)[GlobalService sharedInstance].user_setting.settings_alert_days];
    
    m_aryHours = [[NSMutableArray alloc] init];
    self.m_lblHours.text = [GlobalService sharedInstance].user_setting.settings_alert_hours;
    for(int nIndex = 0; nIndex < 24;  nIndex++) {
        if(nIndex < 12) {
            if(nIndex == 0) {
                [m_aryHours addObject:@"12am"];
            } else {
                [m_aryHours addObject:[NSString stringWithFormat:@"%dam", nIndex]];
            }
        } else {
            if(nIndex == 12) {
                [m_aryHours addObject:@"12pm"];
            } else {
                [m_aryHours addObject:[NSString stringWithFormat:@"%dpm", nIndex - 12]];
            }
        }
    }
    
    m_nHourSelectedIndex = [m_aryHours indexOfObject:[GlobalService sharedInstance].user_setting.settings_alert_hours];
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

- (IBAction)onChangePushSetting:(id)sender {
    
}

- (IBAction)onClickBtnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onClickComboDays:(id)sender {
    ActionSheetStringPicker *picker = [[ActionSheetStringPicker alloc] initWithTitle:@""
                                                                                rows:m_aryDays
                                                                    initialSelection:[GlobalService sharedInstance].user_setting.settings_alert_days - 1
                                                                           doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                                                               self.m_lblDays.text = m_aryDays[selectedIndex];
                                                                               [GlobalService sharedInstance].user_setting.settings_alert_days = selectedIndex + 1;
                                                                               [[GlobalService sharedInstance] saveSetting];
                                                                           }
                                                                         cancelBlock:nil
                                                                              origin:sender];
    
    [picker showActionSheetPicker];
}

- (IBAction)onClickComboHours:(id)sender {
    ActionSheetStringPicker *picker = [[ActionSheetStringPicker alloc] initWithTitle:@""
                                                                                rows:m_aryHours
                                                                    initialSelection:m_nHourSelectedIndex
                                                                           doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                                                               m_nHourSelectedIndex = selectedIndex;
                                                                               self.m_lblHours.text = m_aryHours[selectedIndex];
                                                                               [GlobalService sharedInstance].user_setting.settings_alert_hours = m_aryHours[selectedIndex];
                                                                               [[GlobalService sharedInstance] saveSetting];
                                                                           }
                                                                         cancelBlock:nil
                                                                              origin:sender];
    
    [picker showActionSheetPicker];
}

@end
