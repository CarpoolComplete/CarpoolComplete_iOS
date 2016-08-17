//
//  TutorialTabBarViewController.m
//  Carpool Complete
//
//  Created by JH Lee on 8/1/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import "TutorialTabBarViewController.h"
#import <RDVTabBarController/RDVTabBarItem.h>

@interface TutorialTabBarViewController ()

@end

@implementation TutorialTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UINavigationController *tutorialNC = [self.storyboard instantiateViewControllerWithIdentifier:@"TutorialNavigationController"];
    
    self.viewControllers = @[tutorialNC, [UIViewController new], [UIViewController new], [UIViewController new]];
    
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
    
    self.delegate = self;
    [self.tabBar setHeight:TABBAR_HEIGHT];
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

#pragma mark - UITabBarControllerDelegate
- (BOOL)tabBarController:(RDVTabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    return NO;
}

- (BOOL)tabBar:(RDVTabBar *)tabBar shouldSelectItemAtIndex:(NSInteger)index {
    return NO;
}

@end
