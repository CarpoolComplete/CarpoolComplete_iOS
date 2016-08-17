//
//  EventDayViewController.m
//  Carpool
//
//  Created by JH Lee on 4/12/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import "EventDayViewController.h"
#import "EventDetailViewController.h"
#import "EventAddViewController.h"
#import "JHEvent.h"

@interface EventDayViewController ()

@end

@implementation EventDayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [GlobalService sharedInstance].active_date = [NSDate date].dateAtBeginningOfDay;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onUpdateEvent)
                                                 name:NOTIFICATION_UPDATE_EVENT
                                               object:nil];
}

- (void)onUpdateEvent {
    [self reloadDayData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if(self.m_jhEvent) {
        [GlobalService sharedInstance].active_date = self.m_jhEvent.event_display_at;
    }
    
    self.m_lblDisplayDate.text = [self titleString];
    
    [self initDayContainer];
    
    [self reloadDayData];
}

- (void)initDayContainer {
    if(self.m_sclDayContainer.subviews.count > 0) {
        return;
    }
    
    for(int nIndex = 0; nIndex < 3; nIndex++) {
        JHEventDayView *dayView = [[JHEventDayView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.m_sclDayContainer.frame) * nIndex,
                                                                                   0,
                                                                                   CGRectGetWidth(self.m_sclDayContainer.frame),
                                                                                   CGRectGetHeight(self.m_sclDayContainer.frame))];
        dayView.dataSource = self;
        dayView.delegate = self;
        dayView.tag = 10 + nIndex;
        [self.m_sclDayContainer addSubview:dayView];
    }
    
    self.m_sclDayContainer.contentSize = CGSizeMake(CGRectGetWidth(self.m_sclDayContainer.frame) * 3, CGRectGetHeight(self.m_sclDayContainer.frame));
}

- (void)reloadDayData {
    for(int nIndex = 0; nIndex < 3; nIndex++) {
        JHEventDayView *dayView = [self.m_sclDayContainer viewWithTag:10 + nIndex];
        dayView.view_date = [[GlobalService sharedInstance].active_date dateByAddingDays:nIndex - 1];
    }
    
    [self scrollToIndex:1 animated:NO];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        JHEventDayView *centerDayView = [self.m_sclDayContainer viewWithTag:11];
        if(self.m_jhEvent) {
            [centerDayView scrollToJHEvent:self.m_jhEvent];
            self.m_jhEvent = nil;
        } else {
            [centerDayView setContentOffset:CGPointMake(0, -1) animated:YES];
        }
    });
}

- (void)scrollToIndex:(NSInteger)index animated:(BOOL)animated {
    [self.m_sclDayContainer setContentOffset:CGPointMake(CGRectGetWidth(self.m_sclDayContainer.frame) * index, 0)
                                    animated:animated];
}

- (NSString *)titleString {
    return [[GlobalService sharedInstance] stringFromDate:[GlobalService sharedInstance].active_date withFormat:@"EEE MMM dd yyyy"];
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

#pragma mark UIScrollViewDelegate

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if(scrollView.contentOffset.x < CGRectGetWidth(scrollView.frame)) {
        [GlobalService sharedInstance].active_date = [[GlobalService sharedInstance].active_date dateByAddingDays:-1];
    } else if(scrollView.contentOffset.x > CGRectGetWidth(scrollView.frame)) {
        [GlobalService sharedInstance].active_date = [[GlobalService sharedInstance].active_date dateByAddingDays:1];
    }
    
    self.m_lblDisplayDate.text = [self titleString];
    [self reloadDayData];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    JHEventDayView *centerView = [self.m_sclDayContainer viewWithTag:11];
    
    JHEventDayView *leftView = [self.m_sclDayContainer viewWithTag:10];
    [leftView setContentOffset:centerView.getCurrentPoint animated:NO];
    
    JHEventDayView *rightView = [self.m_sclDayContainer viewWithTag:12];
    [rightView setContentOffset:centerView.getCurrentPoint animated:NO];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if(scrollView.contentOffset.x == 0) {
        [GlobalService sharedInstance].active_date = [[GlobalService sharedInstance].active_date dateByAddingDays:-1];
    } else if(scrollView.contentOffset.x / scrollView.frame.size.width == 2) {
        [GlobalService sharedInstance].active_date = [[GlobalService sharedInstance].active_date dateByAddingDays:1];
    }
    
    self.m_lblDisplayDate.text = [self titleString];
    
    [self reloadDayData];
}

