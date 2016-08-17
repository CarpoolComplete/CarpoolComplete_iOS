//
//  SignupViewController.m
//  Carpool
//
//  Created by JH Lee on 4/9/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import "SignupViewController.h"
#import <SHEmailValidator/SHEmailValidator.h>
#import "VerifyPhoneViewController.h"
#import "LoginViewController.h"

@interface SignupViewController ()

@end

@implementation SignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    PatternTapResponder tapResponder = ^(NSString *string) {
        if([string isEqualToString:@"Sign In"]) {
            [self goToSignInPage];
        } else if([string isEqualToString:@"terms"]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:TERMS_URL]];
        } else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:PRIVACY_URL]];
        }
    };
    [self.m_lblSignIn enableStringDetection:@"Sign In"
                             withAttributes:@{
                                              NSForegroundColorAttributeName: [UIColor hx_colorWithHexRGBAString:@"#007aff"],
                                              RLTapResponderAttributeName: tapResponder
                                              }];
    
    [self.m_lblTerms enableDetectionForStrings:@[@"terms", @"privacy policy"]
                                withAttributes:@{
                                                 NSForegroundColorAttributeName: [UIColor hx_colorWithHexRGBAString:@"#007aff"],
                                                 RLTapResponderAttributeName: tapResponder
                                                 }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(onTapImageAvatar)];
    [self.m_imgAvatar addGestureRecognizer:tap];
    self.m_imgAvatar.layer.masksToBounds = YES;
    self.m_imgAvatar.layer.cornerRadius = CGRectGetHeight(self.m_imgAvatar.frame) / 2;
    
    m_hasAvatar = NO;
}

- (void)onTapImageAvatar {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Take your avatar from..."
                                                                             message:@""
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Camera"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                          if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                                                              
                                                              UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                                                              picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                                                              picker.delegate = self;
                                                              
                                                              [self presentViewController:picker animated:YES completion:nil];
                                                          }
                                                          
                                                      }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Image Gallary"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                          UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                                                          imagePicker.delegate = self;
                                                          if(m_popoverController != nil) {
                                                              [m_popoverController dismissPopoverAnimated:YES];
                                                              m_popoverController = nil;
                                                          }
                                                          
                                                          if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                                                              imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                                              if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                                                                  m_popoverController = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
                                                                  m_popoverController.delegate = self;
                                                                  [m_popoverController presentPopoverFromRect:CGRectMake(0, 0, 1024, 160)
                                                                                                       inView:self.view
                                                                                     permittedArrowDirections:UIPopoverArrowDirectionAny
                                                                                                     animated:YES];
                                                              } else {
                                                                  
                                                                  [self presentViewController:imagePicker animated:YES completion:nil];
                                                              }
                                                          }
                                                      }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                                        style:UIAlertActionStyleCancel
                                                      handler:nil]];
    
    UIPopoverPresentationController *popPresenter = [alertController popoverPresentationController];
    popPresenter.sourceView = self.view;
    popPresenter.sourceRect = CGRectMake(self.view.bounds.size.width / 2.0, self.view.bounds.size.height, 1.0, 1.0);
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - image picker controller

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *imgUserAvatar = [info objectForKey:UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:NO completion:^{
        [self openEditor:imgUserAvatar];
    }];
}

# pragma mark - Open Crop View Controller

- (void) openEditor:(UIImage *) editImage {
    
    TOCropViewController *cropViewController = [[TOCropViewController alloc] initWithImage:editImage];
    cropViewController.delegate = self;
    cropViewController.defaultAspectRatio = TOCropViewControllerAspectRatioSquare;
    cropViewController.aspectRatioLocked = YES;
    [self presentViewController:cropViewController animated:NO completion:nil];
}

#pragma mark - TOCropViewController Delegate
- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle
{
    [cropViewController dismissViewControllerAnimated:YES completion:^(void) {
        m_hasAvatar = YES;
        self.m_imgAvatar.image = image;
    }];
}

- (void)cropViewController:(TOCropViewController *)cropViewController didFinishCancelled:(BOOL)cancelled {
    [cropViewController dismissViewControllerAnimated:YES completion:nil];
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

- (IBAction)onClickBtnCreate:(id)sender {
    [self.m_txtFirstName resignFirstResponder];
    [self.m_txtLastName resignFirstResponder];
    [self.m_txtEmail resignFirstResponder];
    [self.m_txtPhone resignFirstResponder];
    [self.m_txtPassword resignFirstResponder];
    
    if([self validateSignup]) {
        UserObj *objUser = [[UserObj alloc] init];
        objUser.user_first_name = self.m_txtFirstName.text;
        objUser.user_last_name = self.m_txtLastName.text;
        objUser.user_email = self.m_txtEmail.text;
        objUser.user_phone = [self.m_txtPhone phoneNumberWithFormat:LTPhoneNumberFormatINTERNATIONAL];
        objUser.user_pass = self.m_txtPassword.text;
        objUser.user_avatar_image = m_hasAvatar ? self.m_imgAvatar.image : nil;
        VerifyPhoneViewController *verifyPhoneVC = [self.storyboard instantiateViewControllerWithIdentifier:@"VerifyPhoneViewController"];
        verifyPhoneVC.m_objUser = objUser;
        [self.navigationController pushViewController:verifyPhoneVC animated:YES];
    }
}

- (IBAction)onClickBtnBack:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (BOOL)validateSignup {
    
    NSString *strFirstName = self.m_txtFirstName.text;
    NSString *strEmail = self.m_txtEmail.text;
    NSString *strPass = [self.m_txtPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    BOOL bResult = YES;
    
    NSError *error = nil;
    if(strFirstName.length == 0) {
        [self.view makeToast:TOAST_NO_USER_FIRST_NAME duration:1.f position:CSToastPositionCenter];
        
        bResult = NO;
    } else if(![[SHEmailValidator validator] validateSyntaxOfEmailAddress:strEmail withError:&error]) {
        [self.view makeToast:TOAST_INVALID_EMAIL_ADDRESS duration:1.f position:CSToastPositionCenter];
        
        bResult = NO;
    } else if (![self.m_txtPhone containsValidNumber]) {
        [self.view makeToast:TOAST_INVALID_PHONE_NUMBER duration:1.f position:CSToastPositionCenter];
        
        bResult = NO;
    }else if (strPass.length < 6) {
        [self.view makeToast:TOAST_SHORT_PASSWORD duration:1.f position:CSToastPositionCenter];
        
        bResult = NO;
    }
    
    return bResult;
}

- (void)goToSignInPage {
    UIViewController *loginVC = nil;
    for(UIViewController *vc in self.navigationController.viewControllers) {
        if([vc isKindOfClass:[LoginViewController class]]) {
            loginVC = vc;
            break;
        }
    }
    
    if(loginVC) {
        [self.navigationController popToViewController:loginVC animated:YES];
    } else {
        loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
}

@end
