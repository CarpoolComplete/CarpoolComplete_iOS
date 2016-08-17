//
//  MemberHeaderTableViewCell.h
//  Carpool
//
//  Created by JH Lee on 4/26/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MemberHeaderTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *m_imgBackground;
@property (weak, nonatomic) IBOutlet UIImageView *m_imgIcon;
@property (weak, nonatomic) IBOutlet UILabel *m_lblTitle;
@property (weak, nonatomic) IBOutlet UIImageView *m_imgMarker;

@end
