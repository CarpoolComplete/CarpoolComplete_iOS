//
//  RemoveDriverTableViewCell.h
//  Carpool
//
//  Created by JH Lee on 4/24/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RemoveDriverTableViewCellDelegate <NSObject>

- (void)onClickBtnRemove:(NSInteger)row;

@end

@interface RemoveDriverTableViewCell : UITableViewCell {
    NSInteger m_nRow;
}

@property (weak, nonatomic) IBOutlet UILabel *m_lblDriverName;
@property (weak, nonatomic) IBOutlet UIImageView *m_imgStatus;

@property (nonatomic, retain) id<RemoveDriverTableViewCellDelegate> delegate;

- (IBAction)onClickBtnRemove:(id)sender;
- (void)setViewsWithDriver:(DriverObj *)objDriver onRow:(NSInteger)row;

@end
