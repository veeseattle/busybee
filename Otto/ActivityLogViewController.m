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
//@property (strong, nonatomic) CustomNavigationBar *navBar;

@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
//@property (strong, nonatomic) UINavigationBar *navBar;

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
  
  NSDictionary *trip1 = @{ @"firstLine" : @"May 17, 2015", @"secondLine" : @"12:35pm", @"thirdLine" : @"1:10pm"};
  NSDictionary *trip2 = @{ @"firstLine" : @"May 18, 2015", @"secondLine" : @"2:35pm", @"thirdLine" : @"2:46pm"};
  NSDictionary *trip3 = @{ @"firstLine" : @"May 18, 2015", @"secondLine" : @"7:12pm", @"thirdLine" : @"8:10pm"};
  self.activitiesArray = [[NSMutableArray alloc] initWithArray:@[trip1, trip2, trip3]];
  
  [self fetchTrips];
  
  self.navBar = [[UINavigationBar alloc] init];
  [self.view addSubview:self.navBar];
  
  [self.navBar setTintColor:[UIColor colorWithRed:81/255.0 green:191/255.0 blue:243/255.0 alpha:1.0]];
  
  //  CGFloat navBarWidth = self.view.frame.size.width - 60.0;
  UIImageView *logo = [[UIImageView alloc] init];
  logo.image = [UIImage imageNamed:@"ottoicon.png"];
  //  [self.navBar addSubview:logo];
  
  self.navigationItem.titleView = logo;
  
  
  
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
