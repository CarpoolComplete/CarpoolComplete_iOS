//
//  MemberDriverTableViewCell.h
//  Carpool
//
//  Created by JH Lee on 4/27/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MemberDriverTableViewCellDelegate <NSObject>

- (void)onClickBtnChat:(NSInteger)row;
- (void)onClickBtnPhone:(NSInteger)row;
- (void)onClickBtnEmail:(NSInteger)row;

@end

@interface MemberDriverTableViewCell : UITableViewCell {
    NSInteger   m_nRow;
}

@property (weak, nonatomic) IBOutlet UILabel *m_lblDriverName;
@property (weak, nonatomic) IBOutlet UIImageView *m_imgChat;
@property (weak, nonatomic) IBOutlet UIImageView *m_imgStatus;
@property (weak, nonatomic) IBOutlet UIButton *m_btnPhone;
@property (weak, nonatomic) IBOutlet UIButton *m_btnEmail;

@property (nonatomic, retain) id<MemberDriverTableViewCellDelegate> delegate;

- (void)setViewsWithDriverObj:(DriverObj *)objDriver onRow:(NSInteger)row;

- (IBAction)onClickBtnPhone:(id)sender;
- (IBAction)onClickBtnEmail:(id)sender;

@end
