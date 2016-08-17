//
//  MemberCarpoolsViewController.m
//  Carpool
//
//  Created by JH Lee on 4/27/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import "MemberCarpoolsViewController.h"
#import "InviteDriverViewController.h"
#import "RemoveDriverViewController.h"

@interface MemberCarpoolsViewController ()

@end

@implementation MemberCarpoolsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.m_viewCarousel.type = iCarouselTypeRotary;
    self.m_viewCarousel.pagingEnabled = YES;
    
    self.m_ctlPage.numberOfPages = [GlobalService sharedInstance].user_me.my_events.count;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.m_viewCarousel reloadData];
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

- (IBAction)onClickBtnPrev:(id)sender {
    NSInteger currentItemIndex = self.m_viewCarousel.currentItemIndex;
    if(currentItemIndex == 0) {
        currentItemIndex = [GlobalService sharedInstance].user_me.my_events.count - 1;
    } else {
        currentItemIndex--;
    }
    
    [self.m_viewCarousel scrollToItemAtIndex:currentItemIndex animated:YES];
}

- (IBAction)onClickBtnNext:(id)sender {
    NSInteger currentItemIndex = self.m_viewCarousel.currentItemIndex;
    if(currentItemIndex == [GlobalService sharedInstance].user_me.my_events.count - 1) {
        currentItemIndex = 0;
    } else {
        currentItemIndex++;
    }
    
    [self.m_viewCarousel scrollToItemAtIndex:currentItemIndex animated:YES];
}

#pragma mark - iCarouselDataSource
- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel {
    return [GlobalService sharedInstance].user_me.my_events.count;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(nullable UIView *)view {
    if(view == nil) {
        EventObj *objEvent = [GlobalService sharedInstance].user_me.my_events[index];
        EventView *viewEvent = [[[NSBundle mainBundle] loadNibNamed:@"EventView" owner:nil options:nil] objectAtIndex:0];
        viewEvent.frame = CGRectMake(10, 10, CGRectGetWidth(carousel.frame) - 20, CGRectGetHeight(carousel.frame) - 20);
        
        viewEvent.delegate = self;
        viewEvent.datasource = self;
        
        [viewEvent setViewsWithEvent:objEvent onIndex:index origin:self];
        
        if(objEvent.event_user_id.intValue == [GlobalService sharedInstance].my_user_id.intValue) {
            viewEvent.m_viewAction.hidden = NO;
        } else {
            viewEvent.m_viewAction.hidden = YES;
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
    NSMutableArray *aryAcceptedDrivers = [[NSMutableArray alloc] init];
    EventObj *objEvent = [GlobalService sharedInstance].user_me.my_events[index];
    
    for(DriverObj *objDriver in objEvent.event_drivers) {
        if(objDriver.driver_status == DRIVER_STATUS_ACCEPT) {
            [aryAcceptedDrivers addObject:objDriver];
        }
    }
    
    //insert event creator as driver
    DriverObj *objDriver = [[DriverObj alloc] init];
    objDriver.driver_user_id = objEvent.event_user_id;
    objDriver.driver_first_name = objEvent.event_creator_first_name;
    objDriver.driver_last_name = objEvent.event_creator_last_name;
    objDriver.driver_phone = objEvent.event_creator_phone;
    [aryAcceptedDrivers insertObject:objDriver atIndex:0];
    
    return aryAcceptedDrivers;
}

- (NSInteger)indexOfDriverCell:(NSInteger)index {
    return 0;
}

- (BOOL)hideStatusButton:(NSInteger)index {
    return NO;
}

#pragma mark - EventViewDelegate

- (void)onClickBtnInviteDrivers:(NSInteger)nIndex {
    InviteDriverViewController *inviteDriverVC = [self.storyboard instantiateViewControllerWithIdentifier:@"InviteDriverViewController"];
    inviteDriverVC.selected_event = [GlobalService sharedInstance].user_me.my_events[nIndex];
    [[GlobalService sharedInstance].menu_vc.navigationController pushViewController:inviteDriverVC animated:YES];
}

- (void)onClickBtnRemoveDrivers:(NSInteger)nIndex {
    RemoveDriverViewController *removeDriverVC = [self.storyboard instantiateViewControllerWithIdentifier:@"RemoveDriverViewController"];
    removeDriverVC.selected_event = [GlobalService sharedInstance].user_me.my_events[nIndex];
    [[GlobalService sharedInstance].menu_vc.navigationController pushViewController:removeDriverVC animated:YES];
}

@end
