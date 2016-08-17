//
//  EventView.h
//  Carpool
//
//  Created by JH Lee on 4/30/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHView.h"
#import "MemberDriverTableViewCell.h"
#import <MessageUI/MFMailComposeViewController.h>
#import <MessageUI/MFMessageComposeViewController.h>

@protocol EventViewDataSource <NSObject>

- (NSArray *)driverOfEvent:(NSInteger)index;
- (NSInteger)indexOfDriverCell:(NSInteger)index;

@optional
- (BOOL)hideStatusButton:(NSInteger)index;

@end

@protocol EventViewDelegate <NSObject>

- (void)onClickBtnInviteDrivers:(NSInteger)nIndex;
- (void)onClickBtnRemoveDrivers:(NSInteger)nIndex;

@end

@interface EventView : UIView <MemberDriverTableViewCellDelegate, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate> {
    NSInteger           m_nIndex;
    NSArray             *m_aryDrivers;
    UIViewController    *m_originVC;
    
    EventObj            *m_objEvent;
}

@property (weak, nonatomic) IBOutlet UILabel *m_lblEventTitle;
@property (weak, nonatomic) IBOutlet UIImageView *m_imgEventCreatorAvatar;
@property (weak, nonatomic) IBOutlet UILabel *m_lblEventCreatorName;
@property (weak, nonatomic) IBOutlet UILabel *m_lblEventPeriod;
@property (weak, nonatomic) IBOutlet UILabel *m_lblTableLabel;
@property (weak, nonatomic) IBOutlet UITableView *m_tblEventDriver;
@property (weak, nonatomic) IBOutlet JHView *m_viewAction;
@property (weak, nonatomic) IBOutlet UIButton *m_btnInviteDrivers;
@property (weak, nonatomic) IBOutlet UIButton *m_btnRemoveDrivers;

@property (nonatomic, retain) id<EventViewDelegate> delegate;
@property (nonatomic, retain) id<EventViewDataSource> datasource;

- (IBAction)onClickBtnInviteDrivers:(id)sender;
- (IBAction)onClickBtnRemoveDrivers:(id)sender;

- (void)setViewsWithEvent:(EventObj *)event onIndex:(NSInteger)nIndex origin:(UIViewController *)origin;

@end
