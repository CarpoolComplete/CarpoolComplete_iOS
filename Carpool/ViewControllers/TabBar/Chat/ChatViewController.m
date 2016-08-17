//
//  ChatViewController.m
//  Carpool
//
//  Created by JH Lee on 4/25/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import "ChatViewController.h"
#import "QuickTextTableViewCell.h"

typedef enum {
    MESSAGE_TEXT = 10,
    MESSAGE_EMAIL
}MESSAGE_KIND;

@interface ChatViewController ()

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    m_arySelected = [[NSMutableArray alloc] init];
    self.m_lblEventName.text = self.selected_event.event_title;
    
    m_aryQuickText = @[
                       @"I just dropped off your child.",
                       @"I just picked up your child.",
                       @"I'm leaving now.",
                       @"I'm stuck in traffic."
                       ];
    
    m_is_text = -1;
    
    m_aryEventDrivers = [[NSMutableArray alloc] init];
    for(DriverObj *objDriver in self.selected_event.event_drivers) {
        if(objDriver.driver_status == DRIVER_STATUS_ACCEPT
           && objDriver.driver_user_id.intValue != [GlobalService sharedInstance].my_user_id.intValue) {
            [m_aryEventDrivers addObject:objDriver];
        }
    }
    
    if(self.selected_event.event_user_id.intValue != [GlobalService sharedInstance].my_user_id.intValue) {
        DriverObj *objDriver = [[DriverObj alloc] init];
        objDriver.driver_user_id = self.selected_event.event_user_id;
        objDriver.driver_first_name = self.selected_event.event_creator_first_name;
        objDriver.driver_last_name = self.selected_event.event_creator_last_name;
        objDriver.driver_phone = self.selected_event.event_creator_phone;
        
        [m_aryEventDrivers insertObject:objDriver atIndex:0];
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

- (IBAction)onClickBtnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onClickBtnCompose:(id)sender {
    if(m_arySelected.count == 0) {
        [self.view makeToast:@"No Selected Driver"
                    duration:1.f
                    position:CSToastPositionCenter];
    } else {
        if(m_is_text == 1) {
            if([MFMessageComposeViewController canSendText]) {
                NSMutableArray *aryPhoneNumbers = [[NSMutableArray alloc] init];
                for(DriverObj *objDriver in m_arySelected) {
                    [aryPhoneNumbers addObject:objDriver.driver_phone];
                }
                MFMessageComposeViewController *messageComposeVC = [[MFMessageComposeViewController alloc] init];
                [messageComposeVC setSubject:APP_NAME];
                messageComposeVC.recipients = aryPhoneNumbers;
                messageComposeVC.body = m_strSelected;
                messageComposeVC.messageComposeDelegate = self;
                
                [self presentViewController:messageComposeVC animated:YES completion:nil];
            }
        } else if(m_is_text == 0) {
            if([MFMailComposeViewController canSendMail]) {
                NSMutableArray *aryEmails = [[NSMutableArray alloc] init];
                for(DriverObj *objDriver in m_arySelected) {
                    [aryEmails addObject:objDriver.driver_email];
                }
                
                MFMailComposeViewController *mailComposeVC = [[MFMailComposeViewController alloc] init];
                [mailComposeVC setSubject:APP_NAME];
                [mailComposeVC setToRecipients:aryEmails];
                [mailComposeVC setMessageBody:m_strSelected isHTML:NO];
                mailComposeVC.mailComposeDelegate = self;
                
                [self presentViewController:mailComposeVC animated:YES completion:nil];
            }
        }
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

- (IBAction)onClickBtnMessageType:(id)sender {
    UIButton *btnText = [self.view viewWithTag:MESSAGE_TEXT];
    UIButton *btnEmail = [self.view viewWithTag:MESSAGE_EMAIL];
    
    UIButton *button = (UIButton *)sender;
    if(button.tag == MESSAGE_TEXT) {
        m_is_text = 1;
        btnEmail.backgroundColor = [UIColor whiteColor];
        btnText.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"d1d1d1"];
    } else {
        m_is_text = 0;
        btnEmail.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"d1d1d1"];
        btnText.backgroundColor = [UIColor whiteColor];
    }
}

- (IBAction)onClickBtnQuickText:(id)sender {
    self.m_btnShowQuickText.selected = !self.m_btnShowQuickText.selected;
    if(self.m_btnShowQuickText.selected) {
        [UIView animateWithDuration:0.3f animations:^{
            self.m_constraintQuickViewTop.constant = -220;
            [self.view layoutIfNeeded];
        }];
    } else {
        [UIView animateWithDuration:0.3f animations:^{
            self.m_constraintQuickViewTop.constant = -40;
            [self.view layoutIfNeeded];
        }];
    }
}

#pragma mark - TableViewDataSource

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == self.m_tblChatDriver) {
        if(m_aryEventDrivers.count > 0) {
            return m_aryEventDrivers.count + 1;
        } else {
            return 0;
        }
    } else {
        return m_aryQuickText.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.m_tblChatDriver) {
        ChatDriverTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChatDriverTableViewCell"];
        
        if(indexPath.row == 0) {
            cell.m_lblDriverName.text = @"All";
            cell.m_btnPhone.hidden = YES;
            
            if(m_arySelected.count == m_aryEventDrivers.count) {
                cell.m_btnCheck.selected = YES;
            } else {
                cell.m_btnCheck.selected = NO;
            }
        } else {
            DriverObj *objDriver = m_aryEventDrivers[indexPath.row - 1];
            
            cell.m_lblDriverName.text = [NSString stringWithFormat:@"%@ %@", objDriver.driver_first_name, objDriver.driver_last_name];
            cell.m_btnCheck.selected = [m_arySelected containsObject:objDriver];
        }
        
        cell.m_nRow = indexPath.row;
        cell.delegate = self;
        
        return cell;
    } else {
        QuickTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QuickTextTableViewCell"];
        cell.m_lblText.text = m_aryQuickText[indexPath.row];
        
        if([m_aryQuickText[indexPath.row] isEqualToString:m_strSelected]) {
            cell.m_imgCheck.hidden = NO;
        } else {
            cell.m_imgCheck.hidden = YES;
        }
        
        return cell;
    }
}

#pragma mark - TableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.m_tblChatDriver) {
        ChatDriverTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.m_btnCheck.selected = !cell.m_btnCheck.selected;
        
        if(indexPath.row == 0) {
            if(cell.m_btnCheck.selected) {
                m_arySelected = [m_aryEventDrivers mutableCopy];
            } else {
                [m_arySelected removeAllObjects];
            }
        } else {
            DriverObj *objDriver = m_aryEventDrivers[indexPath.row - 1];
            if(cell.m_btnCheck.selected) {
                [m_arySelected addObject:objDriver];
            } else {
                [m_arySelected removeObject:objDriver];
            }
        }
        
        [tableView reloadData];
    } else {
        if(m_strSelected == m_aryQuickText[indexPath.row]) {
            m_strSelected = @"";
        } else {
            m_strSelected = m_aryQuickText[indexPath.row];
        }
        [tableView reloadData];
    }
}

#pragma mark - ChatDriverTableViewCellDelegate

- (void)onClickBtnPhoneCall:(NSInteger)row {
    DriverObj *objDriver = m_aryEventDrivers[row - 1];
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

@end
