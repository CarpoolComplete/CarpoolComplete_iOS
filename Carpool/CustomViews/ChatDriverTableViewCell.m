//
//  ChatDriverTableViewCell.m
//  Carpool
//
//  Created by JH Lee on 4/25/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import "ChatDriverTableViewCell.h"

@implementation ChatDriverTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)onClickBtnCall:(id)sender {
    [self.delegate onClickBtnPhoneCall:self.m_nRow];
}

@end
