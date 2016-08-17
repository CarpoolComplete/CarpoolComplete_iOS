//
//  ChooseRepeatViewController.h
//  Carpool
//
//  Created by JH Lee on 4/18/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SetRepeatEndViewController.h"

@interface ChooseRepeatViewController : UIViewController {
    NSArray     *m_aryRepeatString;
    EventObj    *tempEvent;
}

@property (weak, nonatomic) IBOutlet UITableView *m_tblRepeat;

@property (nonatomic, retain) EventObj          *selected_event;

- (IBAction)onClickBtnBack:(id)sender;
- (IBAction)onClickBtnDone:(id)sender;

@end
