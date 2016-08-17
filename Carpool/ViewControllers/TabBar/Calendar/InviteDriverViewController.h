//
//  InviteDriverViewController.h
//  Carpool
//
//  Created by JH Lee on 4/18/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InviteDriverViewController : UIViewController {
    NSMutableArray  *m_aryContactUsers;
    NSMutableArray  *m_aryTempContacts;
    NSMutableArray  *m_aryIndexTitles;
    NSMutableArray  *m_arySelectedContacts;
    
    NSMutableArray  *m_aryEventContacts;
}

@property (weak, nonatomic) IBOutlet UISearchBar *m_searchBar;
@property (weak, nonatomic) IBOutlet UICollectionView *m_cltContact;
@property (weak, nonatomic) IBOutlet UITableView *m_tblContact;
@property (weak, nonatomic) IBOutlet UIView *m_viewTutorial;

@property (nonatomic, retain) EventObj          *selected_event;

- (IBAction)onClickBtnCancel:(id)sender;
- (IBAction)onClickBtnDone:(id)sender;
- (IBAction)onClickBtnGotIt:(id)sender;

@end
