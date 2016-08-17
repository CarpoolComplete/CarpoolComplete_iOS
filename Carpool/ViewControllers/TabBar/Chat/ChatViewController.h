//
//  ChatViewController.h
//  Carpool
//
//  Created by JH Lee on 4/25/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatDriverTableViewCell.h"
#import <MessageUI/MFMailComposeViewController.h>
#import <MessageUI/MFMessageComposeViewController.h>

@interface ChatViewController : UIViewController<ChatDriverTableViewCellDelegate, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate> {
    NSInteger           m_is_text;
    NSMutableArray      *m_arySelected;
    NSArray             *m_aryQuickText;
    NSString            *m_strSelected;
    NSMutableArray      *m_aryEventDrivers;
}

@property (weak, nonatomic) IBOutlet UILabel *m_lblEventName;
@property (nonatomic, retain) EventObj      *selected_event;
@property (weak, nonatomic) IBOutlet UITableView *m_tblQuickText;
@property (weak, nonatomic) IBOutlet UITableView *m_tblChatDriver;
@property (weak, nonatomic) IBOutlet UIButton *m_btnShowQuickText;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *m_constraintQuickViewTop;

- (IBAction)onClickBtnBack:(id)sender;
- (IBAction)onClickBtnCompose:(id)sender;
- (IBAction)onClickBtnMessageType:(id)sender;
- (IBAction)onClickBtnQuickText:(id)sender;

@end
