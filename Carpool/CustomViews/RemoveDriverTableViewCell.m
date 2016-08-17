//
//  RemoveDriverTableViewCell.m
//  Carpool
//
//  Created by JH Lee on 4/24/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import "RemoveDriverTableViewCell.h"

@implementation RemoveDriverTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)onClickBtnRemove:(id)sender {
    [self.delegate onClickBtnRemove:m_nRow];
}

- (void)setViewsWithDriver:(DriverObj *)objDriver onRow:(NSInteger)row {
    m_nRow = row;
    
    self.m_lblDriverName.text = [NSString stringWithFormat:@"%@ %@", objDriver.driver_first_name, objDriver.driver_last_name];
    switch (objDriver.driver_status) {
        case DRIVER_STATUS_ACCEPT:
            self.m_imgStatus.image = [UIImage imageNamed:@"event_icon_invitation_accept"];
            break;
            
        case DRIVER_STATUS_PENDING:
            self.m_imgStatus.image = [UIImage imageNamed:@"event_icon_invitation_pending"];
            break;
            
        case DRIVER_STATUS_REJECT:
            self.m_imgStatus.image = [UIImage imageNamed:@"event_icon_invitation_reject"];
            break;
            
        default:
            break;
    }
}

@end
