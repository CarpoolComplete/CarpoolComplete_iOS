//
//  InviteRootViewController.m
//  Carpool
//
//  Created by JH Lee on 4/27/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import "InviteRootViewController.h"
#import "InviteDriverViewController.h"
#import "RemoveDriverViewController.h"
#import "AddPassengersViewController.h"
#import "EventAddChildViewController.h"

@interface InviteRootViewController ()

@end

@implementation InviteRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    m_bSent = NO;
    self.m_viewCarousel.type = iCarouselTypeRotary;
    self.m_viewCarousel.pagingEnabled = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onUpdateEvent)
                                                 name:NOTIFICATION_UPDATE_EVENT
                                               object:nil];
}

- (void)onUpdateEvent {
    m_arySentEvents = [[NSMutableArray alloc] init];
    for(EventObj *objEvent in [GlobalService sharedInstance].user_me.my_events) {
        if(objEvent.event_user_id.intValue == [GlobalService sharedInstance].my_user_id.intValue
           && objEvent.event_drivers.count > 0) {
            [m_arySentEvents addObject:objEvent];
        }
    }
    
    m_aryInvitations = [[NSMutableArray alloc] init];
    for(EventObj *objEvent in [GlobalService sharedInstance].user_me.my_invitations) {
        if([objEvent.event_repeat_end_at compare:[NSDate date].dateAtBeginningOfDay] != NSOrderedAscending) {
            [m_aryInvitations addObject:objEvent];
        }
    }
    
    [self.m_viewCarousel reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self onUpdateEvent];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - iCarouselDataSource
- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel {
    if(m_bSent) {
        if(m_arySentEvents.count > 0) {
            self.m_lblComment.hidden = YES;
        } else {
            self.m_lblComment.text = @"There is no sent invitation";
            self.m_lblComment.hidden = NO;
        }
        
        self.m_ctlPage.numberOfPages = m_arySentEvents.count;
        self.m_ctlPage.currentPage = 0;
        return m_arySentEvents.count;
    } else {
        if(m_aryInvitations.count > 0) {
            self.m_lblComment.hidden = YES;
        } else {
            self.m_lblComment.text = @"There is no received invitation";
            self.m_lblComment.hidden = NO;
        }
        
        self.m_ctlPage.numberOfPages = m_aryInvitations.count;
        self.m_ctlPage.currentPage = 0;
        return m_aryInvitations.count;
    }
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(nullable UIView *)view {
    if(view == nil) {
        EventObj *objEvent = nil;
        if(m_bSent) {
            objEvent = m_arySentEvents[index];
        } else {
            objEvent = m_aryInvitations[index];
        }
        
        EventView *viewEvent = [[[NSBundle mainBundle] loadNibNamed:@"EventView" owner:nil options:nil] objectAtIndex:0];
        viewEvent.frame = CGRectMake(10, 10, CGRectGetWidth(carousel.frame) - 20, CGRectGetHeight(carousel.frame) - 20);
        viewEvent.delegate = self;
        viewEvent.datasource = self;
        
        [viewEvent setViewsWithEvent:objEvent onIndex:index origin:self];
        
        if(m_bSent) {
            viewEvent.m_lblTableLabel.text = @"Invited Drivers";
        } else {
            [viewEvent.m_btnInviteDrivers setImage:[UIImage imageNamed:@"invite_icon_check"] forState:UIControlStateNormal];
            [viewEvent.m_btnInviteDrivers setTitle:@"ACCEPT" forState:UIControlStateNormal];
            [viewEvent.m_btnRemoveDrivers setTitle:@"DECLINE" forState:UIControlStateNormal];
            
            DriverObj *objInvitationDriver = [[GlobalService sharedInstance] getMyDriverFrom:objEvent];
            if(objInvitationDriver) {
                if(objInvitationDriver.driver_status == DRIVER_STATUS_ACCEPT) {
                    viewEvent.m_btnInviteDrivers.enabled = NO;
                    viewEvent.m_btnInviteDrivers.backgroundColor = [UIColor lightGrayColor];
                } else {
                    viewEvent.m_btnInviteDrivers.enabled = YES;
                    viewEvent.m_btnInviteDrivers.backgroundColor = [UIColor clearColor];
                }
            }
        }
        
        return viewEvent;
    }
    
    return view;
}

#pragma mark - iCarouselDelegate
- (void)carouselDidScroll:(iCarousel *)carousel {
    NSInteger currentItemIndex = carousel.currentItemIndex;
    self.m_ctlPage.currentPage = currentItemIndex;
}

#pragma mark - EventViewDataSource
- (NSArray *)driverOfEvent:(NSInteger)index {
    NSMutableArray *aryDrivers = [[NSMutableArray alloc] init];
    
    EventObj *objEvent = nil;
    if(m_bSent) {
        objEvent = m_arySentEvents[index];
        
        for(DriverObj *objDriver in objEvent.event_drivers) {
            [aryDrivers addObject:objDriver];
        }
        
    } else {
        objEvent = m_aryInvitations[index];
        
        for(DriverObj *objDriver in objEvent.event_drivers) {
            if(objDriver.driver_status == DRIVER_STATUS_ACCEPT) {
                [aryDrivers addObject:objDriver];
            }
        }
    }
    
    //insert event creator as driver
    DriverObj *objDriver = [[DriverObj alloc] init];
    objDriver.driver_user_id = objEvent.event_user_id;
    objDriver.driver_first_name = objEvent.event_creator_first_name;
    objDriver.driver_last_name = objEvent.event_creator_last_name;
    objDriver.driver_phone = objEvent.event_creator_phone;
    [aryDrivers insertObject:objDriver atIndex:0];
    
    return aryDrivers;
}

- (NSInteger)indexOfDriverCell:(NSInteger)index {
    if(m_bSent) {
        return 0;
    } else {
        return 1;
    }
}

#pragma mark - EventViewDelegate
- (void)onClickBtnInviteDrivers:(NSInteger)nIndex {
    if(m_bSent) {
        InviteDriverViewController *inviteDriverVC = [self.storyboard instantiateViewControllerWithIdentifier:@"InviteDriverViewController"];
        inviteDriverVC.selected_event = m_arySentEvents[nIndex];
        [[GlobalService sharedInstance].menu_vc.navigationController pushViewController:inviteDriverVC animated:YES];
    } else {
        EventObj *objEvent = m_aryInvitations[nIndex];
        DriverObj *objInvitationDriver = [[GlobalService sharedInstance] getMyDriverFrom:objEvent];
        
        //accept
        SVPROGRESSHUD_PLEASE_WAIT;
        [[WebService sharedInstance] updateInvitationStatusWithId:objInvitationDriver.driver_invitation_id
                                                           Status:DRIVER_STATUS_ACCEPT
                                                          success:^(NSString *strResult) {
                                                              SVPROGRESSHUD_DISMISS;
                                                              objInvitationDriver.driver_status = DRIVER_STATUS_ACCEPT;
                                                              [[GlobalService sharedInstance].user_me addEvent:objEvent];
                                                              [[GlobalService sharedInstance] updateInvitesBadges];
                                                              
                                                              [self.m_viewCarousel reloadData];
                                                              
                                                              // Go to first day of day view
                                                              EventDetailObj *objEventDetailObj = [[GlobalService sharedInstance] getEventDetailFromEvent:objEvent onDate:objEvent.firstEventDate];
                                                              JHEvent *jhEvent = [[GlobalService sharedInstance] getJHEventFromEventObj:objEvent
                                                                                                                            displayDate:objEvent.firstEventDate
                                                                                                                         EventDetailObj:objEventDetailObj];
                                                              
                                                              [GlobalService sharedInstance].tabbar_vc.m_eventDayVC.m_jhEvent = jhEvent;
                                                              
                                                              UINavigationController *calendarNC = (UINavigationController *)[GlobalService sharedInstance].tabbar_vc.viewControllers[0];
                                                              [calendarNC popToRootViewControllerAnimated:NO];
                                                              [GlobalService sharedInstance].tabbar_vc.selectedIndex = 0;
                                                          }
                                                          failure:^(NSString *strError) {
                                                              SVPROGRESSHUD_ERROR(strError);
                                                          }];
    }
}

- (void)onClickBtnRemoveDrivers:(NSInteger)nIndex {
    if(m_bSent) {
        RemoveDriverViewController *removeDriverVC = [self.storyboard instantiateViewControllerWithIdentifier:@"RemoveDriverViewController"];
        removeDriverVC.selected_event = m_arySentEvents[nIndex];
        [[GlobalService sharedInstance].menu_vc.navigationController pushViewController:removeDriverVC animated:YES];
    } else {
        EventObj *objEvent = m_aryInvitations[nIndex];
        DriverObj *objInvitationDriver = [[GlobalService sharedInstance] getMyDriverFrom:objEvent];
        
        SVPROGRESSHUD_PLEASE_WAIT;
        [[WebService sharedInstance] updateInvitationStatusWithId:objInvitationDriver.driver_invitation_id
                                                           Status:DRIVER_STATUS_REJECT
                                                          success:^(NSString *strResult) {
                                                              SVPROGRESSHUD_DISMISS;
                                                              [m_aryInvitations removeObject:objEvent];
                                                              [[GlobalService sharedInstance].user_me removeEvent:objEvent.event_id];
                                                              
                                                              [self.m_viewCarousel reloadData];
                                                          }
                                                          failure:^(NSString *strError) {
                                                              SVPROGRESSHUD_ERROR(strError);
                                                          }];
    }
}

- (IBAction)onClickBtnPrev:(id)sender {
    NSInteger currentItemIndex = self.m_viewCarousel.currentItemIndex;
    if(m_bSent) {
        if(currentItemIndex == 0) {
            currentItemIndex = m_arySentEvents.count - 1;
        } else {
            currentItemIndex--;
        }
    } else {
        if(currentItemIndex == 0) {
            currentItemIndex = m_aryInvitations.count - 1;
        } else {
            currentItemIndex--;
        }
    }
    
    [self.m_viewCarousel scrollToItemAtIndex:currentItemIndex animated:YES];
}

- (IBAction)onClickBtnNext:(id)sender {
    NSInteger currentItemIndex = self.m_viewCarousel.currentItemIndex;
    if(m_bSent) {
        if(currentItemIndex == m_arySentEvents.count - 1) {
            currentItemIndex = 0;
        } else {
            currentItemIndex++;
        }
    } else {
        if(currentItemIndex == m_aryInvitations.count - 1) {
            currentItemIndex = 0;
        } else {
            currentItemIndex++;
        }
    }
    
    [self.m_viewCarousel scrollToItemAtIndex:currentItemIndex animated:YES];
}

- (IBAction)onClickBtnMenu:(id)sender {
    [self.sideMenuViewController presentLeftMenuViewController];
}

- (IBAction)onChangeKind:(id)sender {
    UISegmentedControl *seg = (UISegmentedControl *)sender;
    if(seg.selectedSegmentIndex == 0) {
        m_bSent = NO;
    } else {
        m_bSent = YES;
    }
    
    [self.m_viewCarousel reloadData];
}

@end
