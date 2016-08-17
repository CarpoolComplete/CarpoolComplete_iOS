//
//  MemberRootViewController.m
//  Carpool
//
//  Created by JH Lee on 4/26/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import "MemberRootViewController.h"
#import "MemberHeaderTableViewCell.h"
#import "MemberBodyTableViewCell.h"
#import "AddFamilyViewController.h"
#import "EditAdultViewController.h"
#import "EditPassengerViewController.h"

@interface MemberRootViewController ()

@end

@implementation MemberRootViewController

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
    [self.m_tblMember reloadData];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)onClickBtnMenu:(id)sender {
    [self.sideMenuViewController presentLeftMenuViewController];
}

- (IBAction)onClickBtnAddFamily:(id)sender {
    AddFamilyViewController *addFamilyVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AddFamilyViewController"];
    addFamilyVC.m_come_from_member = YES;
    [self.navigationController pushViewController:addFamilyVC animated:YES];
}

#pragma mark - TableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 30.f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0) {  //carpool
        return 1;
    } else if(section == 1) {   //drivers
        return [GlobalService sharedInstance].user_me.my_adults.count + 2;
    } else {   // passenger
        return [GlobalService sharedInstance].user_me.my_passengers.count + 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0) {
        MemberHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MemberHeaderTableViewCell"];
        cell.m_imgIcon.image = [cell.m_imgIcon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [cell.m_imgIcon setTintColor:[UIColor whiteColor]];
        [cell setBackgroundColor:[UIColor clearColor]];
        
        return cell;
    } else if(indexPath.section == 1) {
        if(indexPath.row == 0) {
            MemberHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MemberHeaderTableViewCell"];
            cell.m_imgBackground.image = [UIImage imageNamed:@"members_icon_topcell"];
            cell.m_lblTitle.text = @"Your Profile";
            cell.m_imgIcon.image = [UIImage imageNamed:@"login_icon_user"];
            cell.m_imgIcon.image = [cell.m_imgIcon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [cell.m_imgIcon setTintColor:[UIColor whiteColor]];
            cell.m_imgMarker.hidden = YES;
            [cell setBackgroundColor:[UIColor clearColor]];
            
            return cell;
        } else if(indexPath.row == 1) {
            if([GlobalService sharedInstance].user_me.my_adults.count == 0) {
                MemberBodyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MemberBodyTableViewCell"];
                cell.m_imgBackground.image = [UIImage imageNamed:@"login_image_bottomcell"];
                cell.m_lblName.text = [NSString stringWithFormat:@"%@ %@", [GlobalService sharedInstance].user_me.my_user.user_first_name, [GlobalService sharedInstance].user_me.my_user.user_last_name];
                cell.m_imgMarker.image = [cell.m_imgMarker.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                [cell.m_imgMarker setTintColor:[UIColor hx_colorWithHexRGBAString:@"#007AFF"]];
                cell.m_lblDivider.hidden = YES;
                [cell setBackgroundColor:[UIColor clearColor]];
                
                return cell;

            } else {
                MemberBodyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MemberBodyTableViewCell"];
                cell.m_imgBackground.image = [UIImage imageNamed:@"login_image_midcell"];
                cell.m_lblName.text = [NSString stringWithFormat:@"%@ %@", [GlobalService sharedInstance].user_me.my_user.user_first_name, [GlobalService sharedInstance].user_me.my_user.user_last_name];
                cell.m_imgMarker.image = [cell.m_imgMarker.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                [cell.m_imgMarker setTintColor:[UIColor hx_colorWithHexRGBAString:@"#007AFF"]];
                cell.m_lblDivider.hidden = NO;
                [cell setBackgroundColor:[UIColor clearColor]];
                
                return cell;
            }
        } else if(indexPath.row == [GlobalService sharedInstance].user_me.my_adults.count + 1) {
            UserObj *objAdult = [GlobalService sharedInstance].user_me.my_adults[indexPath.row - 2];
            
            MemberBodyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MemberBodyTableViewCell"];
            cell.m_imgBackground.image = [UIImage imageNamed:@"login_image_bottomcell"];
            cell.m_lblName.text = [NSString stringWithFormat:@"%@ %@", objAdult.user_first_name, objAdult.user_last_name];
            cell.m_imgMarker.image = [cell.m_imgMarker.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [cell.m_imgMarker setTintColor:[UIColor hx_colorWithHexRGBAString:@"#007AFF"]];
            cell.m_lblDivider.hidden = YES;
            [cell setBackgroundColor:[UIColor clearColor]];
            
            return cell;
        } else {
            UserObj *objAdult = [GlobalService sharedInstance].user_me.my_adults[indexPath.row - 2];
            
            MemberBodyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MemberBodyTableViewCell"];
            cell.m_imgBackground.image = [UIImage imageNamed:@"login_image_midcell"];
            cell.m_lblName.text = [NSString stringWithFormat:@"%@ %@", objAdult.user_first_name, objAdult.user_last_name];
            cell.m_imgMarker.image = [cell.m_imgMarker.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [cell.m_imgMarker setTintColor:[UIColor hx_colorWithHexRGBAString:@"#007AFF"]];
            cell.m_lblDivider.hidden = NO;
            [cell setBackgroundColor:[UIColor clearColor]];
            
            return cell;
        }
    } else {
        if(indexPath.row == 0 && [GlobalService sharedInstance].user_me.my_passengers.count == 0) {
            MemberHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MemberHeaderTableViewCell"];
            cell.m_imgBackground.image = [UIImage imageNamed:@"members_icon_onecell"];
            cell.m_lblTitle.text = @"Your Passengers";
            cell.m_imgIcon.image = [UIImage imageNamed:@"login_icon_users"];
            cell.m_imgIcon.image = [cell.m_imgIcon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [cell.m_imgIcon setTintColor:[UIColor whiteColor]];
            cell.m_imgMarker.hidden = YES;
            [cell setBackgroundColor:[UIColor clearColor]];
            
            return cell;
        } else if(indexPath.row == 0) {
            MemberHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MemberHeaderTableViewCell"];
            cell.m_imgBackground.image = [UIImage imageNamed:@"members_icon_topcell"];
            cell.m_lblTitle.text = @"Your Passengers";
            cell.m_imgIcon.image = [UIImage imageNamed:@"login_icon_users"];
            cell.m_imgIcon.image = [cell.m_imgIcon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [cell.m_imgIcon setTintColor:[UIColor whiteColor]];
            cell.m_imgMarker.hidden = YES;
            [cell setBackgroundColor:[UIColor clearColor]];
            
            return cell;
        }else if(indexPath.row == [GlobalService sharedInstance].user_me.my_passengers.count) {
            PassengerObj *objPassenger = [GlobalService sharedInstance].user_me.my_passengers[indexPath.row - 1];
            
            MemberBodyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MemberBodyTableViewCell"];
            cell.m_imgBackground.image = [UIImage imageNamed:@"login_image_bottomcell"];
            cell.m_lblName.text = [NSString stringWithFormat:@"%@ %@", objPassenger.passenger_first_name, objPassenger.passenger_last_name];
            cell.m_imgMarker.image = [cell.m_imgMarker.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [cell.m_imgMarker setTintColor:[UIColor hx_colorWithHexRGBAString:@"#007AFF"]];
            cell.m_lblDivider.hidden = YES;
            [cell setBackgroundColor:[UIColor clearColor]];
            
            return cell;
        } else {
            PassengerObj *objPassenger = [GlobalService sharedInstance].user_me.my_passengers[indexPath.row - 1];
            
            MemberBodyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MemberBodyTableViewCell"];
            cell.m_imgBackground.image = [UIImage imageNamed:@"login_image_midcell"];
            cell.m_lblName.text = [NSString stringWithFormat:@"%@ %@", objPassenger.passenger_first_name, objPassenger.passenger_last_name];
            cell.m_imgMarker.image = [cell.m_imgMarker.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [cell.m_imgMarker setTintColor:[UIColor hx_colorWithHexRGBAString:@"#007AFF"]];
            cell.m_lblDivider.hidden = NO;
            [cell setBackgroundColor:[UIColor clearColor]];
            
            return cell;
        }
    }
}

#pragma mark - TableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0) {
        if([GlobalService sharedInstance].user_me.my_events.count == 0) {
            [[[UIAlertView alloc] initWithTitle:APP_NAME
                                        message:@"Sorry, You have no Carpool now."
                                       delegate:nil
                              cancelButtonTitle:@"Ok"
                              otherButtonTitles:nil, nil] show];
        } else {
            UIViewController *memberCarpoolVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MemberCarpoolsViewController"];
            [self.navigationController pushViewController:memberCarpoolVC animated:YES];
        }
    } else if(indexPath.section == 1) {
        if(indexPath.row > 0) {
            EditAdultViewController *editAdultVC = [self.storyboard instantiateViewControllerWithIdentifier:@"EditAdultViewController"];

            if(indexPath.row == 1) {
                editAdultVC.selected_adult = [GlobalService sharedInstance].user_me.my_user;
            } else {
                editAdultVC.selected_adult = [GlobalService sharedInstance].user_me.my_adults[indexPath.row - 2];
            }
            
            [self.navigationController pushViewController:editAdultVC animated:YES];
        }
    } else {
        if(indexPath.row > 0) {
            EditPassengerViewController *editPassengerVC = [self.storyboard instantiateViewControllerWithIdentifier:@"EditPassengerViewController"];
            editPassengerVC.selected_passenger = [GlobalService sharedInstance].user_me.my_passengers[indexPath.row - 1];
            [self.navigationController pushViewController:editPassengerVC animated:YES];
        }
    }
}

@end
