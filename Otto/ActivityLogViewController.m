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
@property (weak, nonatomic) IBOutlet UIButton *refreshButton;

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
  
//  UIImageView *titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"busybeetitleview.png"]];
//  titleView.contentMode = UIViewContentModeScaleAspectFill;
//  self.navigationItem.titleView = titleView;
  
  //create drop shadow under the custom top view
  UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.customTopView.bounds];
  self.customTopView.layer.masksToBounds = NO;
  self.customTopView.layer.shadowColor = [UIColor blackColor].CGColor;
  self.customTopView.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
  self.customTopView.layer.shadowOpacity = 0.5f;
  self.customTopView.layer.shadowPath = shadowPath.CGPath;
  
  [self getDataForTableView]; //populates table with data from Parse
  
  [self.refreshButton addTarget:self action:@selector(getDataForTableView) forControlEvents:UIControlEventTouchUpInside];
}

- (void) getDataForTableView {
  [AppUtils fetchData:^(NSArray *objects) {
    dispatch_async(dispatch_get_main_queue(), ^{
      self.activitiesArray = objects;
      [self.tableView reloadData];
      self.topViewStatLabel.text = [AppUtils recalculateTotalForMonth:objects];
    });
  }];
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
  NSDateFormatter *dformat = [[NSDateFormatter alloc]init];
  [dformat setDateFormat:@"hh:mm a"];
  NSString *startTimeString = [dformat stringFromDate:startDate];
  cell.startTimeLabel.text = startTimeString;
  
  //display end time in hh:mm format
  NSDate *endTime = trip.createdAt;
  NSString *endTimeString = [dformat stringFromDate:endTime];
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
