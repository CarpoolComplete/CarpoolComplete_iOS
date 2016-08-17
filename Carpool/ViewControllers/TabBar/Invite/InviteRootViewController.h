//
//  InviteRootViewController.h
//  Carpool
//
//  Created by JH Lee on 4/27/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iCarousel/iCarousel.h>
#import <FXPageControl/FXPageControl.h>
#import "EventView.h"

@interface InviteRootViewController : UIViewController<EventViewDelegate, EventViewDataSource> {
    BOOL                m_bSent;
    NSMutableArray      *m_arySentEvents;
    NSMutableArray      *m_aryInvitations;
}

@property (weak, nonatomic) IBOutlet UISegmentedControl *m_segInviteKind;
@property (weak, nonatomic) IBOutlet iCarousel *m_viewCarousel;
@property (weak, nonatomic) IBOutlet UILabel *m_lblComment;
@property (weak, nonatomic) IBOutlet FXPageControl *m_ctlPage;

- (IBAction)onClickBtnPrev:(id)sender;
- (IBAction)onClickBtnNext:(id)sender;
- (IBAction)onClickBtnMenu:(id)sender;
- (IBAction)onChangeKind:(id)sender;

@end
