//
//  AddPassengersViewController.m
//  Carpool
//
//  Created by JH Lee on 4/21/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import "AddPassengersViewController.h"
#import "AlertTableViewCell.h"

@interface AddPassengersViewController ()

@end

@implementation AddPassengersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    m_aryTmpPassengers = self.m_aryPassengers;
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

#pragma mark - TableViewDataSource

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [GlobalService sharedInstance].user_me.my_passengers.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PassengerObj *objPassenger = [GlobalService sharedInstance].user_me.my_passengers[indexPath.row];
    AlertTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AlertTableViewCell"];
    
    cell.m_lblAlert.text = objPassenger.initialName;
    if(indexPath.row == 0 && [GlobalService sharedInstance].user_me.my_passengers.count == 1) {
        cell.m_imgBackground.image = [UIImage imageNamed:@"login_image_onecell"];
        cell.m_lblDivider.hidden = YES;
    } else if(indexPath.row == 0) {
        cell.m_imgBackground.image = [UIImage imageNamed:@"login_image_topcell"];
        cell.m_lblDivider.hidden = NO;
    }else if(indexPath.row == [GlobalService sharedInstance].user_me.my_passengers.count - 1) {
        cell.m_imgBackground.image = [UIImage imageNamed:@"login_image_bottomcell"];
        cell.m_lblDivider.hidden = YES;
    } else {
        cell.m_imgBackground.image = [UIImage imageNamed:@"login_image_midcell"];
        cell.m_lblDivider.hidden = NO;
    }
    
    if([m_aryTmpPassengers containsObject:objPassenger.initialName]) {
        cell.m_imgStatus.hidden = NO;
    } else {
        cell.m_imgStatus.hidden = YES;
    }

    return cell;
}

#pragma mark - TableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PassengerObj *objPassenger = [GlobalService sharedInstance].user_me.my_passengers[indexPath.row];
    AlertTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.m_imgStatus.hidden = !cell.m_imgStatus.hidden;
    
    if(!cell.m_imgStatus.hidden) {
        [m_aryTmpPassengers addObject:objPassenger.initialName];
    } else {
        [m_aryTmpPassengers removeObject:objPassenger.initialName];
    }
}

- (IBAction)onClickBtnDone:(id)sender {
    [self.m_aryPassengers setArray:m_aryTmpPassengers];    
    [self.navigationController popToViewController:[GlobalService sharedInstance].push_start_vc animated:YES];
}

- (IBAction)onClickBtnCancel:(id)sender {
    [self.navigationController popToViewController:[GlobalService sharedInstance].push_start_vc animated:YES];
}

@end
