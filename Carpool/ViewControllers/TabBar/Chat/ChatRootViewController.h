//
//  ChatRootViewController.h
//  Carpool
//
//  Created by JH Lee on 4/25/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatRootViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *m_tblCarpool;

- (IBAction)onClickBtnMenu:(id)sender;

@end
