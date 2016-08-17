//
//  TutorialDetailViewController.h
//  Carpool Complete
//
//  Created by JH Lee on 8/1/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TutorialDetailViewController : UIViewController {
    NSMutableArray                  *m_aryPassengers;
}

@property (weak, nonatomic) IBOutlet UITableView *m_tblToPassenger;
@property (weak, nonatomic) IBOutlet UITableView *m_tblFromPassenger;
@property (nonatomic, retain) JHEvent       *m_jhEvent;

- (IBAction)onClickBtnGotIt:(id)sender;

@end
