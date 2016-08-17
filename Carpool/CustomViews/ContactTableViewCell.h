//
//  ContactTableViewCell.h
//  Carpool
//
//  Created by JH Lee on 4/18/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ContactTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *m_lblMobileLocal;
@property (weak, nonatomic) IBOutlet UIButton *m_btnStatus;
@property (weak, nonatomic) IBOutlet UILabel *m_lblMobile;

@end
