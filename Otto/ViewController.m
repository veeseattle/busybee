//
//  ViewController.m
//  Otto
//
//  Created by Vania Kurniawati on 5/22/15.
//  Copyright (c) 2015 vivavania. All rights reserved.
//

#import "ViewController.h"
#import "CustomNavigationBar.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *ottobiglabel;
@property (weak, nonatomic) IBOutlet UIImageView *ottoImageView;

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  UIImageView *titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ottotitleview.png"]];
  self.navigationItem.titleView = titleView;
  
  self.ottobiglabel.font = [UIFont fontWithName:@"AppleSDGothicNeo-Light" size:35.0];
  
 NSArray *imageNames = @[@"OttoIsRunning.png", @"OttoIsRunning2.png", @"OttoIsRunning3.png", @"OttoIsRunning4.png"];
  
  NSMutableArray *images = [[NSMutableArray alloc] init];
  for (int i = 0; i < imageNames.count; i++) {
    [images addObject:[UIImage imageNamed:[imageNames objectAtIndex:i]]];
  }
  
  self.ottoImageView.animationImages = images;
  self.ottoImageView.animationDuration = 3.0;
  
  [self.ottoImageView startAnimating];
  
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
