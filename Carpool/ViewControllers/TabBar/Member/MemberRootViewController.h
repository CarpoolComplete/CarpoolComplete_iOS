//
//  MemberRootViewController.h
//  Carpool
//
//  Created by JH Lee on 4/26/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MemberRootViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *m_tblMember;
@property (weak, nonatomic) IBOutlet UIButton *m_btnAddFamily;

- (IBAction)onClickBtnMenu:(id)sender;
- (IBAction)onClickBtnAddFamily:(id)sender;

@end
