//
//  EditAdultViewController.m
//  Carpool
//
//  Created by JH Lee on 4/27/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import "EditAdultViewController.h"

#define REMOVE_ADULT_ALERT_TAG          10
#define EDIT_ADULT_ALERT_TAG            11

@interface EditAdultViewController ()

@end

@implementation EditAdultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.m_imgDriverAvatar.layer.masksToBounds = YES;
    self.m_imgDriverAvatar.layer.cornerRadius = CGRectGetHeight(self.m_imgDriverAvatar.frame) / 2;
    if(self.selected_adult.user_avatar_url.length > 0) {
        [self.m_imgDriverAvatar setImageWithURL:self.selected_adult.avatarUrl];
    }
    self.m_txtFirstName.text = self.selected_adult.user_first_name;
    self.m_txtLastName.text = self.selected_adult.user_last_name;
    self.m_txtEmailAddress.text = self.selected_adult.user_email;
    self.m_txtPhone.text = self.selected_adult.user_phone;
    
    if([GlobalService sharedInstance].my_user_id.intValue == self.selected_adult.user_id.intValue) {
        self.m_btnEdit.hidden = NO;
        self.m_btnRemoveDriver.hidden = YES;
    } else {
//        if([GlobalService sharedInstance].user_me.my_user.user_is_creator) { // adult user
//            self.m_btnEdit.hidden = NO;
//            self.m_btnRemoveDriver.hidden = NO;
//        } else {
            self.m_btnEdit.hidden = YES;
            self.m_btnRemoveDriver.hidden = YES;
//        }
    }
    
    m_hasAvatar = NO;
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

- (IBAction)onClickBtnCancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onClickBtnEdit:(id)sender {
    if([self validateEdit]) {
        if([GlobalService sharedInstance].my_user_id.intValue == self.selected_adult.user_id.intValue) {    // update my profile
            [self updateAdultProfile];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:APP_NAME
                                                            message:@"Only this user may edit their profile."
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"OK", nil];
            alert.tag = EDIT_ADULT_ALERT_TAG;
            [alert show];
        }
    }
}

- (void)updateAdultProfile {
    SVPROGRESSHUD_PLEASE_WAIT;
    [[WebService sharedInstance] updateUserWithUserId:self.selected_adult.user_id
                                            FirstName:self.m_txtFirstName.text
                                             LastName:self.m_txtLastName.text
                                          PhoneNumber:[self.m_txtPhone phoneNumberWithFormat:LTPhoneNumberFormatINTERNATIONAL]
                                                Email:self.m_txtEmailAddress.text
                                            AvatarUrl:self.selected_adult.user_avatar_url
                                      UserAvatarImage:m_hasAvatar?self.m_imgDriverAvatar.image:nil
                                              success:^(UserObj *objUser) {
                                                  SVPROGRESSHUD_DISMISS;
                                                  if(objUser.user_id.intValue == [GlobalService sharedInstance].my_user_id.intValue) {  // update himself
                                                      [[GlobalService sharedInstance].user_me updateUser:objUser];
                                                  } else {
                                                      [[GlobalService sharedInstance].user_me updateAdult:objUser];
                                                  }
                                                  
                                                  [self.navigationController popViewControllerAnimated:YES];
                                              }
                                              failure:^(NSString *strError) {
                                                  SVPROGRESSHUD_ERROR(strError);
                                              }
                                             progress:^(double progress) {
                                                 if(m_hasAvatar) {
                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                         SVPROGRESSHUD_PROGRESS(progress);
                                                     });
                                                 }
                                             }];
}

- (BOOL)validateEdit {
    
    NSString *strFirstName = self.m_txtFirstName.text;
    NSString *strEmail = self.m_txtEmailAddress.text;
    
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
    }
    
    return bResult;
}


- (IBAction)onClickBtnRemoveDriver:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:APP_NAME
                                                    message:@"Are you sure to remove this adult?"
                                                   delegate:self
                                          cancelButtonTitle:@"No"
                                          otherButtonTitles:@"Yes", nil];
    alert.tag = REMOVE_ADULT_ALERT_TAG;
    [alert show];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(alertView.tag == REMOVE_ADULT_ALERT_TAG) {
        if(buttonIndex == 1) {
            SVPROGRESSHUD_PLEASE_WAIT;
            [[WebService sharedInstance] deleteAdultWithId:self.selected_adult.user_id
                                                   success:^(NSString *strResult) {
                                                       SVPROGRESSHUD_DISMISS;
                                                       [[GlobalService sharedInstance].user_me removeAdult];
                                                       [self.navigationController popViewControllerAnimated:YES];
                                                   } failure:^(NSString *strError) {
                                                       SVPROGRESSHUD_ERROR(strError);
                                                   }];
        }
    } else {
        [self updateAdultProfile];
    }
}

- (IBAction)onTapDriverAvatar:(id)sender {
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
                                                              
                                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                                  [self presentViewController:picker animated:YES completion:nil];
                                                              });
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
                                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                                      [self presentViewController:imagePicker animated:YES completion:nil];
                                                                  });
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
        self.m_imgDriverAvatar.image = image;
    }];
}

- (void)cropViewController:(TOCropViewController *)cropViewController didFinishCancelled:(BOOL)cancelled {
    [cropViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
