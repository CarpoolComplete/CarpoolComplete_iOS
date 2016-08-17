//
//  AlertTableViewCell.h
//  Carpool
//
//  Created by JH Lee on 4/18/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlertTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *m_imgBackground;
@property (weak, nonatomic) IBOutlet UILabel *m_lblAlert;
@property (weak, nonatomic) IBOutlet UIImageView *m_imgStatus;
@property (weak, nonatomic) IBOutlet UILabel *m_lblDivider;

@end
