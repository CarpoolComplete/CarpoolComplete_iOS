//
//  AddFamilyViewController.m
//  Carpool
//
//  Created by JH Lee on 4/11/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import "AddFamilyViewController.h"
#import "FamilyHeaderView.h"
#import "FamilyTableViewCell.h"


@interface AddFamilyViewController ()

@end

@implementation AddFamilyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if(self.m_come_from_member) {
        self.m_btnCancel.hidden = NO;
    } else {
        self.m_btnCancel.hidden = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.m_tblFamily reloadData];
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
                                                    message:@"Finished adding your family?"
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Yes", nil];
    [alert show];
}

- (IBAction)onClickBtnCancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - TableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    FamilyHeaderView *headerView = [[[NSBundle mainBundle] loadNibNamed:@"FamilyHeaderView" owner:nil options:nil] objectAtIndex:0];
    if(section == 0) {
        headerView.m_lblTitle.text = @"Adult Driver";
    } else {
        headerView.m_lblTitle.text = @"Your Children";
    }
    return headerView;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0) {
        return 2;
    } else {
        return [GlobalService sharedInstance].user_me.my_passengers.count + 1;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0) {
        FamilyTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"FamilyTableViewCell" owner:nil options:nil] objectAtIndex:0];
        
        if(indexPath.row == 0) {
            [cell setViewsWithPosition:CELL_POSITION_TOP withTitle:[GlobalService sharedInstance].user_me.my_user.fullName];
        } else {
            if([GlobalService sharedInstance].user_me.my_adults.count == 0) {
                [cell setViewsWithPosition:CELL_POSITION_ADD_NEW withTitle:@"Add Adult"];
            } else {
                UserObj *objAdult = [GlobalService sharedInstance].user_me.my_adults[0];
                NSString *adult_name = [NSString stringWithFormat:@"%@ %@", objAdult.user_first_name, objAdult.user_last_name];
                [cell setViewsWithPosition:CELL_POSITION_BOTTOM withTitle:adult_name];
            }
        }
        [cell setBackgroundColor:[UIColor clearColor]];
        
        return cell;
    } else {
        FamilyTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"FamilyTableViewCell" owner:nil options:nil] objectAtIndex:0];
        
        if(indexPath.row == 0 && [GlobalService sharedInstance].user_me.my_passengers.count == 0) {
            [cell setViewsWithPosition:CELL_POSITION_SINGLE withTitle:@"Add a Child"];
        } else if(indexPath.row == 0) {
            PassengerObj *objPassenger = [GlobalService sharedInstance].user_me.my_passengers[indexPath.row];
            NSString *passenger_name = [NSString stringWithFormat:@"%@ %@", objPassenger.passenger_first_name, objPassenger.passenger_last_name];
            [cell setViewsWithPosition:CELL_POSITION_TOP withTitle:passenger_name];
        }else if(indexPath.row == [GlobalService sharedInstance].user_me.my_passengers.count) {
            [cell setViewsWithPosition:CELL_POSITION_ADD_NEW withTitle:@"Add a Child"];
        } else {
            PassengerObj *objPassenger = [GlobalService sharedInstance].user_me.my_passengers[indexPath.row];
            NSString *passenger_name = [NSString stringWithFormat:@"%@ %@", objPassenger.passenger_first_name, objPassenger.passenger_last_name];
            [cell setViewsWithPosition:CELL_POSITION_MIDDLE withTitle:passenger_name];
        }
        [cell setBackgroundColor:[UIColor clearColor]];
        
        return cell;
    }
}

#pragma mark - TableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0) {
        if(indexPath.row == 1
           && [GlobalService sharedInstance].user_me.my_adults.count == 0) {
            UIViewController *addAdultVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AddAdultViewController"];
            [self.navigationController pushViewController:addAdultVC animated:YES];
        }
    } else {
        if(indexPath.row == [GlobalService sharedInstance].user_me.my_passengers.count) {
            UIViewController *addChildVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AddChildViewController"];
            [self.navigationController pushViewController:addChildVC animated:YES];
        }
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 1) {
        if(self.m_come_from_member) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            UIViewController *syncVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SyncViewController"];
            [self.navigationController pushViewController:syncVC animated:YES];
        }
    }
}

@end
