//
//  EventAddChildViewController.m
//  Carpool
//
//  Created by JH Lee on 4/23/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import "EventAddChildViewController.h"
#import "FamilyTableViewCell.h"
#import "AddPassengersViewController.h"

@interface EventAddChildViewController ()

@end

@implementation EventAddChildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if([GlobalService sharedInstance].user_me.my_passengers.count == 0) {
        self.m_lblAlert.hidden = NO;
    } else {
        self.m_lblAlert.hidden = YES;
    }
    
    [self.m_tblChild reloadData];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onClickBtnDone:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Carpool Complete"
                                                    message:@"Finished adding your children?"
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Yes", nil];
    [alert show];
}

- (IBAction)onClickBtnCancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - TableViewDataSource

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [GlobalService sharedInstance].user_me.my_passengers.count + 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FamilyTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"FamilyTableViewCell" owner:nil options:nil] objectAtIndex:0];
    
    if(indexPath.row == 0 && [GlobalService sharedInstance].user_me.my_passengers.count == 0) {
        [cell setViewsWithPosition:CELL_POSITION_SINGLE withTitle:@"Add a Child"];
    } else if(indexPath.row == 0) {
        PassengerObj *objPassenger = [GlobalService sharedInstance].user_me.my_passengers[indexPath.row];
        NSString *passenger_name = [NSString stringWithFormat:@"%@ %@", objPassenger.passenger_first_name, objPassenger.passenger_last_name];
        [cell setViewsWithPosition:CELL_POSITION_TOP withTitle:passenger_name];
    }else if(indexPath.row == [GlobalService sharedInstance].user_me.my_passengers.count) {
        [cell setViewsWithPosition:CELL_POSITION_BOTTOM withTitle:@"Add a Child"];
    } else {
        PassengerObj *objPassenger = [GlobalService sharedInstance].user_me.my_passengers[indexPath.row];
        NSString *passenger_name = [NSString stringWithFormat:@"%@ %@", objPassenger.passenger_first_name, objPassenger.passenger_last_name];
        [cell setViewsWithPosition:CELL_POSITION_MIDDLE withTitle:passenger_name];
    }
    return cell;
}

#pragma mark - TableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == [GlobalService sharedInstance].user_me.my_passengers.count) {
        UIViewController *addChildVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AddChildViewController"];
        [self.navigationController pushViewController:addChildVC animated:YES];
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 1) {
        AddPassengersViewController *addPassengersVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AddPassengersViewController"];
        addPassengersVC.m_aryPassengers = self.m_aryPassengers;
        [self.navigationController pushViewController:addPassengersVC animated:YES];
    }
}

@end
