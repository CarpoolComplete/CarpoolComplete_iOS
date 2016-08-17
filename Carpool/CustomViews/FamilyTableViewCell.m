//
//  FamilyTableViewCell.m
//  Carpool
//
//  Created by JH Lee on 4/11/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import "FamilyTableViewCell.h"

@implementation FamilyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setViewsWithPosition:(CELL_POSITION)position withTitle:(NSString *)title {
    
    self.m_lblName.text = title;
    
    switch (position) {
        case CELL_POSITION_TOP:
            self.m_imgBackground.image = [UIImage imageNamed:@"login_image_topcell"];
            break;
            
        case CELL_POSITION_MIDDLE:
            self.m_imgBackground.image = [UIImage imageNamed:@"login_image_midcell"];
            break;
        
        case CELL_POSITION_BOTTOM:
            self.m_imgBackground.image = [UIImage imageNamed:@"login_image_bottomcell"];
            self.m_lblDevider.hidden = YES;
            break;
            
        case CELL_POSITION_SINGLE:
            self.m_imgBackground.image = [UIImage imageNamed:@"login_image_onecell"];
            self.m_imgIcon.image = [UIImage imageNamed:@"login_icon_plus"];
            self.m_lblName.textColor = [UIColor hx_colorWithHexRGBAString:@"#82b6f8"];
            self.m_lblDevider.hidden = YES;
            break;
            
        case CELL_POSITION_ADD_NEW:
            self.m_imgBackground.image = [UIImage imageNamed:@"login_image_bottomcell"];
            self.m_imgIcon.image = [UIImage imageNamed:@"login_icon_plus"];
            self.m_lblName.textColor = [UIColor hx_colorWithHexRGBAString:@"#82b6f8"];
            self.m_lblDevider.hidden = YES;
            break;
            
        default:
            break;
    }
}

@end
