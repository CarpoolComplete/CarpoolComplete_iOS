//
//  UpgradeViewController.m
//  Carpool Complete
//
//  Created by Jyoti Khajekar on 8/1/16.
//  Copyright © 2016 Jyoti Khajekar. All rights reserved.
//

#import "UpgradeViewController.h"

@interface UpgradeViewController ()

@end

@implementation UpgradeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onRestoredPurchases) name:kMKStoreKitRestoredPurchasesNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onFailedRestorePurchases) name:kMKStoreKitRestoringPurchasesFailedNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onProductPurchases) name:kMKStoreKitProductPurchasedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onFailedProductPurchases) name:kMKStoreKitProductPurchaseFailedNotification object:nil];
    
    [self initViews];
}

- (void)initViews {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"dd MMM, yyyy h:mm:ss a";
    if([GlobalService sharedInstance].user_me.my_user.user_status == TRIAL_USER) {
        self.m_lblTitle.text = @"Trial Version";
        self.m_lblContent.text = [NSString stringWithFormat:@"You are using the trial version. It will expire on %@", [dateFormatter stringFromDate:[[GlobalService sharedInstance].user_me.my_user.user_created_at dateByAddingMonths:1]]];
        self.m_btnBuy.enabled = YES;
        self.m_btnBuy.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"#7EC95F"];
        self.m_btnRestore.enabled = YES;
        self.m_btnRestore.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"#7EC95F"];
        self.m_btnBack.hidden = NO;
    } else if([GlobalService sharedInstance].user_me.my_user.user_status == PAID_USER) {
        self.m_lblTitle.text = @"Paid Version";
        self.m_lblContent.text = [NSString stringWithFormat:@"You are using the paid version. It will expire on %@", [dateFormatter stringFromDate:[[MKStoreKit sharedKit] expiryDateForProduct:IN_APP_PURCHASE_UPGRADE_USER]]];
        self.m_btnBuy.enabled = NO;
        self.m_btnBuy.backgroundColor = [UIColor grayColor];
        self.m_btnRestore.enabled = NO;
        self.m_btnRestore.backgroundColor = [UIColor grayColor];
        self.m_btnBack.hidden = NO;
    } else {
        self.m_lblTitle.text = @"Your subscription has expired!";
        self.m_lblContent.text = @"Your subscription has expired. Please renew your subscription.";
        self.m_btnBuy.enabled = YES;
        self.m_btnBuy.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"#7EC95F"];
        self.m_btnRestore.enabled = YES;
        self.m_btnRestore.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"#7EC95F"];
        self.m_btnBack.hidden = YES;
    }
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

- (IBAction)onClickBtnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onClickBtnBuy:(id)sender {
    [[MKStoreKit sharedKit] initiatePaymentRequestForProductWithIdentifier:IN_APP_PURCHASE_UPGRADE_USER];
}

- (IBAction)onClickBtnRestore:(id)sender {
    [[MKStoreKit sharedKit] restorePurchases];
}

- (void)onRestoredPurchases {
    NSDate *expireAt = [[MKStoreKit sharedKit] expiryDateForProduct:IN_APP_PURCHASE_UPGRADE_USER];
    if([expireAt compare:[NSDate date]] != NSOrderedDescending) {
        [self.view makeToast:@"Your purchases have been restored successfully" duration:3.f position:CSToastPositionCenter];
        [GlobalService sharedInstance].user_me.my_user.user_status = PAID_USER;
        [[GlobalService sharedInstance] saveMe:[GlobalService sharedInstance].user_me];
        [self initViews];
    } else {
        [self.view makeToast:@"Your purchases have been restored successfully but there are no valid items" duration:3.f position:CSToastPositionCenter];
    }
}

- (void)onFailedRestorePurchases {
    [self.view makeToast:@"Purchase restore failed" duration:3.f position:CSToastPositionCenter];
}

- (void)onProductPurchases {
    [GlobalService sharedInstance].user_me.my_user.user_status = PAID_USER;
    [[GlobalService sharedInstance] saveMe:[GlobalService sharedInstance].user_me];
    [self initViews];
}

- (void)onFailedProductPurchases {
    [self.view makeToast:@"Product purchase failed" duration:3.f position:CSToastPositionCenter];
}

@end
