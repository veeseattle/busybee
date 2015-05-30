//
//  ActivityLogViewController.m
//  ottoinsurance
//
//  Created by Vania Kurniawati on 5/26/15.
//  Copyright (c) 2015 vivavania. All rights reserved.
//

#import "ActivityLogViewController.h"
#import "LogTableViewCell.h"
#import "DataService.h"
#import <CoreData/CoreData.h>
#import "CustomNavigationBar.h"

@interface ActivityLogViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *activitiesArray;
@property (strong, nonatomic) NSManagedObjectContext *context;

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
  
  NSDictionary *trip1 = @{ @"firstLine" : @"May 17, 2015", @"secondLine" : @"12:35pm", @"thirdLine" : @"1:10pm"};
  NSDictionary *trip2 = @{ @"firstLine" : @"May 18, 2015", @"secondLine" : @"2:35pm", @"thirdLine" : @"2:46pm"};
  NSDictionary *trip3 = @{ @"firstLine" : @"May 18, 2015", @"secondLine" : @"7:12pm", @"thirdLine" : @"8:10pm"};
  self.activitiesArray = [[NSMutableArray alloc] initWithArray:@[trip1, trip2, trip3]];
  
  [self fetchTrips];
  
}


- (void)fetchTrips {
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Trip"];
  NSError *fetchErr;
  NSArray *activityResults = [self.context executeFetchRequest:fetchRequest error:&fetchErr];
  
  NSLog(@"There are %lu trips", (unsigned long)activityResults.count);
  
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  LogTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LOG_CELL" forIndexPath:indexPath];
  NSDictionary *trip = self.activitiesArray[indexPath.row];
  cell.tripDateLabel.text = trip[@"firstLine"];
  cell.tripDurationLabel.text = @"XX min";
  cell.startTimeLabel.text = trip[@"secondLine"];
  cell.endTimeLabel.text = trip[@"thirdLine"];
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
    [self.activitiesArray removeObjectAtIndex:indexPath.row];
    [self.tableView reloadData];
  }
}


@end
