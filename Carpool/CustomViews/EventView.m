//
//  EventView.m
//  Carpool
//
//  Created by JH Lee on 4/30/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import "EventView.h"

@implementation EventView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)onClickBtnInviteDrivers:(id)sender {
    [self.delegate onClickBtnInviteDrivers:m_nIndex];
}

- (IBAction)onClickBtnRemoveDrivers:(id)sender {
    [self.delegate onClickBtnRemoveDrivers:m_nIndex];
}

- (void)setViewsWithEvent:(EventObj *)event onIndex:(NSInteger)nIndex origin:(UIViewController *)origin {
    m_nIndex = nIndex;
    m_originVC = origin;
 
    m_objEvent = event;
    
    self.m_lblEventTitle.text = event.event_title;
    if(event.event_creator_avatar_url.length > 0) {
        [self.m_imgEventCreatorAvatar setImageWithURL:event.creatorAvatarUrl];
        self.m_imgEventCreatorAvatar.layer.masksToBounds = YES;
        self.m_imgEventCreatorAvatar.layer.cornerRadius = CGRectGetHeight(self.m_imgEventCreatorAvatar.frame) / 2;
    } else {
        self.m_imgEventCreatorAvatar.image = DEFAULT_AVATAR_IMAGE;
    }
    
    self.m_lblEventCreatorName.text = [NSString stringWithFormat:@"By %@", event.creatorInitialName];
    self.m_lblEventPeriod.text = event.eventPeriod;
    m_aryDrivers = [self.datasource driverOfEvent:nIndex];
    
    [self.m_tblEventDriver reloadData];
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
    return m_aryDrivers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DriverObj *objDriver = m_aryDrivers[indexPath.row];
    
    MemberDriverTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"MemberDriverTableViewCell"
                                                                     owner:nil
                                                                   options:nil] objectAtIndex:[self.datasource indexOfDriverCell:indexPath.row]];
    [cell setViewsWithDriverObj:objDriver onRow:indexPath.row];
    if([self.datasource respondsToSelector:@selector(hideStatusButton:)]) {
        cell.m_imgStatus.hidden = [self.datasource hideStatusButton:indexPath.row];
    }
    
//    if(m_objEvent.event_user_id.intValue == objDriver.driver_user_id.intValue) {
//        cell.m_imgStatus.hidden = YES;
//    }
    
    cell.delegate = self;
    
    return cell;
}

#pragma mark - MemberDriverTableViewCellDelegate

- (void)onClickBtnChat:(NSInteger)row {
    DriverObj *objDriver = m_aryDrivers[row];
    
    if([MFMessageComposeViewController canSendText]) {
        MFMessageComposeViewController *messageComposeVC = [[MFMessageComposeViewController alloc] init];
        [messageComposeVC setSubject:APP_NAME];
        messageComposeVC.recipients = @[objDriver.driver_phone];
        messageComposeVC.messageComposeDelegate = self;
        
        [m_originVC presentViewController:messageComposeVC animated:YES completion:nil];
    }
}

- (void)onClickBtnPhone:(NSInteger)row {
    DriverObj *objDriver = m_aryDrivers[row];
    
    NBPhoneNumber *number = [[NBPhoneNumberUtil sharedInstance] parse:objDriver.driver_phone
                                                        defaultRegion:[[NSLocale currentLocale] objectForKey:NSLocaleCountryCode]
                                                                error:nil];
    
    NSError *error = nil;
    NSURL *urlPhone = [NSURL URLWithString:[[NBPhoneNumberUtil sharedInstance] format:number
                                                                         numberFormat:NBEPhoneNumberFormatRFC3966
                                                                                error:&error]];
    if([[UIApplication sharedApplication] canOpenURL:urlPhone]) {
        [[UIApplication sharedApplication] openURL:urlPhone];
    }
}

- (void)onClickBtnEmail:(NSInteger)row {
    DriverObj *objDriver = m_aryDrivers[row];
    
    if([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailComposeVC = [[MFMailComposeViewController alloc] init];
        [mailComposeVC setSubject:APP_NAME];
        [mailComposeVC setToRecipients:@[objDriver.driver_email]];
        mailComposeVC.mailComposeDelegate = self;
        
        [m_originVC presentViewController:mailComposeVC animated:YES completion:nil];
    }
}

#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    switch (result) {
        case MFMailComposeResultCancelled:
            NSLog(@"Cancelled");
            break;
            
        case MFMailComposeResultFailed:
            NSLog(@"Failed");
            break;
            
        case MFMailComposeResultSaved:
            NSLog(@"Saved");
            break;
            
        case MFMailComposeResultSent:
            NSLog(@"Sent");
            break;
            
        default:
            break;
    }
    
    [controller dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - MFMessageComposeViewControllerDelegate

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    switch (result) {
        case MessageComposeResultCancelled:
            NSLog(@"Cancelled");
            break;
            
        case MessageComposeResultFailed:
            NSLog(@"Failed");
            break;
            
        case MessageComposeResultSent:
            NSLog(@"Sent");
            break;
            
        default:
            break;
    }
    
    [controller dismissViewControllerAnimated:YES completion:nil];
}

@end
