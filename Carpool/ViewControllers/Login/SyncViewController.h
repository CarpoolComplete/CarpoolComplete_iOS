//
//  SyncViewController.h
//  Carpool
//
//  Created by JH Lee on 4/11/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SyncViewController : UIViewController {
    NSDate      *m_sync_start_date;
    NSDate      *m_sync_end_date;
}

@property (weak, nonatomic) IBOutlet UILabel *m_lblWeekDay;
@property (weak, nonatomic) IBOutlet UILabel *m_lblDate;

- (IBAction)onClickBtnSyncCalendar:(id)sender;
- (IBAction)onClickBtnNoThanks:(id)sender;

@end
