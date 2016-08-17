//
//  ChooseRepeatViewController.m
//  Carpool
//
//  Created by JH Lee on 4/18/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import "ChooseRepeatViewController.h"
#import "AlertTableViewCell.h"

@interface ChooseRepeatViewController ()

@end

@implementation ChooseRepeatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    m_aryRepeatString = @[
                          @"Never",
                          @"Every Day",
                          @"Every Weekday",
                          @"Weekly",
                          @"Other Weekly",
                          @"Every Month"
                          ];
    
    tempEvent = [[EventObj alloc] initWithEventObj:self.selected_event];
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

- (IBAction)onClickBtnDone:(id)sender {
    self.selected_event.event_repeat_type = tempEvent.event_repeat_type;
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - TableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0) {
        return m_aryRepeatString.count;
    } else {
        return 1;
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
        
        if(indexPath.row == 0) {
            cell.m_imgBackground.image = [UIImage imageNamed:@"login_image_topcell"];
            cell.m_lblDivider.hidden = NO;
        }else if(indexPath.row == m_aryRepeatString.count - 1) {
            cell.m_imgBackground.image = [UIImage imageNamed:@"login_image_bottomcell"];
            cell.m_lblDivider.hidden = YES;
        } else {
            cell.m_imgBackground.image = [UIImage imageNamed:@"login_image_midcell"];
            cell.m_lblDivider.hidden = NO;
        }
        
        cell.m_lblAlert.text = m_aryRepeatString[indexPath.row];
        if(tempEvent.event_repeat_type == indexPath.row) {
            cell.m_imgStatus.hidden = NO;
        } else {
            cell.m_imgStatus.hidden = YES;
        }
        
        [cell setBackgroundColor:[UIColor clearColor]];
        return cell;
    } else {
        AlertTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AlertTableViewCell"];
        cell.m_lblAlert.text = @"Custom";
        cell.m_lblDivider.hidden = YES;
        if(tempEvent.event_repeat_type == m_aryRepeatString.count) {
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
    if(indexPath.section == 0) {
        tempEvent.event_repeat_type = (EVENT_REPEAT_TYPE)indexPath.row;
    } else {
        tempEvent.event_repeat_type = EVENT_REPEAT_CUSTOM;
    }
    
    [self.m_tblRepeat reloadData];
    
    if(indexPath.section != 0 || indexPath.row != 0) { // not never
        self.selected_event.event_repeat_type = tempEvent.event_repeat_type;
        SetRepeatEndViewController *endRepeatVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SetRepeatEndViewController"];
        endRepeatVC.selected_event = self.selected_event;
        [self.navigationController pushViewController:endRepeatVC animated:YES];
    }
}

@end
