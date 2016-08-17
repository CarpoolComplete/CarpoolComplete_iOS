//
//  SyncViewController.m
//  Carpool
//
//  Created by JH Lee on 4/11/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import "SyncViewController.h"

@interface SyncViewController ()

@end

@implementation SyncViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"EEEE dd";
    NSString *strDate = [formatter stringFromDate:[NSDate date]];
    NSArray *aryDates = [strDate componentsSeparatedByString:@" "];
    self.m_lblWeekDay.text = aryDates[0];
    self.m_lblDate.text = aryDates[1];
    
    m_sync_start_date = [NSDate date].dateAtBeginningOfDay;
    m_sync_end_date = [m_sync_start_date dateByAddingYears:SYNC_FUTURE_YEARS];
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

- (IBAction)onClickBtnSyncCalendar:(id)sender {
    [[GlobalService sharedInstance].app_delegate startApplication:YES];
}

- (IBAction)onClickBtnNoThanks:(id)sender {
    [GlobalService sharedInstance].user_setting.settings_sync = NO;
    [[GlobalService sharedInstance] saveSetting];
    [[GlobalService sharedInstance].app_delegate startApplication:YES];
}

@end
