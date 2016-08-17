//
//  AddFamilyViewController.h
//  Carpool
//
//  Created by JH Lee on 4/11/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddFamilyViewController : UIViewController<UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *m_tblFamily;
@property (weak, nonatomic) IBOutlet UIButton *m_btnCancel;

@property (nonatomic, readwrite) BOOL           m_come_from_member;

- (IBAction)onClickBtnDone:(id)sender;
- (IBAction)onClickBtnCancel:(id)sender;

@end
