//
//  EventDetailViewController.h
//  Carpool
//
//  Created by JH Lee on 4/16/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventPassengerViewController.h"

@interface EventDetailViewController : UIViewController<EventPassengerViewControllerDelegate> {
    EventPassengerViewController    *m_eventPassengerVC;
    EventObj                        *m_objEvent;
    EventDetailObj                  *m_objEventDetail;
    NSMutableArray                  *m_aryPassengers;
    
    NSNumber                        *m_toDriverId;
    NSNumber                        *m_fromDriverId;
}

@property (weak, nonatomic) IBOutlet UILabel *m_lblTitle;

@property (weak, nonatomic) IBOutlet UILabel *m_lblToEventName;
@property (weak, nonatomic) IBOutlet UILabel *m_lblEventStartTime;
@property (weak, nonatomic) IBOutlet UILabel *m_lblToDriverName;
@property (weak, nonatomic) IBOutlet UITableView *m_tblToPassenger;

@property (weak, nonatomic) IBOutlet UILabel *m_lblFromEventName;
@property (weak, nonatomic) IBOutlet UILabel *m_lblEventEndTime;
@property (weak, nonatomic) IBOutlet UILabel *m_lblFromDriverName;
@property (weak, nonatomic) IBOutlet UITableView *m_tblFromPassenger;

@property (weak, nonatomic) IBOutlet UIButton *m_btnAddPassenger;
@property (weak, nonatomic) IBOutlet UIButton *m_btnDeleteEvent;
@property (weak, nonatomic) IBOutlet UIButton *m_btnEdit;

@property (nonatomic, retain) JHEvent       *m_jhEvent;

- (IBAction)onClickBtnBack:(id)sender;
- (IBAction)onClickBtnEdit:(id)sender;
- (IBAction)onClickBtnAddPassengers:(id)sender;
- (IBAction)onClickBtnDeleteEvent:(id)sender;
- (IBAction)onClickBtnChat:(id)sender;
- (IBAction)onTapToDriverName:(id)sender;
- (IBAction)onTapFromDriverName:(id)sender;

@end
