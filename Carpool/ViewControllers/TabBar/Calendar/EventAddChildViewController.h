//
//  EventAddChildViewController.h
//  Carpool
//
//  Created by JH Lee on 4/23/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventAddChildViewController : UIViewController 

@property (nonatomic, retain) NSMutableArray        *m_aryPassengers;

@property (weak, nonatomic) IBOutlet UILabel        *m_lblAlert;
@property (weak, nonatomic) IBOutlet UITableView    *m_tblChild;

- (IBAction)onClickBtnDone:(id)sender;
- (IBAction)onClickBtnCancel:(id)sender;

@end
