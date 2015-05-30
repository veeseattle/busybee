//
//  MenuTableViewController.m
//  Otto
//
//  Created by Vania Kurniawati on 5/23/15.
//  Copyright (c) 2015 vivavania. All rights reserved.
//

#import "MenuTableViewController.h"
#import "ActivityLogViewController.h"
#import "StartStopViewController.h"
#import "ViewController.h"
#import "AlertViewController.h"

@interface MenuTableViewController () <UINavigationControllerDelegate>
//
//@property (strong, nonatomic) UINavigationController *searchVC;
@property (nonatomic) NSInteger selectedRow;
@property (strong,nonatomic) MenuTableViewController *menuVC;
@property (strong,nonatomic) StartStopViewController *startVC;
@property (strong,nonatomic) ViewController *mainVC;
@property (strong,nonatomic) ActivityLogViewController *activityVC;
@property (strong,nonatomic) AlertViewController *alertVC;


@end

@implementation MenuTableViewController


-(void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [self.tableView setBackgroundColor:[UIColor whiteColor]];
  //[self.tableView setBackgroundColor:[UIColor colorWithRed:81/255.0 green:191/255.0 blue:243/255.0 alpha:1.0]];
}

-(void)viewDidLoad {
  [super viewDidLoad];
  UIImageView *titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ottotitleview.png"]];
  self.navigationItem.titleView = titleView;
  
  UIImageView *logo = [[UIImageView alloc] init];
  logo.image = [UIImage imageNamed:@"ottotitleview.png"];
  self.navigationController.navigationItem.titleView = logo;
  
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [self menuOptionSelected:indexPath.row];
  
}

-(void)menuOptionSelected:(NSInteger)selectedRow {
  NSLog(@"%ld",(long)selectedRow);
  UIViewController *destinationVC;
  switch (selectedRow) {
//    case 0:
//      destinationVC = self.mainVC;
//      break;
    case 1:
      destinationVC = self.startVC;
      break;
    case 2:
      destinationVC = self.activityVC;
      break;
    case 8:
      destinationVC = self.alertVC;
    default:
      break;
  }
  
  [self.navigationController pushViewController:destinationVC animated:YES];
}


-(StartStopViewController *)startVC {
  if (!_startVC) {
    _startVC = [self.storyboard instantiateViewControllerWithIdentifier:@"START_VC"];
  }
  return _startVC;
}

-(ViewController *)mainVC {
  if (!_mainVC) {
    _mainVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SEARCH_VC"];
  }
  return _mainVC;
}

-(ActivityLogViewController *)activityVC {
  if (!_activityVC) {
    _activityVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ACTIVITYLOG_VC"];
  }
  return _activityVC;
}

-(AlertViewController *)alertVC {
  if (!_alertVC) {
    _alertVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ALERT_VC"];
  }
  return _alertVC;
}


@end
