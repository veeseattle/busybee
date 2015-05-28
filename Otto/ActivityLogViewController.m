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

@interface ActivityLogViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *activitiesArray;
@property (strong, nonatomic) NSManagedObjectContext *context;
@end

@implementation ActivityLogViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  self.tableView.allowsMultipleSelectionDuringEditing = NO;
  
  UINib *nib = [UINib nibWithNibName:@"LogTableViewCell" bundle:nil];
  [self.tableView registerNib:nib forCellReuseIdentifier:@"LOG_CELL"];
  self.tableView.rowHeight = 130;
  
  NSDictionary *trip1 = @{ @"firstLine" : @"May 17, 2015", @"secondLine" : @"12:35pm", @"thirdLine" : @"1:10pm"};
  NSDictionary *trip2 = @{ @"firstLine" : @"May 18, 2015", @"secondLine" : @"2:35pm", @"thirdLine" : @"2:46pm"};
  NSDictionary *trip3 = @{ @"firstLine" : @"May 18, 2015", @"secondLine" : @"7:12pm", @"thirdLine" : @"8:10pm"};
  self.activitiesArray = @[trip1, trip2, trip3];
  
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
  cell.removeButton.tag = indexPath.row;
  [cell.removeButton addTarget:self action:@selector(deleteTrip:) forControlEvents:UIControlEventTouchUpInside];
  return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.activitiesArray.count;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
  return YES;
}


-(void)deleteTrip:(id)sender
{
  UIButton *btn =(UIButton*)sender;
  [self.activitiesArray removeObjectAtIndex:btn.tag];
  [self.tableView reloadData];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    [self.activitiesArray removeObjectAtIndex:indexPath.row];
    [self.tableView reloadData];
  }
}


@end
