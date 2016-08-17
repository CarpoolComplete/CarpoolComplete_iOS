//
//  TabBarViewController.h
//  Carpool
//
//  Created by JH Lee on 4/11/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import <RDVTabBarController/RDVTabBarController.h>
#import "EventDayViewController.h"
#import "EventMonthViewController.h"

@interface TabBarViewController : RDVTabBarController<RDVTabBarControllerDelegate, RDVTabBarDelegate, UIAlertViewDelegate>

@property (nonatomic, retain) EventDayViewController    *m_eventDayVC;
@property (nonatomic, retain) EventMonthViewController  *m_eventMonthVC;

@end
