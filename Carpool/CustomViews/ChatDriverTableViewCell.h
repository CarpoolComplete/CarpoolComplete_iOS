//
//  ChatDriverTableViewCell.h
//  Carpool
//
//  Created by JH Lee on 4/25/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChatDriverTableViewCellDelegate <NSObject>

- (void)onClickBtnPhoneCall:(NSInteger)row;

@end

@interface ChatDriverTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *m_lblDriverName;
@property (weak, nonatomic) IBOutlet UIButton *m_btnCheck;
@property (weak, nonatomic) IBOutlet UIButton *m_btnPhone;

@property (nonatomic, readwrite) NSInteger      m_nRow;
@property (nonatomic, retain) id<ChatDriverTableViewCellDelegate> delegate;

- (IBAction)onClickBtnCall:(id)sender;

@end