- (IBAction)onClickBtnMenu:(id)sender {
    [self.sideMenuViewController presentLeftMenuViewController];
}

- (IBAction)onClickBtnPrev:(id)sender {
    JHEventDayView *centerView = [self.m_sclDayContainer viewWithTag:11];
    
    JHEventDayView *leftView = [self.m_sclDayContainer viewWithTag:10];
    [leftView setContentOffset:centerView.getCurrentPoint animated:NO];
    
    [self scrollToIndex:0 animated:YES];
}

- (IBAction)onClickBtnNext:(id)sender {
    JHEventDayView *centerView = [self.m_sclDayContainer viewWithTag:11];

    JHEventDayView *rightView = [self.m_sclDayContainer viewWithTag:12];
    [rightView setContentOffset:centerView.getCurrentPoint animated:NO];
    
    [self scrollToIndex:2 animated:YES];
}

- (IBAction)onClickBtnAddEvent:(id)sender {
    EventAddViewController *eventAddVC = [self.storyboard instantiateViewControllerWithIdentifier:@"EventAddViewController"];
    eventAddVC.m_objEventDetail = [[EventDetailObj alloc] init];
    [[GlobalService sharedInstance].menu_vc.navigationController pushViewController:eventAddVC animated:YES];
}

#pragma mark - JHEventDayViewDataSource
- (NSArray *)eventsInDayView:(JHEventDayView *)dayView {
    return [[GlobalService sharedInstance] getEventsForDate:dayView.view_date];
}

#pragma mark - JHEventDayViewDelegate
- (void)dayView:(JHEventDayView *)dayView didSelectedEvent:(JHEvent *)event {
    [self performSegueWithIdentifier:@"GoFromEventDayVCToEventDetailVC" sender:event];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UINavigationController *eventDetailNC = (UINavigationController *)segue.destinationViewController;
    EventDetailViewController *eventDetailVC = (EventDetailViewController *)eventDetailNC.viewControllers[0];
    eventDetailVC.m_jhEvent = (JHEvent *)sender;
    
    [super prepareForSegue:segue sender:sender];
}

- (void)dayView:(JHEventDayView *)dayView didChangedEvent:(JHEvent *)event Driver:(NSNumber *)driver_id isTo:(BOOL)isTo{
    EventObj *objEvent = [[GlobalService sharedInstance] getEventObjFromJHEvent:event];
    if(objEvent) {        
        EventDriverObj *objEventDriver = [[EventDriverObj alloc] initWithDriverId:driver_id
                                                                       IsToDriver:isTo
                                                                       DriverDate:event.event_display_at];
        [[WebService sharedInstance] addEventId:objEvent.event_id
                                         UserId:[GlobalService sharedInstance].my_user_id
                                         Driver:objEventDriver
                                        success:^(NSArray *aryEventDrivers) {
                                            [objEvent.event_block_drivers setArray:aryEventDrivers];
                                            [[GlobalService sharedInstance] saveMe:[GlobalService sharedInstance].user_me];
                                        }
                                        failure:^(NSString *strError) {
                                            NSLog(@"%@", strError);
                                        }];
    }
}

- (void)dayView:(JHEventDayView *)dayView createNewEvent:(JHEvent *)event {
    EventAddViewController *eventAddVC = [self.storyboard instantiateViewControllerWithIdentifier:@"EventAddViewController"];
    EventDetailObj *objDetailEvent = [[EventDetailObj alloc] init];
    objDetailEvent.event_detail_start_at = event.event_start_at;
    objDetailEvent.event_detail_end_at = event.event_end_at;
    eventAddVC.m_objEventDetail = objDetailEvent;
    [[GlobalService sharedInstance].menu_vc.navigationController pushViewController:eventAddVC animated:YES];
}

@end
