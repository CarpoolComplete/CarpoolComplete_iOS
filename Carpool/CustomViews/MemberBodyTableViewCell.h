//
//  MemberBodyTableViewCell.h
//  Carpool
//
//  Created by JH Lee on 4/26/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MemberBodyTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *m_imgBackground;
@property (weak, nonatomic) IBOutlet UILabel *m_lblName;
@property (weak, nonatomic) IBOutlet UIImageView *m_imgMarker;
@property (weak, nonatomic) IBOutlet UILabel *m_lblDivider;

@end
