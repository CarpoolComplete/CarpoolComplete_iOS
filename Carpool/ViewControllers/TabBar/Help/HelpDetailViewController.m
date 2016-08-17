//
//  HelpDetailViewController.m
//  Carpool
//
//  Created by JH Lee on 5/12/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import "HelpDetailViewController.h"

@interface HelpDetailViewController ()

@end

@implementation HelpDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSURL *htmlFile = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%d", (int)self.selected_index + 1]
                                                                             ofType:@"html"]
                                 isDirectory:NO];
    [self.m_webView loadRequest:[NSURLRequest requestWithURL:htmlFile]];
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

- (IBAction)onClickBtnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
