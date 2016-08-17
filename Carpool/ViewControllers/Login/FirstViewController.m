//
//  FirstViewController.m
//  Carpool
//
//  Created by JH Lee on 4/9/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import "FirstViewController.h"
#import "EnterPhoneViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

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

- (IBAction)onClickBtnSignin:(id)sender {
    UIViewController *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    [self.navigationController pushViewController:loginVC animated:YES];
}

- (IBAction)onClickBtnSignUp:(id)sender {
    UIViewController *signupVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SignupViewController"];
    [self.navigationController pushViewController:signupVC animated:YES];
}

@end
