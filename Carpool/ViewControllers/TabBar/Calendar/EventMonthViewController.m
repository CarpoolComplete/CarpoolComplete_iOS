//
//  EventMonthViewController.m
//  Carpool
//
//  Created by JH Lee on 4/16/16.
//  Copyright © 2016 JH Lee. All rights reserved.
//

#import "EventMonthViewController.h"
#import "EventDetailViewController.h"
#import "EventAddViewController.h"
#import "JHEvent.h"

@interface EventMonthViewController ()

@end

@implementation EventMonthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //FSCalendarAppearanceSetting
    self.m_monthView.appearance.todayColor = [UIColor blueColor];
    self.m_monthView.appearance.selectionColor = [UIColor hx_colorWithHexRGBAString:@"#FB9C49"];
    
    self.m_lblDisplayMonth.text = [self.m_monthView stringFromDate:self.m_monthView.currentPage format:@"MMMM yyyy"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onUpdateEvent)
                                                 name:NOTIFICATION_UPDATE_EVENT
                                               object:nil];
}

- (void)onUpdateEvent {
    [self.m_monthView reloadData];
    m_arySelectedDateEvents = [[GlobalService sharedInstance] getEventsForDate:[GlobalService sharedInstance].active_date];
    [self.m_tblEvent reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self onUpdateEvent];
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

- (IBAction)onClickBtnPrev:(id)sender {
    NSDate *currentMonth = self.m_monthView.currentPage;
    NSDate *previousMonth = [self.m_monthView dateBySubstractingMonths:1 fromDate:currentMonth];
    [self.m_monthView setCurrentPage:previousMonth animated:YES];
}

- (IBAction)onClickBtnNext:(id)sender {
    NSDate *currentMonth = self.m_monthView.currentPage;
    NSDate *nextMonth = [self.m_monthView dateByAddingMonths:1 toDate:currentMonth];
    [self.m_monthView setCurrentPage:nextMonth animated:YES];
}

- (IBAction)onClickBtnAddEvent:(id)sender {
    EventAddViewController *eventAddVC = [self.storyboard instantiateViewControllerWithIdentifier:@"EventAddViewController"];
    eventAddVC.m_objEventDetail = [[EventDetailObj alloc] init];
    [[GlobalService sharedInstance].menu_vc.navigationController pushViewController:eventAddVC animated:YES];
}

#pragma mark - FSCalendarDelegate
- (void)calendarCurrentPageDidChange:(FSCalendar *)calendar {
    self.m_lblDisplayMonth.text = [calendar stringFromDate:calendar.currentPage format:@"MMMM yyyy"];
}

- (NSInteger)calendar:(FSCalendar *)calendar numberOfEventsForDate:(NSDate *)date
{
    NSArray *aryEvents = [[GlobalService sharedInstance] getEventsForDate:date];
    return aryEvents.count;
}

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date {
    [GlobalService sharedInstance].active_date = date;
    m_arySelectedDateEvents = [[GlobalService sharedInstance] getEventsForDate:date];
    [self.m_tblEvent reloadData];
}

#pragma mark - TableView DataSource

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return m_arySelectedDateEvents.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EventTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EventTableViewCell"];
    JHEvent *event = m_arySelectedDateEvents[indexPath.row];
    [cell setViewWithJHEvent:event onRow:indexPath.row];
    cell.delegate = self;
    
    return cell;
}

#pragma mark - TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [GlobalService sharedInstance].tabbar_vc.m_eventDayVC.m_jhEvent = m_arySelectedDateEvents[indexPath.row];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - EventTableViewCellDelegate

- (void)onClickBtnDetail:(NSInteger)row {
    JHEvent *event = m_arySelectedDateEvents[row];
    [self performSegueWithIdentifier:@"GoFromEventMonthVCToEventDetailVC" sender:event];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UINavigationController *eventDetailNC = (UINavigationController *)segue.destinationViewController;
    EventDetailViewController *eventDetailVC = (EventDetailViewController *)eventDetailNC.viewControllers[0];
    eventDetailVC.m_jhEvent = (JHEvent *)sender;
    
    [super prepareForSegue:segue sender:sender];
}

@end
