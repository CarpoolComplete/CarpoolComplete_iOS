//
//  RemoveDriverViewController.m
//  Carpool
//
//  Created by JH Lee on 4/18/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import "RemoveDriverViewController.h"

@interface RemoveDriverViewController ()

@end

@implementation RemoveDriverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.m_lblEventName.text = self.selected_event.event_title;
    if(self.selected_event.event_creator_avatar_url.length > 0) {
        [self.m_imgEventCreatorAvatar setImageWithURL:self.selected_event.creatorAvatarUrl];
        self.m_imgEventCreatorAvatar.layer.masksToBounds = YES;
        self.m_imgEventCreatorAvatar.layer.cornerRadius = CGRectGetHeight(self.m_imgEventCreatorAvatar.frame) / 2;
    } else {
        self.m_imgEventCreatorAvatar.image = DEFAULT_AVATAR_IMAGE;
    }
    
    self.m_lblEventCreatorName.text = [NSString stringWithFormat:@"By %@", self.selected_event.creatorInitialName];
    self.m_lblEventPeriod.text = self.selected_event.eventPeriod;
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

#pragma mark - TableView DataSource

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1f;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.selected_event.event_drivers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DriverObj *objDriver = self.selected_event.event_drivers[indexPath.row];
    
    RemoveDriverTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RemoveDriverTableViewCell"];
    [cell setViewsWithDriver:objDriver onRow:indexPath.row];
    cell.delegate = self;
    
    return cell;
}

#pragma mark - RemoveDriverTableViewCellDelegate

- (void)onClickBtnRemove:(NSInteger)row {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Carpool Complete"
                                                    message:@"Removing this driver will remove their chosen driving assignments for this carpool. Are you sure you want to remove this driver?"
                                                   delegate:self
                                          cancelButtonTitle:@"No"
                                          otherButtonTitles:@"Yes", nil];
    alert.tag = row;
    [alert show];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 1) {
        DriverObj *objDriver = self.selected_event.event_drivers[alertView.tag];
        [[WebService sharedInstance] removeDriverWithInvitationId:objDriver.driver_invitation_id
                                                          success:^(NSString *strResult) {
                                                              NSLog(@"%@", strResult);
                                                          }
                                                          failure:^(NSString *strError) {
                                                              NSLog(@"%@", strError);
                                                          }];
        
        [self.selected_event removeDriver:alertView.tag];
        [self.m_tblEventDriver deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:alertView.tag inSection:0]]
                                     withRowAnimation:UITableViewRowAnimationFade];
    }
}

@end
