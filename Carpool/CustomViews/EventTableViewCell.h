//
//  EventTableViewCell.h
//  Carpool
//
//  Created by JH Lee on 4/16/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EventTableViewCellDelegate <NSObject>

@optional
- (void)onClickBtnDetail:(NSInteger)row;

@end

@interface EventTableViewCell : UITableViewCell {
    NSInteger m_nRow;
}

@property (weak, nonatomic) IBOutlet UILabel *m_lblTime;
@property (weak, nonatomic) IBOutlet UILabel *m_lblTitle;

@property (nonatomic, retain) id<EventTableViewCellDelegate> delegate;

- (void)setViewWithJHEvent:(JHEvent *)event onRow:(NSInteger)row;
- (IBAction)onClickBtnDetail:(id)sender;

@end
