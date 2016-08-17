//
//  EventTableViewCell.m
//  Carpool
//
//  Created by JH Lee on 4/16/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import "EventTableViewCell.h"

@implementation EventTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setViewWithJHEvent:(JHEvent *)event onRow:(NSInteger)row {
    m_nRow = row;
    
    self.m_lblTime.text = [NSString stringWithFormat:@"%@\n%@", event.eventStartTime, event.eventEndTime];
    self.m_lblTitle.text = event.event_title;
    
    if(row % 2 == 0) {
        [self setBackgroundColor:[UIColor whiteColor]];
    } else {
        [self setBackgroundColor:[UIColor clearColor]];
    }
}

- (IBAction)onClickBtnDetail:(id)sender {
    if([self.delegate respondsToSelector:@selector(onClickBtnDetail:)]) {
        [self.delegate onClickBtnDetail:m_nRow];
    }
}

@end
