//
//  TutorialDayViewController.h
//  Carpool Complete
//
//  Created by JH Lee on 8/1/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TutorialDayViewController : UIViewController<JHEventDayViewDataSource, JHEventDayViewDelegate> {
    BOOL    m_isThirdTip;
}

@property (weak, nonatomic) IBOutlet UIView *m_viewTutorialDay;

@property (strong, nonatomic) IBOutlet UIView *m_viewFirstTip;
@property (strong, nonatomic) IBOutlet UIView *m_viewSecondTip;
@property (strong, nonatomic) IBOutlet UIImageView *m_viewThirdTip;

- (IBAction)onClickBtnFirstTip:(id)sender;
- (IBAction)onClickBtnSecondTip:(id)sender;

@end
