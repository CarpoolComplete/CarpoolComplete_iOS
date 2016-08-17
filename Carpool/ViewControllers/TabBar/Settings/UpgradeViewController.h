//
//  UpgradeViewController.h
//  Carpool Complete
//
//  Created by JH Lee on 8/1/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpgradeViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *m_btnBack;
@property (weak, nonatomic) IBOutlet UILabel *m_lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *m_lblContent;
@property (weak, nonatomic) IBOutlet UIButton *m_btnBuy;
@property (weak, nonatomic) IBOutlet UIButton *m_btnRestore;

- (IBAction)onClickBtnBack:(id)sender;
- (IBAction)onClickBtnBuy:(id)sender;
- (IBAction)onClickBtnRestore:(id)sender;


@end
