//
//  ChatRootViewController.m
//  Carpool
//
//  Created by JH Lee on 4/25/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import "ChatRootViewController.h"
#import "CarpoolListTableViewCell.h"
#import "ChatViewController.h"

@interface ChatRootViewController ()

@end

@implementation ChatRootViewController

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
    [self.m_tblCarpool reloadData];
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

#pragma mark - TableViewDataSource

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [GlobalService sharedInstance].user_me.my_events.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CarpoolListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CarpoolListTableViewCell"];
    
    EventObj *objEvent = [GlobalService sharedInstance].user_me.my_events[indexPath.row];
    
    cell.m_lblCarpoolName.text = objEvent.event_title;
    
    return cell;
}

#pragma mark - TableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChatViewController *chatVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ChatViewController"];
    chatVC.selected_event = [GlobalService sharedInstance].user_me.my_events[indexPath.row];
    [self.navigationController pushViewController:chatVC animated:YES];
}

@end
