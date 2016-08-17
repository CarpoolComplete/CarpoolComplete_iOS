//
//  HelpCategoryViewController.m
//  Carpool
//
//  Created by JH Lee on 5/12/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import "HelpCategoryViewController.h"
#import "AlertTableViewCell.h"
#import "HelpDetailViewController.h"

@interface HelpCategoryViewController ()

@end

@implementation HelpCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    m_aryHelpTitles = @[
                        @"Getting Started",
                        @"View Menu",
                        @"Scheduling Events",
                        @"Inviting Drivers",
                        @"Adding/Removing Passengers to A Carpool",
                        @"Choosing a Driving Assignment",
                        @"Contacting Other Drivers",
                        @"Members Section",
                        @"Invites",
                        @"Settings Section"
                        ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)onClickBtnMenu:(id)sender {
    [self.sideMenuViewController presentLeftMenuViewController];
}

#pragma mark - TableViewDataSource

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return m_aryHelpTitles.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSAttributedString *strTitle = [[NSAttributedString alloc] initWithString:m_aryHelpTitles[indexPath.row]
                                                                   attributes:@{
                                                                                NSFontAttributeName: [UIFont fontWithName:@"Helvetica Neue" size:16.f]
                                                                                }];
    return [self labelHeightForText:strTitle] + 24.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AlertTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AlertTableViewCell"];
    
    if(indexPath.row == 0) {
        cell.m_imgBackground.image = [UIImage imageNamed:@"login_image_topcell"];
        cell.m_lblDivider.hidden = NO;
    }else if(indexPath.row == m_aryHelpTitles.count - 1) {
        cell.m_imgBackground.image = [UIImage imageNamed:@"login_image_bottomcell"];
        cell.m_lblDivider.hidden = YES;
    } else {
        cell.m_imgBackground.image = [UIImage imageNamed:@"login_image_midcell"];
        cell.m_lblDivider.hidden = NO;
    }
    
    cell.m_lblAlert.text = m_aryHelpTitles[indexPath.row];
    
    [cell setBackgroundColor:[UIColor clearColor]];
    return cell;
}

#pragma mark - TableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HelpDetailViewController *helpDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HelpDetailViewController"];
    helpDetailVC.selected_index = indexPath.row;
    [self.navigationController pushViewController:helpDetailVC animated:YES];
}

- (CGFloat)labelHeightForText:(NSAttributedString *)txt
{
    CGFloat maxWidth = self.view.frame.size.width - 70;
    CGFloat maxHeight = 1000;
    
    CGSize stringSize;
    
    CGRect stringRect = [txt boundingRectWithSize:CGSizeMake(maxWidth, maxHeight)
                                          options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                          context:nil];
    
    stringSize = CGRectIntegral(stringRect).size;
    
    return roundf(stringSize.height);
}

@end
