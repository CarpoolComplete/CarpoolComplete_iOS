//
//  LeftMenuViewController.m
//  Carpool
//
//  Created by JH Lee on 4/12/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import "LeftMenuViewController.h"

typedef enum{
    MENU_DAY_VIEW = 10,
    MENU_MONTH_VIEW,
    MENU_SETTINGS,
    MENU_HELP,
    MENU_LOG_OUT
}MENU_TAG;

@interface LeftMenuViewController ()

@end

@implementation LeftMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (IBAction)onClickBtnMenu:(id)sender {
    UIButton *btnMenu = (UIButton *)sender;
    switch (btnMenu.tag) {
        case MENU_DAY_VIEW:
        {
            UINavigationController *calendarNC = (UINavigationController *)[GlobalService sharedInstance].tabbar_vc.viewControllers[0];
            [calendarNC popToRootViewControllerAnimated:NO];
            [self.sideMenuViewController setContentViewController:[GlobalService sharedInstance].tabbar_vc animated:YES];
            [GlobalService sharedInstance].tabbar_vc.selectedIndex = 0;
            
            break;
            
        }
        case MENU_MONTH_VIEW:
        {
            
            UINavigationController *calendarNC = (UINavigationController *)[GlobalService sharedInstance].tabbar_vc.viewControllers[0];
            UIViewController *monthVC = nil;
            for(UIViewController *vc in calendarNC.viewControllers) {
                if(vc == [GlobalService sharedInstance].tabbar_vc.m_eventMonthVC) {
                    monthVC = vc;
                    break;
                }
            }
            
            if(!monthVC) {
                [calendarNC pushViewController:[GlobalService sharedInstance].tabbar_vc.m_eventMonthVC animated:NO];
                [self.sideMenuViewController setContentViewController:[GlobalService sharedInstance].tabbar_vc animated:YES];
                [GlobalService sharedInstance].tabbar_vc.selectedIndex = 0;
            }
            
            break;
        }
        case MENU_SETTINGS:
        {
            UINavigationController *settingsNC = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsNavigationController"];
            [self.sideMenuViewController setContentViewController:settingsNC];
            
            break;
        }
        case MENU_HELP:
        {
            UINavigationController *helpNC = [self.storyboard instantiateViewControllerWithIdentifier:@"HelpNavigationController"];
            [self.sideMenuViewController setContentViewController:helpNC];
            
            break;
        }
        case MENU_LOG_OUT:
        {
            [self.sideMenuViewController hideMenuViewController];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:APP_NAME
                                                            message:@"Are you sure to log out?"
                                                           delegate:self
                                                  cancelButtonTitle:@"No"
                                                  otherButtonTitles:@"Yes", nil];
            [alert show];
        }
            break;
        default:
            break;
    }
    
    [self.sideMenuViewController hideMenuViewController];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 1) {
        SVPROGRESSHUD_PLEASE_WAIT;
        [[WebService sharedInstance] logoutWithUserId:[GlobalService sharedInstance].my_user_id
                                              success:^(NSString *strResult) {
                                                  SVPROGRESSHUD_DISMISS;
                                                  [self removeiCalcEvents];
                                                  [[GlobalService sharedInstance] deleteMe];
                                                  [[GlobalService sharedInstance] deleteSetting];
                                                  [self.navigationController popToRootViewControllerAnimated:YES];
                                              }
                                              failure:^(NSString *strError) {
                                                  SVPROGRESSHUD_ERROR(strError);
                                              }];
    }
}

- (void)removeiCalcEvents {
    [[EventService sharedInstance] deleteAllEvents:[GlobalService sharedInstance].user_me.my_events
                                        completion:nil];
}

@end
