//
//  ChooseAlertViewController.h
//  Carpool
//
//  Created by JH Lee on 4/18/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseAlertViewController : UIViewController {
    NSDictionary    *m_dicAlert;
    NSArray         *m_aryAlertKyes;
}

@property (weak, nonatomic) IBOutlet UITableView    *m_tblAlert;

@property (nonatomic, retain) EventDetailObj        *selected_event_detail;

- (IBAction)onClickBtnBack:(id)sender;

@end
