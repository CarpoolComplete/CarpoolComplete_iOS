//
//  InviteDriverViewController.m
//  Carpool
//
//  Created by JH Lee on 4/18/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import "InviteDriverViewController.h"
#import "ContactCollectionViewCell.h"
#import "ContactTableViewCell.h"
#import "ContactUserObj.h"
#import <TrAnimate/TrAnimate.h>

#define KEY_LABEL_PADDING_X     5
#define COLLECTION_CHECK_WIDTH  35

@interface InviteDriverViewController ()

@end

@implementation InviteDriverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.m_searchBar.text = @"";
    
    m_aryContactUsers = [NSMutableArray arrayWithArray:[GlobalService sharedInstance].user_contacts];
    
    m_aryTempContacts = [[NSMutableArray alloc] init];
    [self getFilteredContacts:@""];
    
    m_arySelectedContacts = [[NSMutableArray alloc] init];
    self.m_tblContact.layer.masksToBounds = YES;
    self.m_tblContact.layer.cornerRadius = 5.f;
    
    if(![[NSUserDefaults standardUserDefaults] boolForKey:USER_DEFAULTS_KEY_FIRST_INVITE]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:USER_DEFAULTS_KEY_FIRST_INVITE];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        self.m_viewTutorial.hidden = NO;
    }
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

- (IBAction)onClickBtnCancel:(id)sender {
    if([self.navigationController.viewControllers containsObject:[GlobalService sharedInstance].menu_vc]) {
        [self.navigationController popToViewController:[GlobalService sharedInstance].menu_vc animated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)onClickBtnDone:(id)sender {
    [self.m_searchBar resignFirstResponder];
    
    if(m_arySelectedContacts.count > 0) {
        NSMutableArray *aryDicContacts = [[NSMutableArray alloc] init];
        for(ContactUserObj *objContact in m_arySelectedContacts) {
            [aryDicContacts addObject:objContact.currentDictionary];
        }
        
        SVPROGRESSHUD_PLEASE_WAIT;
        [[WebService sharedInstance] sendInvitationToDrivers:aryDicContacts
                                                    ForEvent:self.selected_event.event_id
                                                      succss:^(NSArray *aryDrivers) {
                                                          SVPROGRESSHUD_DISMISS;
                                                          [self.selected_event.event_drivers addObjectsFromArray:aryDrivers];
                                                          [[GlobalService sharedInstance] saveMe:[GlobalService sharedInstance].user_me];
                                                          if([self.navigationController.viewControllers containsObject:[GlobalService sharedInstance].menu_vc]) {
                                                              [self.navigationController popToViewController:[GlobalService sharedInstance].menu_vc animated:YES];
                                                          } else {
                                                              [self dismissViewControllerAnimated:YES completion:nil];
                                                          }
                                                      }
                                                     failure:^(NSString *strError) {
                                                         SVPROGRESSHUD_ERROR(strError);
                                                     }];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)onClickBtnGotIt:(id)sender {
    [TrScaleAnimation animate:self.m_viewTutorial duration:0.3f delay:0.f fromScaleFactor:1.f toScaleFactor:0.f];
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self getFilteredContacts:searchText];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    [self getFilteredContacts:searchBar.text];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    [self getFilteredContacts:@""];
}

- (void)getFilteredContacts:(NSString *)strKey {
    NSMutableArray *aryContacts = [[NSMutableArray alloc] init];
    if([strKey isEqualToString:@""]) {
        aryContacts = [NSMutableArray arrayWithArray:m_aryContactUsers];
    } else {
        for(ContactUserObj *objContact in m_aryContactUsers) {
            NSString *strName = [NSString stringWithFormat:@"%@ %@", objContact.contact_first_name, objContact.contact_last_name];
            if([strName.lowercaseString containsString:strKey.lowercaseString]) {
                [aryContacts addObject:objContact];
            }
        }
    }
    
    m_aryEventContacts = [[NSMutableArray alloc] init];
    //remove event driver from contact users
    for(ContactUserObj *objContact in [GlobalService sharedInstance].user_contacts) {
        if([self isAddedUser:objContact]) {
            [m_aryEventContacts addObject:objContact];
        }
    }
    
    m_aryIndexTitles = [[NSMutableArray alloc] init];
    for(ContactUserObj *objContact in aryContacts) {
        [m_aryIndexTitles addObject:[NSString stringWithFormat:@"%@ %@", objContact.contact_first_name, objContact.contact_last_name]];
    }
    m_aryIndexTitles = [[[[NSSet setWithArray:m_aryIndexTitles] allObjects] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)] mutableCopy];
    
    [m_aryTempContacts removeAllObjects];
    for(int nIndex = 0; nIndex < m_aryIndexTitles.count; nIndex++) {
        NSString *strName = m_aryIndexTitles[nIndex];
        NSMutableArray *arySection = [[NSMutableArray alloc] init];
        for(ContactUserObj *objContact in aryContacts) {
            NSString *strContactorName = [NSString stringWithFormat:@"%@ %@", objContact.contact_first_name, objContact.contact_last_name];
            if([strName isEqualToString:strContactorName]) {
                [arySection addObject:objContact];
            }
        }
        
        [m_aryTempContacts addObject:arySection];
        [m_aryIndexTitles replaceObjectAtIndex:nIndex withObject:[strName substringToIndex:1].uppercaseString];
    }
    
    [self.m_cltContact reloadData];
    [self.m_tblContact reloadData];
}

#pragma mark - TableView DataSource

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return m_aryIndexTitles;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return [m_aryIndexTitles indexOfObject:title];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return m_aryTempContacts.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ContactUserObj *objContactor = m_aryTempContacts[section][0];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.frame), 30)];
    headerView.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, CGRectGetWidth(tableView.frame), 30)];
    label.font = [UIFont fontWithName:@"Helvetica Neue Bold" size:20.f];
    label.textColor = [UIColor blackColor];
    label.text = [NSString stringWithFormat:@"%@ %@", objContactor.contact_first_name, objContactor.contact_last_name];
    
    [headerView addSubview:label];
    
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.frame), 30)];
    headerView.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, CGRectGetWidth(tableView.frame) - 20, 1)];
    label.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"#007AFF"];
    
    [headerView addSubview:label];
    
    return headerView;
}


- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [m_aryTempContacts[section] count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContactUserObj *objContact = m_aryTempContacts[indexPath.section][indexPath.row];
    
    ContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContactTableViewCell"];
    cell.m_lblMobileLocal.text = objContact.contact_phone_local;
    cell.m_lblMobile.text = objContact.contact_phone_number;
    
    if([m_arySelectedContacts containsObject:objContact]
       || [self isAddedUser:objContact]) {
        cell.m_btnStatus.selected = YES;
        cell.m_lblMobile.textColor = [UIColor lightGrayColor];
    } else {
        cell.m_btnStatus.selected = NO;
        cell.m_lblMobile.textColor = [UIColor blackColor];
    }
    
    return cell;
}

#pragma mark - TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ContactTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    ContactUserObj *objContact = m_aryTempContacts[indexPath.section][indexPath.row];
    if(![self isAddedUser:objContact]) {
        cell.m_btnStatus.selected = !cell.m_btnStatus.selected;
        if(cell.m_btnStatus.selected) {
            [m_arySelectedContacts addObject:objContact];
            [self.m_cltContact insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:(m_aryEventContacts.count + m_arySelectedContacts.count - 1) inSection:0]]];
        } else {
            NSInteger nItem = [m_arySelectedContacts indexOfObject:objContact];
            [m_arySelectedContacts removeObject:objContact];
            [self.m_cltContact deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:m_aryEventContacts.count + nItem inSection:0]]];
        }
    }
}

#pragma mark - CollectionView delegate

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return m_aryEventContacts.count + m_arySelectedContacts.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    ContactUserObj *objContact = nil;
    
    if(indexPath.item < m_aryEventContacts.count) {
         objContact = m_aryEventContacts[indexPath.item];
    } else {
        objContact = m_arySelectedContacts[indexPath.item - m_aryEventContacts.count];
    }
    
    NSAttributedString *searchKey = [[NSAttributedString alloc] initWithString:objContact.initialName
                                                                    attributes:@{
                                                                                 NSFontAttributeName:[UIFont fontWithName:@"Helvetica Neue" size:16.f]
                                                                                 }];
    return [self getCollectionViewSizeForText:searchKey];
}

#pragma mark - CollectionView datasource

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ContactCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ContactCollectionViewCell"
                                                                                forIndexPath:indexPath];
    
    ContactUserObj *objContact = nil;
    if(indexPath.item < m_aryEventContacts.count) {
        cell.m_lblName.textColor = [UIColor lightGrayColor];
        objContact = m_aryEventContacts[indexPath.item];
    } else {
        objContact = m_arySelectedContacts[indexPath.item - m_aryEventContacts.count];
    }
    
    cell.m_lblName.text = objContact.initialName;
    
    return cell;
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.item >= m_aryEventContacts.count) {
        [m_arySelectedContacts removeObjectAtIndex:indexPath.item - m_aryEventContacts.count];
        [collectionView deleteItemsAtIndexPaths:@[indexPath]];
        
        [self.m_tblContact reloadData];
    }
}

- (CGSize)getCollectionViewSizeForText:(NSAttributedString *)txt
{
    CGFloat maxWidth = 1000;
    CGFloat maxHeight = 40;
    
    CGSize stringSize;
    
    CGRect stringRect = [txt boundingRectWithSize:CGSizeMake(maxWidth, maxHeight)
                                          options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                          context:nil];
    
    stringSize = CGRectIntegral(stringRect).size;
    stringSize.height = maxHeight;
    stringSize.width += KEY_LABEL_PADDING_X * 2 + COLLECTION_CHECK_WIDTH;
    
    return stringSize;
}

- (BOOL)isAddedUser:(ContactUserObj *)objContactor {
    BOOL is_event_user = NO;
    for(DriverObj *objDriver in self.selected_event.event_drivers) {
        if([objContactor.contact_phone_number isEqualToString:objDriver.driver_phone] &&
           objDriver.driver_status != DRIVER_STATUS_REJECT) {
            is_event_user = YES;
            break;
        }
    }
    
    return is_event_user;
}

@end
