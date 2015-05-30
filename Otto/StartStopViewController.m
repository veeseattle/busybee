//
//  StartStopViewController.m
//  Otto
//
//  Created by Vania Kurniawati on 5/23/15.
//  Copyright (c) 2015 vivavania. All rights reserved.
//

#import "StartStopViewController.h"
#import "Trip.h"
#import "CustomNavigationBar.h"
#import <Parse/Parse.h>

@interface StartStopViewController() <UITabBarDelegate>

@property (assign) NSTimeInterval startTime;
@property (assign) NSDate *start;
@property (assign) int seconds;
@property (assign) BOOL isRunning;
@property (assign) NSTimeInterval elapsed;
@property (strong,nonatomic) UINavigationBar *navBar;

@property (weak, nonatomic) IBOutlet UIButton *stopwatchButton;

@end

@implementation StartStopViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.seconds = 0;
  
  self.stopwatchButton.layer.cornerRadius = 100;
  self.stopwatchButton.layer.borderColor = [[UIColor blackColor] CGColor];
  [self.stopwatchButton setBackgroundColor:[UIColor colorWithRed:26/255.0 green:195/255.0 blue:71/255.0 alpha:1.0]];
  self.stopwatchButton.layer.borderWidth = 3;
  [self.stopwatchButton addTarget:self action:@selector(stopwatchButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
  
  self.navBar = [[UINavigationBar alloc] init];
  [self.view addSubview:self.navBar];
  UIImageView *titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ottotitleview.png"]];
  self.navigationItem.titleView = titleView;
  
  [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"AppleSDGothicNeo-Light" size:14.0f], NSFontAttributeName, nil] forState:UIControlStateNormal];
  
}


-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
  
  switch (item.tag) {
    case 0:
      NSLog(@"selected 0");
      break;
    case 1:
      NSLog(@"selected 1");
      break;
    case 2:
      NSLog(@"selected 2");
      break;
    case 3:
      NSLog(@"selected 3");
      break;
    default:
      break;
  }
  
  
}
- (void)addNewActivity:(NSDate*)startTime withDuration:(int)tripDuration {
  
  PFObject *trip = [PFObject objectWithClassName:@"Trip"];
  trip[@"startTime"] = startTime;
  trip[@"duration"] = [NSNumber numberWithInt:tripDuration];
  [trip saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
    if (succeeded) {
      NSLog(@"success!");
    } else {
      NSLog(@"fail");
    }
  }];
}


- (void)stopwatchButtonClicked:(id)sender {
  
  if (!self.isRunning) {
    self.isRunning = true;
    self.start = [NSDate date];
    self.startTime = [NSDate timeIntervalSinceReferenceDate];
    [sender setTitle:@"STOP" forState:UIControlStateNormal];
    [sender setBackgroundColor:[UIColor redColor]];
    [self addTime];
  }
  
  else {
    self.isRunning = false;
    [sender setTitle:@"START" forState:UIControlStateNormal];
    [sender setBackgroundColor:[UIColor colorWithRed:26/255.0 green:195/255.0 blue:71/255.0 alpha:1.0]];
    
    int duration = [NSDate timeIntervalSinceReferenceDate] - self.startTime;
    
    NSDate *startDate = [NSDate dateWithTimeIntervalSinceReferenceDate:self.startTime];
    
    [self addNewActivity:startDate withDuration:duration];
  }
}

- (void)addTime {
  
  if (self.isRunning) {
    NSTimeInterval currentTime = [NSDate timeIntervalSinceReferenceDate];
    NSTimeInterval elapsed = currentTime - self.startTime;
    
    int hours = (int) (elapsed / 3600);
    elapsed -= hours * 3600;
    int mins = (int) (elapsed / 60);
    elapsed -= mins * 60;
    int secs = (int) elapsed;
    
    self.lapsedTimeLabel.text = [NSString stringWithFormat:@"%u:%u:%02u", hours, mins, secs];
    
    [self performSelector:@selector(addTime) withObject:self afterDelay:0.1];
  }
}
@end
