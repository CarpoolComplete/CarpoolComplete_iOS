//
//  VerifyPhoneViewController.h
//  Carpool
//
//  Created by JH Lee on 4/10/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHTextField.h"

@interface VerifyPhoneViewController : UIViewController {
    NSString *m_strCode;
}

@property (weak, nonatomic) IBOutlet JHTextField    *m_txtCode;
@property (nonatomic, retain) UserObj               *m_objUser;
@property (nonatomic, readwrite) BOOL               m_isLogin;

- (IBAction)onClickBtnEnter:(id)sender;
- (IBAction)onClickBtnResend:(id)sender;
- (IBAction)onClickBtnCancel:(id)sender;

@end
