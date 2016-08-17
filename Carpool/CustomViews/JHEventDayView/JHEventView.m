//
//  JHEventView.m
//  Carpool
//
//  Created by JH Lee on 4/15/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import "JHEventView.h"
#import <TrAnimate/TrAnimate.h>

typedef enum {
    FadeIn = 0,
    FadeOut
}ANIMATION_TYPE;

@implementation JHEventView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (void)setViewWithEvent:(JHEvent *)event {
    self.m_event = event;
    [self initViews:NO isTo:NO];
}

- (void)initViews:(BOOL)animated isTo:(BOOL)isTo {
    
    if([self.m_event.event_userInfo[@"event_from_driver_id"] intValue] == 0
       || [self.m_event.event_userInfo[@"event_to_driver_id"] intValue] == 0) {
        self.m_event.event_view_background_color = [UIColor hx_colorWithHexRGBAString:@"#d23a2f"];
    } else {
        self.m_event.event_view_background_color = [UIColor hx_colorWithHexRGBAString:@"#0fb402"];
    }
    
    m_aryDrivers = self.m_event.event_userInfo[@"event_drivers"];
    
    self.m_viewContainer.layer.masksToBounds = YES;
    self.m_viewContainer.layer.cornerRadius = 10.f;
    self.m_viewContainer.layer.borderColor = self.m_event.event_view_background_color.CGColor;
    self.m_viewContainer.layer.borderWidth = 1.f;
    
    self.m_viewTop.backgroundColor = self.m_event.event_view_background_color;
    self.m_viewMain.backgroundColor = [self.m_event.event_view_background_color colorWithAlphaComponent:0.1f];
    
    self.m_lblEventTitle.text = self.m_event.event_title;
    
    self.m_lblTime.text = [NSString stringWithFormat:@"%@-%@", self.m_event.eventStartTime, self.m_event.eventEndTime];
    
    self.m_imgGoCar.image = [self.m_imgGoCar.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.m_imgGoCar setTintColor:self.m_event.event_view_background_color];
    
    self.m_lblToPassengers.text = [NSString stringWithFormat:@"%d", (int)[self.m_event.event_userInfo[@"event_passengers"] count]];
    self.m_lblToPassengers.textColor = self.m_event.event_view_background_color;
    
    if([self.m_event.event_userInfo[@"event_to_driver_id"] intValue] > 0) {
        for(int nIndex = 0; nIndex < m_aryDrivers.count; nIndex++) {
            DriverObj *objDriver = m_aryDrivers[nIndex];
            if(objDriver.driver_user_id.intValue == [self.m_event.event_userInfo[@"event_to_driver_id"] intValue]) {
                self.m_lblToDrivers.text = objDriver.initialName;
                if(animated && isTo) {
                    [TrScaleAnimation animate:self.m_lblToDrivers
                                     duration:0.1f
                                        delay:0.f
                              fromScaleFactor:0.f
                                toScaleFactor:1.f];
                }
                break;
            }
        }
        self.m_lblToDrivers.textColor = self.m_event.event_view_background_color;
        self.m_imgToError.hidden = YES;
    } else {
        if(animated && isTo) {
            [TrScaleAnimation animate:self.m_lblToDrivers
                             duration:0.1f
                                delay:0.f
                      fromScaleFactor:1.f
                        toScaleFactor:0.f
                                curve:nil
                           completion:^(BOOL finished) {
                               self.m_lblToDrivers.text = @"";
                           }];
        } else {
            self.m_lblToDrivers.text = @"";
        }
        self.m_imgToError.hidden = NO;
        
    }
    
    self.m_imgToHandle.image = [self.m_imgToHandle.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.m_imgToHandle setTintColor:self.m_event.event_view_background_color];
    
    self.m_lblDevider.backgroundColor = self.m_event.event_view_background_color;
    
    self.m_imgComeCar.image = [self.m_imgComeCar.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.m_imgComeCar setTintColor:self.m_event.event_view_background_color];
    
    self.m_lblFromPassengers.text = [NSString stringWithFormat:@"%d", (int)[self.m_event.event_userInfo[@"event_passengers"] count]];
    self.m_lblFromPassengers.textColor = self.m_event.event_view_background_color;
    
    if([self.m_event.event_userInfo[@"event_from_driver_id"] intValue] > 0) {
        for(int nIndex = 0; nIndex < m_aryDrivers.count; nIndex++) {
            DriverObj *objDriver = m_aryDrivers[nIndex];
            if(objDriver.driver_user_id.intValue == [self.m_event.event_userInfo[@"event_from_driver_id"] intValue]) {
                self.m_lblFromDrivers.text = objDriver.initialName;
                if(animated && !isTo) {
                    [TrScaleAnimation animate:self.m_lblFromDrivers
                                     duration:0.1f
                                        delay:0.f
                              fromScaleFactor:0.f
                                toScaleFactor:1.f];
                }
                break;
            }
        }
        self.m_lblFromDrivers.textColor = self.m_event.event_view_background_color;
        self.m_imgFromError.hidden = YES;
    } else {
        if(animated && !isTo) {
            [TrScaleAnimation animate:self.m_lblFromDrivers
                             duration:0.1f
                                delay:0.f
                      fromScaleFactor:1.f
                        toScaleFactor:0.f
                                curve:nil
                           completion:^(BOOL finished) {
                               self.m_lblFromDrivers.text = @"";
                           }];
        } else {
            self.m_lblFromDrivers.text = @"";
        }
        self.m_imgFromError.hidden = NO;
        
    }
    
    self.m_imgFromHandle.image = [self.m_imgFromHandle.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.m_imgFromHandle setTintColor:self.m_event.event_view_background_color];
}

- (IBAction)onTapEvent:(id)sender {
    [self.delegate onTapEvent:self.m_event];
}

- (IBAction)onClickToHandler:(id)sender {
    
    NSMutableDictionary *dicUserInfo = [NSMutableDictionary dictionaryWithDictionary:self.m_event.event_userInfo];
    if([dicUserInfo[@"event_to_driver_id"] integerValue] == 0) {    // No Driver
        dicUserInfo[@"event_to_driver_id"] = [GlobalService sharedInstance].my_user_id;
    } else if ([dicUserInfo[@"event_to_driver_id"] integerValue] == [GlobalService sharedInstance].my_user_id.integerValue) {   // Me
        dicUserInfo[@"event_to_driver_id"] = @0;
    } else {
        return;
    }
    
    self.m_event.event_userInfo = dicUserInfo;
    [self initViews:YES isTo:YES];
    [self.delegate onTapToHandle:self.m_event driverId:dicUserInfo[@"event_to_driver_id"]];
}

- (IBAction)onClickFromHandler:(id)sender {
    NSMutableDictionary *dicUserInfo = [NSMutableDictionary dictionaryWithDictionary:self.m_event.event_userInfo];
    if([dicUserInfo[@"event_from_driver_id"] integerValue] == 0) {    // No Driver
        dicUserInfo[@"event_from_driver_id"] = [GlobalService sharedInstance].my_user_id;
    } else if ([dicUserInfo[@"event_from_driver_id"] integerValue] == [GlobalService sharedInstance].my_user_id.integerValue) {   // Me
        dicUserInfo[@"event_from_driver_id"] = @0;
    } else {
        return;
    }
    
    self.m_event.event_userInfo = dicUserInfo;
    [self initViews:YES isTo:NO];
    [self.delegate onTapFromHandle:self.m_event driverId:dicUserInfo[@"event_from_driver_id"]];
}

@end
