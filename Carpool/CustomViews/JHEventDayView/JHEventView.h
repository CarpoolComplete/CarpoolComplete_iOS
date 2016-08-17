//
//  JHEventView.h
//  Carpool
//
//  Created by JH Lee on 4/15/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHEvent.h"

@protocol JHEventViewDelegate <NSObject>

- (void)onTapEvent:(JHEvent *)event;
- (void)onTapFromHandle:(JHEvent *)event driverId:(NSNumber *)driver_id;
- (void)onTapToHandle:(JHEvent *)event driverId:(NSNumber *)driver_id;

@end

@interface JHEventView : UIView {
    NSArray     *m_aryDrivers;
}

@property (weak, nonatomic) IBOutlet UIView         *m_viewContainer;
@property (weak, nonatomic) IBOutlet UIView         *m_viewMain;
@property (weak, nonatomic) IBOutlet UIView         *m_viewTop;
@property (weak, nonatomic) IBOutlet UILabel        *m_lblEventTitle;
@property (weak, nonatomic) IBOutlet UILabel        *m_lblTime;

@property (weak, nonatomic) IBOutlet UIImageView    *m_imgGoCar;
@property (weak, nonatomic) IBOutlet UILabel        *m_lblToPassengers;
@property (weak, nonatomic) IBOutlet UILabel        *m_lblToDrivers;
@property (weak, nonatomic) IBOutlet UIImageView    *m_imgToHandle;
@property (weak, nonatomic) IBOutlet UIImageView    *m_imgToError;

@property (weak, nonatomic) IBOutlet UILabel        *m_lblDevider;

@property (weak, nonatomic) IBOutlet UIImageView    *m_imgComeCar;
@property (weak, nonatomic) IBOutlet UILabel        *m_lblFromPassengers;
@property (weak, nonatomic) IBOutlet UILabel        *m_lblFromDrivers;
@property (weak, nonatomic) IBOutlet UIImageView    *m_imgFromHandle;
@property (weak, nonatomic) IBOutlet UIImageView    *m_imgFromError;

@property (nonatomic, retain) JHEvent               *m_event;

@property (nonatomic, readwrite) int                draw_level;

@property (nonatomic, retain) id<JHEventViewDelegate> delegate;

- (void)setViewWithEvent:(JHEvent *)event;
- (IBAction)onTapEvent:(id)sender;
- (IBAction)onClickToHandler:(id)sender;
- (IBAction)onClickFromHandler:(id)sender;

@end
