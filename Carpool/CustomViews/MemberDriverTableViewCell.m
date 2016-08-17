//
//  MemberDriverTableViewCell.m
//  Carpool
//
//  Created by JH Lee on 4/27/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import "MemberDriverTableViewCell.h"

@implementation MemberDriverTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setViewsWithDriverObj:(DriverObj *)objDriver onRow:(NSInteger)row {
    m_nRow = row;
    
    self.m_lblDriverName.text = [NSString stringWithFormat:@"%@ %@", objDriver.driver_first_name, objDriver.driver_last_name];
    
    if(objDriver.driver_user_id.intValue == [GlobalService sharedInstance].my_user_id.intValue) {
        self.m_imgChat.hidden = YES;
        self.m_btnEmail.hidden = YES;
        self.m_btnPhone.hidden = YES;
    }
    
    self.m_imgChat.image = [self.m_imgChat.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.m_imgChat setTintColor:[UIColor hx_colorWithHexRGBAString:@"#007AFF"]];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickBtnChat)];
    [self.m_imgChat addGestureRecognizer:tap];
    
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
    
    if(objDriver.driver_email.length > 0) {
        self.m_btnEmail.hidden = NO;
    } else {
        self.m_btnEmail.hidden = YES;
    }
}

- (void)onClickBtnChat {
    [self.delegate onClickBtnChat:m_nRow];
}

- (IBAction)onClickBtnPhone:(id)sender {
    [self.delegate onClickBtnPhone:m_nRow];
}

- (IBAction)onClickBtnEmail:(id)sender {
    [self.delegate onClickBtnEmail:m_nRow];
}

@end
