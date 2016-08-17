//
//  AddPassengersViewController.h
//  Carpool
//
//  Created by JH Lee on 4/21/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddPassengersViewController : UIViewController {
    NSMutableArray *m_aryTmpPassengers;
}

@property (nonatomic, retain) NSMutableArray        *m_aryPassengers;

@property (weak, nonatomic) IBOutlet UITableView    *m_tblPassenger;

- (IBAction)onClickBtnDone:(id)sender;
- (IBAction)onClickBtnCancel:(id)sender;

@end
