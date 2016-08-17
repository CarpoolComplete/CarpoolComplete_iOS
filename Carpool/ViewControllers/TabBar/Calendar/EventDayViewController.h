//
//  EventDayViewController.h
//  Carpool
//
//  Created by JH Lee on 4/12/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHEventDayView.h"

@interface EventDayViewController : UIViewController<JHEventDayViewDataSource, JHEventDayViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *m_lblDisplayDate;
@property (weak, nonatomic) IBOutlet UIScrollView *m_sclDayContainer;
@property (nonatomic, retain) JHEvent *m_jhEvent;

- (IBAction)onClickBtnMenu:(id)sender;
- (IBAction)onClickBtnPrev:(id)sender;
- (IBAction)onClickBtnNext:(id)sender;
- (IBAction)onClickBtnAddEvent:(id)sender;

@end
