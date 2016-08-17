//
//  TutorialDayViewController.m
//  Carpool Complete
//
//  Created by JH Lee on 8/1/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import "TutorialDayViewController.h"
#import "TutorialDetailViewController.h"
#import "JHEvent.h"
#import <TrAnimate/TrAnimate.h>

@interface TutorialDayViewController ()

@end

@implementation TutorialDayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    m_isThirdTip = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    JHEventDayView *dayView = [[JHEventDayView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.m_viewTutorialDay.frame), CGRectGetHeight(self.m_viewTutorialDay.frame))];
    [self.m_viewTutorialDay addSubview:dayView];
    dayView.delegate = self;
    dayView.dataSource = self;
    dayView.view_date = [[NSDate date] dateByAddingDays:-1];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [dayView setContentOffset:CGPointMake(0, -1) animated:NO];
        [dayView setScrollEnabled:NO];
    });
    
    [self showFirstTip];
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

#pragma mark - JHEventDayViewDataSource
- (NSArray *)eventsInDayView:(JHEventDayView *)dayView {
    return [[GlobalService sharedInstance] getJHEventsForTutorial];
}

#pragma mark - JHEventDayViewDelegate
- (void)dayView:(JHEventDayView *)dayView didSelectedEvent:(JHEvent *)event {
    if(m_isThirdTip) {
        [self performSegueWithIdentifier:@"GoFromTutorialDayVCToTutorialDetailVC" sender:event];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    TutorialDetailViewController *eventDetailVC = (TutorialDetailViewController *)segue.destinationViewController;
    eventDetailVC.m_jhEvent = (JHEvent *)sender;
    
    [super prepareForSegue:segue sender:sender];
}

- (void)showFirstTip {
    [self.view addSubview:self.m_viewFirstTip];
    CGRect frame = self.m_viewFirstTip.frame;
    frame.origin.x = 30.f;
    frame.origin.y = CGRectGetHeight(self.view.frame);
    self.m_viewFirstTip.frame = frame;

    [TrPositionAnimation animate:self.m_viewFirstTip duration:0.5f delay:0.5f toPosition:CGPointMake(30.f, 220.f)];
}

- (IBAction)onClickBtnFirstTip:(id)sender {
    [TrFadeAnimation animate:self.m_viewFirstTip
                    duration:0.1f
                       delay:0.f
                   direction:TrFadeAnimationDirectionOut
                       curve:nil
                  completion:^(BOOL finished) {
                      [self.m_viewFirstTip removeFromSuperview];
                      [self showSecondTip];
                  }];
}

- (void)showSecondTip {
    [self.view addSubview:self.m_viewSecondTip];
    CGRect frame = self.m_viewSecondTip.frame;
    frame.origin.x = CGRectGetWidth(self.view.frame) - 320.f;
    frame.origin.y = CGRectGetHeight(self.view.frame);
    self.m_viewSecondTip.frame = frame;
    
    [TrPositionAnimation animate:self.m_viewSecondTip duration:0.5f delay:0.f toPosition:CGPointMake(self.m_viewSecondTip.frame.origin.x, 60.f)];
}

- (IBAction)onClickBtnSecondTip:(id)sender {
    [TrFadeAnimation animate:self.m_viewSecondTip
                    duration:0.1f
                       delay:0.f
                   direction:TrFadeAnimationDirectionOut
                       curve:nil
                  completion:^(BOOL finished) {
                      [self.m_viewSecondTip removeFromSuperview];
                      [self showThirdTip];
                  }];
}

- (void)showThirdTip {
    m_isThirdTip = YES;
    [self.view addSubview:self.m_viewThirdTip];
    self.m_viewThirdTip.center = self.view.center;
    [TrScaleAnimation animate:self.m_viewThirdTip duration:0.3f delay:0.f fromScaleFactor:0.f toScaleFactor:1.f];
}

@end
