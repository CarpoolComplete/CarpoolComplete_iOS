//
//  HelpDetailViewController.h
//  Carpool
//
//  Created by JH Lee on 5/12/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HelpDetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIWebView *m_webView;
@property (nonatomic, readwrite) NSInteger selected_index;

- (IBAction)onClickBtnBack:(id)sender;

@end
