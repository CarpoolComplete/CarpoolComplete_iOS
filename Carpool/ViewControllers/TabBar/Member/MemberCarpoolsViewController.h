//
//  MemberCarpoolsViewController.h
//  Carpool
//
//  Created by JH Lee on 4/27/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iCarousel/iCarousel.h>
#import <FXPageControl/FXPageControl.h>
#import "EventView.h"

@interface MemberCarpoolsViewController : UIViewController<EventViewDelegate, EventViewDataSource>

@property (weak, nonatomic) IBOutlet iCarousel      *m_viewCarousel;
@property (weak, nonatomic) IBOutlet FXPageControl  *m_ctlPage;

- (IBAction)onClickBtnCancel:(id)sender;
- (IBAction)onClickBtnPrev:(id)sender;
- (IBAction)onClickBtnNext:(id)sender;

@end
