//
//  EventPassengerViewController.h
//  Carpool
//
//  Created by JH Lee on 4/17/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EventPassengerViewControllerDelegate <NSObject> 

@required
- (void)onClickPassengerAlertDone;
- (void)onClickPassengerAlertCancel;

@end

@interface EventPassengerViewController : UIViewController {
    NSMutableArray  *m_aryTmpPassengers;
}

@property (weak, nonatomic) IBOutlet UITableView *m_tblPassenger;

@property (nonatomic, retain) id<EventPassengerViewControllerDelegate> delegate;

@property (nonatomic, retain) NSMutableArray  *m_aryPassengers;

- (IBAction)onClickBtnCancel:(id)sender;
- (IBAction)onClickBtnDone:(id)sender;

@end
