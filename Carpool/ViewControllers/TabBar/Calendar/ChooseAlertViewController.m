//
//  ChooseAlertViewController.m
//  Carpool
//
//  Created by JH Lee on 4/18/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import "ChooseAlertViewController.h"
#import "AlertTableViewCell.h"

@interface ChooseAlertViewController ()

@end

@implementation ChooseAlertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    m_dicAlert = @{
                   @-300:  @"5 minutes before",
                   @-600:  @"10 minutes before",
                   @-900:  @"15 minutes before",
                   @-1800: @"30 minutes before",
                   @-3600: @"1 hour before",
                   @-7200: @"2 hours before"
                  };
    
    m_aryAlertKyes = @[@-300, @-600, @-900, @-1800, @-3600, @-7200];
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

- (IBAction)onClickBtnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - TableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0) {
        return 1;
    } else {
        return m_aryAlertKyes.count;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0) {
        AlertTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AlertTableViewCell"];
        cell.m_lblAlert.text = @"None";
        cell.m_lblDivider.hidden = YES;
        cell.m_imgStatus.hidden = YES;
        
        [cell setBackgroundColor:[UIColor clearColor]];
        return cell;
    } else {
        AlertTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AlertTableViewCell"];
        
        if(indexPath.row == 0) {
            cell.m_imgBackground.image = [UIImage imageNamed:@"login_image_topcell"];
            cell.m_lblDivider.hidden = NO;
        }else if(indexPath.row == m_aryAlertKyes.count - 1) {
            cell.m_imgBackground.image = [UIImage imageNamed:@"login_image_bottomcell"];
            cell.m_lblDivider.hidden = YES;
        } else {
            cell.m_imgBackground.image = [UIImage imageNamed:@"login_image_midcell"];
            cell.m_lblDivider.hidden = NO;
        }
        
        cell.m_lblAlert.text = m_dicAlert[m_aryAlertKyes[indexPath.row]];
        if(self.selected_event_detail.event_detail_alert_time.intValue == [m_aryAlertKyes[indexPath.row] intValue]) {
            cell.m_imgStatus.hidden = NO;
        } else {
            cell.m_imgStatus.hidden = YES;
        }
        
        [cell setBackgroundColor:[UIColor clearColor]];
        return cell;
    }
}

#pragma mark - TableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber *alert = @0;
    if(indexPath.section == 1) {
        alert = m_aryAlertKyes[indexPath.row];
    }
    
    self.selected_event_detail.event_detail_alert_time = alert;
    [self.navigationController popViewControllerAnimated:YES];
}

@end
