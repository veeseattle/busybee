//
//  ViewController.m
//  Otto
//
//  Created by Vania Kurniawati on 5/22/15.
//  Copyright (c) 2015 vivavania. All rights reserved.
//

#import "ViewController.h"
#import "ActivityCell.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *ottoImageView;

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
//  UIImageView *titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"busybeetitleview.png"]];
//  self.navigationItem.titleView = titleView;
  
  self.ottoImageView.image = [UIImage imageNamed:@"busy bee-logo-white.png"];
  self.ottoImageView.contentMode = UIViewContentModeScaleAspectFill;
  self.ottoImageView.backgroundColor = [UIColor blackColor];
  self.ottoImageView.layer.cornerRadius = 50;
  self.ottoImageView.clipsToBounds = true;
  
  UINib *nib = [UINib nibWithNibName:@"ActivityCell" bundle:nil];
  [self.tableView registerNib:nib forCellReuseIdentifier:@"ACTIVITY_CELL"];
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  self.tableView.rowHeight = 55;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  ActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ACTIVITY_CELL" forIndexPath:indexPath];
  return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 5;
}

@end
