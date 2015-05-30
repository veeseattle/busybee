//
//  ActivityLogViewController.m
//  ottoinsurance
//
//  Created by Vania Kurniawati on 5/26/15.
//  Copyright (c) 2015 vivavania. All rights reserved.
//

#import "ActivityLogViewController.h"
#import "LogTableViewCell.h"
#import "AppUtils.h"
#import <Parse/Parse.h>

@interface ActivityLogViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *activitiesArray;

@property (weak, nonatomic) IBOutlet UIView *customTopView;
@property (weak, nonatomic) IBOutlet UILabel *topViewStatLabel;

@property (assign) NSInteger currentMonth;

@end

@implementation ActivityLogViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  self.tableView.allowsMultipleSelectionDuringEditing = NO;
  self.tableView.rowHeight = 110;
  self.tableView.userInteractionEnabled = true;
  
  UINib *nib = [UINib nibWithNibName:@"LogTableViewCell" bundle:nil];
  [self.tableView registerNib:nib forCellReuseIdentifier:@"LOG_CELL"];
  
  UIImageView *titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ottotitleview.png"]];
  self.navigationItem.titleView = titleView;
  
  //create drop shadow under the custom top view
  UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.customTopView.bounds];
  self.customTopView.layer.masksToBounds = NO;
  self.customTopView.layer.shadowColor = [UIColor blackColor].CGColor;
  self.customTopView.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
  self.customTopView.layer.shadowOpacity = 0.5f;
  self.customTopView.layer.shadowPath = shadowPath.CGPath;
  
  [self getDataForTableView];
  
  self.currentMonth = [self getCurrentMonth:[NSDate date]];
}

- (void) getDataForTableView {
  [AppUtils fetchTrips:^(NSArray *objects) {
    dispatch_async(dispatch_get_main_queue(), ^{
      self.activitiesArray = objects;
      [self.tableView reloadData];
      [self recalculateTotalForMonth];
    });
  }];
}

- (NSInteger) getCurrentMonth:(NSDate *)date {
  NSDate *currentDate = [NSDate date];
  NSCalendar *calendar = [NSCalendar currentCalendar];
  NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:currentDate]; // Get necessary date components
  NSInteger currentMonth = [components month];
  return currentMonth;
}

#pragma mark - topViewStat method

- (void) recalculateTotalForMonth {
  int elapsed = 0;
  
  //for every trip from Parse, filter for current month and calculate total hours driven
  for (PFObject *trip in self.activitiesArray) {
    NSInteger tripMonth = [self getCurrentMonth:trip.createdAt];
    if (tripMonth == self.currentMonth) {
      elapsed += [trip[@"duration"] intValue];
    }
  }
  
  //format total hours, mins, secs
  int hours = (int) (elapsed / 3600);
  elapsed -= hours * 3600;
  int mins = (int) (elapsed / 60);
  elapsed -= mins * 60;
  int secs = (int) elapsed;
  
  //format current date into MMMM yyyy (e.g. May 2015)
  NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
  [dateFormat setDateFormat:@"MMMM yyyy"];
  NSString *dateString = [dateFormat stringFromDate:[NSDate date]];
  
  self.topViewStatLabel.text = [NSString stringWithFormat:@"%@ | %u h %u m %02u s", dateString, hours, mins, secs];
}


#pragma mark - Parse methods

- (void)deleteTrip:(NSString *)objectId {
  PFQuery *query = [PFQuery queryWithClassName:@"Trip"];
  [query whereKey:@"objectId" equalTo:objectId];
  [query getObjectInBackgroundWithId:objectId block:^(PFObject *trip, NSError *error){
    [trip deleteInBackground];
    dispatch_async(dispatch_get_main_queue(), ^{
      [self getDataForTableView];
    });
  }];
}

#pragma mark - UITableView data source & delegate methods

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  LogTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LOG_CELL" forIndexPath:indexPath];
  PFObject *trip = self.activitiesArray[indexPath.row];
  
  //display trip date in Month dd, yyyy format
  NSDate *startDate = trip[@"startTime"];
  NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
  [dateFormat setDateFormat:@"MMMM dd, yyyy"];
  NSString *dateString = [dateFormat stringFromDate:startDate];
  cell.tripDateLabel.text = dateString;
  
  //display start time in hh:mm format
  NSCalendar *calendar = [NSCalendar currentCalendar];
  NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:startDate];
  NSInteger hour = [components hour];
  NSInteger minute = [components minute];
  NSString *startTime = [NSString stringWithFormat:@"%ld:%ld", (long)hour, (long)minute];
  cell.startTimeLabel.text = startTime;
  
  //display end time in hh:mm format
  NSDate *endTime = trip.createdAt;
  NSDateComponents *endTimeComponents = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:endTime];
  NSInteger endHour = [endTimeComponents hour];
  NSInteger endMinute = [endTimeComponents minute];
  NSString *endTimeString = [NSString stringWithFormat:@"%ld:%ld", (long)endHour, (long)endMinute];
  cell.endTimeLabel.text = endTimeString;
  
  //calculate and display duration in hours, mins, and secs
  int elapsed = [trip[@"duration"] intValue];
  int hours = (int) (elapsed / 3600);
  elapsed -= hours * 3600;
  int mins = (int) (elapsed / 60);
  elapsed -= mins * 60;
  int secs = (int) elapsed;
  NSString *durationString = [NSString stringWithFormat:@"%u h %u m %02u s", hours, mins, secs];
  cell.tripDurationLabel.text = durationString;
  
  return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.activitiesArray.count;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
  return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    NSString *objectIdToDelete = [self.activitiesArray[indexPath.row] objectId];
    [self deleteTrip:objectIdToDelete];
    [self.tableView reloadData];
  }
}


@end
