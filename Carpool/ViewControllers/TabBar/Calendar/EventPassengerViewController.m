//
//  EventPassengerViewController.m
//  Carpool
//
//  Created by JH Lee on 4/17/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import "EventPassengerViewController.h"
#import "AlertTableViewCell.h"

@interface EventPassengerViewController ()

@end

@implementation EventPassengerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.m_tblPassenger.layer.masksToBounds = YES;
    self.m_tblPassenger.layer.cornerRadius = 5.f;
    
    m_aryTmpPassengers = [NSMutableArray arrayWithArray:self.m_aryPassengers];
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

- (IBAction)onClickBtnCancel:(id)sender {
    [self.delegate onClickPassengerAlertCancel];
}

- (IBAction)onClickBtnDone:(id)sender {
    [self.m_aryPassengers setArray:m_aryTmpPassengers];
    [self.delegate onClickPassengerAlertDone];
}

#pragma mark - TableView DataSource

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
    if([m_aryTmpPassengers containsObject:objPassenger.initialName]) {
        cell.m_imgStatus.hidden = NO;
    } else {
        cell.m_imgStatus.hidden = YES;
    }
    
    return cell;
}

#pragma mark - TableView Delegate

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

@end
