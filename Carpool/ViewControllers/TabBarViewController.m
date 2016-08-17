//
//  TabBarViewController.m
//  Carpool
//
//  Created by JH Lee on 4/11/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import "TabBarViewController.h"
#import <RDVTabBarController/RDVTabBarItem.h>

@interface TabBarViewController ()

@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.m_eventMonthVC = [self.storyboard instantiateViewControllerWithIdentifier:@"EventMonthViewController"];
    self.m_eventDayVC = [self.storyboard instantiateViewControllerWithIdentifier:@"EventDayViewController"];
    UINavigationController *calendarNC = [[UINavigationController alloc] initWithRootViewController:self.m_eventDayVC];
    calendarNC.navigationBarHidden = YES;
    
    UINavigationController *chatNC = [self.storyboard instantiateViewControllerWithIdentifier:@"ChatNavigationController"];
    UINavigationController *membersNC = [self.storyboard instantiateViewControllerWithIdentifier:@"MembersNavigationController"];
    UINavigationController *invitesNC = [self.storyboard instantiateViewControllerWithIdentifier:@"InvitesNavigationController"];
    
    self.viewControllers = @[calendarNC, chatNC, membersNC, invitesNC];
    
    NSArray *aryTabItemImages = @[@"calendar", @"chat", @"members", @"invite"];
    
    UIImage *imgBackground = [UIImage imageNamed:@"tabbar_background_normal"];
    UIImage *imgSelectedBackground = [UIImage imageNamed:@"tabbar_background_selected"];
    UIImage *imgBackgroundLast = [UIImage imageNamed:@"tabbar_background_normal_last"];
    UIImage *imgSelectedBackgroundLast = [UIImage imageNamed:@"tabbar_background_selected_last"];
    
    NSInteger index = 0;
    for (RDVTabBarItem *item in [[self tabBar] items])
    {
        UIImage *imgNormal = [UIImage imageNamed:[NSString stringWithFormat:@"tabbar_%@_normal", [aryTabItemImages objectAtIndex:index]]];
        UIImage *imgSelected = [UIImage imageNamed:[NSString stringWithFormat:@"tabbar_%@_selected", [aryTabItemImages objectAtIndex:index]]];
        
        [item setFinishedSelectedImage:imgSelected withFinishedUnselectedImage:imgNormal];
        if(index == INVITES_TABBAR_INDEX) {
            item.badgePositionAdjustment = UIOffsetMake(-25, 5);
        }
        
        index++;
        if(index == self.tabBar.items.count) {
            [item setBackgroundSelectedImage:imgSelectedBackgroundLast withUnselectedImage:imgBackgroundLast];
        } else {
            [item setBackgroundSelectedImage:imgSelectedBackground withUnselectedImage:imgBackground];
        }
    }
    
    [self.tabBar setHeight:TABBAR_HEIGHT];
    [GlobalService sharedInstance].tabbar_vc = self;
    [GlobalService sharedInstance].tabbar_vc.delegate = self;
    
    [[GlobalService sharedInstance] updateInvitesBadges];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self checkUserStatus];
}

- (void)checkUserStatus {
    if(![[NSUserDefaults standardUserDefaults] boolForKey:USER_DEFAULTS_KEY_FIRST_USE]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:USER_DEFAULTS_KEY_FIRST_USE];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:APP_NAME
                                                        message:@"Carpool Completed is free to use for 30 days. After 30 days you should upgrade your account to use this app. Do you want to upgrade your account now?"
                                                       delegate:self
                                              cancelButtonTitle:@"No, Thanks"
                                              otherButtonTitles:@"Buy Now", nil];
        [alert show];
    } else {
        //check user purchase status
        if([GlobalService sharedInstance].user_me.my_user.user_status == TRIAL_USER) {
            NSDate *expireAt = [[GlobalService sharedInstance].user_me.my_user.user_created_at dateByAddingMonths:1];
            if([expireAt compare:[NSDate date]] == NSOrderedAscending) {
                [GlobalService sharedInstance].user_me.my_user.user_status = EXPIRED_USER;
                [self goToUpgradePage];
            }
        } else if([GlobalService sharedInstance].user_me.my_user.user_status == EXPIRED_USER) {
            [self goToUpgradePage];
        } else {
            NSDate *expireAt = [[MKStoreKit sharedKit] expiryDateForProduct:IN_APP_PURCHASE_UPGRADE_USER];
            if([expireAt compare:[NSDate date]] == NSOrderedDescending) {
                [GlobalService sharedInstance].user_me.my_user.user_status = EXPIRED_USER;
                [self goToUpgradePage];
            }
        }
    }
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

#pragma mark - RDVTabbarControllerDelegate

- (BOOL)tabBar:(RDVTabBar *)tabBar shouldSelectItemAtIndex:(NSInteger)index {
    
    UINavigationController *chatNC = (UINavigationController *)self.viewControllers[self.selectedIndex];
    [chatNC popToRootViewControllerAnimated:NO];
    
    return YES;
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 1) {  //buy now
        [self goToUpgradePage];
    }
}

- (void)goToUpgradePage {
    UINavigationController *settingsNC = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsNavigationController"];
    UIViewController *upgradeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"UpgradeViewController"];
    [settingsNC pushViewController:upgradeVC animated:NO];
    
    [GlobalService sharedInstance].menu_vc.contentViewController = settingsNC;
}

@end
