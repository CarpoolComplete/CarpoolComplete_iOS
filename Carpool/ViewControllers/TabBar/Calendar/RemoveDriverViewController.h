//
//  RemoveDriverViewController.h
//  Carpool
//
//  Created by JH Lee on 4/18/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RemoveDriverTableViewCell.h"

@interface RemoveDriverViewController : UIViewController<RemoveDriverTableViewCellDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *m_lblEventName;
@property (weak, nonatomic) IBOutlet UIImageView *m_imgEventCreatorAvatar;
@property (weak, nonatomic) IBOutlet UILabel *m_lblEventCreatorName;
@property (weak, nonatomic) IBOutlet UILabel *m_lblEventPeriod;
@property (weak, nonatomic) IBOutlet UITableView *m_tblEventDriver;

@property (nonatomic, retain) EventObj      *selected_event;

- (IBAction)onClickBtnBack:(id)sender;

@end
