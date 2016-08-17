//
//  FamilyTableViewCell.h
//  Carpool
//
//  Created by JH Lee on 4/11/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    CELL_POSITION_TOP = 0,
    CELL_POSITION_MIDDLE,
    CELL_POSITION_BOTTOM,
    CELL_POSITION_SINGLE,
    CELL_POSITION_ADD_NEW
}CELL_POSITION;

@interface FamilyTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *m_imgBackground;
@property (weak, nonatomic) IBOutlet UIImageView *m_imgIcon;
@property (weak, nonatomic) IBOutlet UILabel *m_lblName;
@property (weak, nonatomic) IBOutlet UILabel *m_lblDevider;

- (void)setViewsWithPosition:(CELL_POSITION)position withTitle:(NSString *)title;

@end
