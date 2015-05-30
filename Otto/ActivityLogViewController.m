//
//  ActivityLogViewController.m
//  ottoinsurance
//
//  Created by Vania Kurniawati on 5/26/15.
//  Copyright (c) 2015 vivavania. All rights reserved.
//

#import "ActivityLogViewController.h"
#import "LogTableViewCell.h"
#import "CustomNavigationBar.h"
#import <Parse/Parse.h>

@interface ActivityLogViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *activitiesArray;

@property (weak, nonatomic) IBOutlet UIView *customTopView;

@end

@implementation ActivityLogViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  self.tableView.allowsMultipleSelectionDuringEditing = NO;
  
  UINib *nib = [UINib nibWithNibName:@"LogTableViewCell" bundle:nil];
  [self.tableView registerNib:nib forCellReuseIdentifier:@"LOG_CELL"];
  self.tableView.rowHeight = 110;
  self.tableView.userInteractionEnabled = true;
  
  UIImageView *titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ottotitleview.png"]];
  self.navigationItem.titleView = titleView;
  
  UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.customTopView.bounds];
  self.customTopView.layer.masksToBounds = NO;
  self.customTopView.layer.shadowColor = [UIColor blackColor].CGColor;
  self.customTopView.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
  self.customTopView.layer.shadowOpacity = 0.5f;
  self.customTopView.layer.shadowPath = shadowPath.CGPath;
  
  self.activitiesArray = [[NSArray alloc] init];
  
  [self fetchTrips];
  
}


- (void)fetchTrips {
  PFQuery *query = [PFQuery queryWithClassName:@"Trip"];
  [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
    if (!error) {
      self.activitiesArray = objects;
    }
    else {
      NSLog(@"Error: %@ %@", error, [error userInfo]);
    }
    dispatch_async(dispatch_get_main_queue(), ^{
      [self.tableView reloadData];
    });
  }];
 
  
  
}

- (void)deleteTrip:(NSString *)objectId {
  PFQuery *query = [PFQuery queryWithClassName:@"Trip"];
  [query whereKey:@"objectId" equalTo:objectId];
  
  [query getObjectInBackgroundWithId:objectId block:^(PFObject *trip, NSError *error){
    [trip deleteInBackground];
    
    dispatch_async(dispatch_get_main_queue(), ^{
      [self fetchTrips];
    });
  }];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  LogTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LOG_CELL" forIndexPath:indexPath];
  PFObject *trip = self.activitiesArray[indexPath.row];
  
  NSDate *startDate = trip[@"startTime"];
  NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
  [dateFormat setDateFormat:@"MM/dd/yy"];
  NSString *dateString = [dateFormat stringFromDate:startDate];
  
  NSCalendar *calendar = [NSCalendar currentCalendar];
  NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:startDate];
  NSInteger hour = [components hour];
  NSInteger minute = [components minute];
  NSString *startTime = [NSString stringWithFormat:@"%ld:%ld", (long)hour, (long)minute];
  
  cell.tripDateLabel.text = dateString;
  cell.startTimeLabel.text = startTime;
  
  int elapsed = [trip[@"duration"] intValue];
  
  int hours = (int) (elapsed / 3600);
  elapsed -= hours * 3600;
  int mins = (int) (elapsed / 60);
  elapsed -= mins * 60;
  int secs = (int) elapsed;
  
  NSString *durationString = [NSString stringWithFormat:@"%u h %u m %02u s", hours, mins, secs];

  cell.tripDurationLabel.text = durationString;
  
  NSDate *endTime = trip.createdAt;
  
  NSDateComponents *endTimeComponents = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:endTime];
  NSInteger endHour = [endTimeComponents hour];
  NSInteger endMinute = [endTimeComponents minute];
  NSString *endTimeString = [NSString stringWithFormat:@"%ld:%ld", (long)endHour, (long)endMinute];
  
  cell.endTimeLabel.text = endTimeString;
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
