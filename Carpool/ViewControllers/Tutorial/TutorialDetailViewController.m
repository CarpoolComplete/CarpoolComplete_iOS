//
//  TutorialDetailViewController.m
//  Carpool Complete
//
//  Created by JH Lee on 8/1/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import "TutorialDetailViewController.h"
#import "PassengerTableViewCell.h"

@interface TutorialDetailViewController ()

@end

@implementation TutorialDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    m_aryPassengers = self.m_jhEvent.event_userInfo[@"event_passengers"];
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

#pragma mark - TableView DataSource

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == self.m_tblToPassenger) {
        return m_aryPassengers.count;
    } else {
        return m_aryPassengers.count;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.m_tblToPassenger) {
        PassengerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ToPassengerTableViewCell"];
        cell.m_lblName.text = m_aryPassengers[indexPath.row];
        return cell;
    } else {
        PassengerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FromPassengerTableViewCell"];
        cell.m_lblName.text = m_aryPassengers[indexPath.row];
        return cell;
    }
}

- (IBAction)onClickBtnGotIt:(id)sender {
    [self dismissViewControllerAnimated:NO completion:^{
        UIViewController *tabBC = [self.storyboard instantiateViewControllerWithIdentifier:@"TabBarViewController"];
        [[GlobalService sharedInstance].menu_vc setContentViewController:tabBC];
    }];
}

@end
