//
//  SideMenuViewController.m
//  Carpool
//
//  Created by JH Lee on 4/12/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import "SideMenuViewController.h"

@interface SideMenuViewController ()

@end

@implementation SideMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [GlobalService sharedInstance].menu_vc = self;
    [[GlobalService sharedInstance] loadSetting];
    
    if(![[NSUserDefaults standardUserDefaults] boolForKey:USER_DEFAULTS_KEY_FIRST_USE]) {
        UIViewController *tutorialTabBC = [self.storyboard instantiateViewControllerWithIdentifier:@"TutorialTabBarViewController"];
        self.contentViewController = tutorialTabBC;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)awakeFromNib {
    UIViewController *leftMenuVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LeftMenuViewController"];
    UIViewController *tabBC = [self.storyboard instantiateViewControllerWithIdentifier:@"TabBarViewController"];
    
    self.leftMenuViewController = leftMenuVC;
    self.contentViewController = tabBC;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
