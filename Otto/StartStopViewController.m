//
//  StartStopViewController.m
//  Otto
//
//  Created by Vania Kurniawati on 5/23/15.
//  Copyright (c) 2015 vivavania. All rights reserved.
//

#import "StartStopViewController.h"
#import "AppUtils.h"
#import <Parse/Parse.h>

@interface StartStopViewController() <UITabBarDelegate>

@property (assign) NSTimeInterval startTime;
@property (assign) NSDate *start;
@property (assign) BOOL isRunning;
@property (strong,nonatomic) UINavigationBar *navBar;

@property (weak, nonatomic) IBOutlet UIView *customTopView;
@property (weak, nonatomic) IBOutlet UILabel *topViewStatLabel;
@property (weak, nonatomic) IBOutlet UIButton *refreshButton;
@property (weak, nonatomic) IBOutlet UIButton *stopwatchButton;
@property (weak, nonatomic) IBOutlet UILabel *activityName;

@end

@implementation StartStopViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.stopwatchButton.layer.cornerRadius = 100;
  self.stopwatchButton.layer.borderColor = [[UIColor blackColor] CGColor];
  [self.stopwatchButton setBackgroundColor:[UIColor colorWithRed:26/255.0 green:195/255.0 blue:71/255.0 alpha:1.0]];
  self.stopwatchButton.layer.borderWidth = 3;
  [self.stopwatchButton addTarget:self action:@selector(stopwatchButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
  
  [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"AppleSDGothicNeo-Light" size:14.0f], NSFontAttributeName, nil] forState:UIControlStateNormal];
  
  [self getDataForTopView];
  NSString *name = self.activity[@"name"];
  self.activityName.text = [NSString stringWithFormat:@"Now tracking:  %@", name];
  [self.refreshButton addTarget:self action:@selector(getDataForTopView) forControlEvents:UIControlEventTouchUpInside];
}

- (void) getDataForTopView {
  [AppUtils fetchData:^(NSArray *objects) {
    dispatch_async(dispatch_get_main_queue(), ^{
      self.topViewStatLabel.text = [AppUtils recalculateTotalForMonth:objects];
    });
  }];
}


#pragma mark - stopwatch functions

- (void)stopwatchButtonClicked:(id)sender {
  
  //if stopwatch is not running (i.e. start button is pressed), then start the stopwatch
  if (!self.isRunning) {
    self.isRunning = true;
    self.start = [NSDate date];
    self.startTime = [NSDate timeIntervalSinceReferenceDate];
    [sender setTitle:@"STOP" forState:UIControlStateNormal];
    [sender setBackgroundColor:[UIColor redColor]];
    [self addTime];
  }
  //if stopwatch is running (i.e. stop button is pressed), then stop the stopwatch
  else {
    self.isRunning = false;
    [sender setTitle:@"START" forState:UIControlStateNormal];
    [sender setBackgroundColor:[UIColor colorWithRed:26/255.0 green:195/255.0 blue:71/255.0 alpha:1.0]];
    int duration = [NSDate timeIntervalSinceReferenceDate] - self.startTime;
    NSDate *startDate = [NSDate dateWithTimeIntervalSinceReferenceDate:self.startTime];
    self.lapsedTimeLabel.text = @"0:00:00";
    //save new trip to Parse
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
    
    self.lapsedTimeLabel.text = [NSString stringWithFormat:@"Current activity: %u:%u:%02u", hours, mins, secs];
    
    [self performSelector:@selector(addTime) withObject:self afterDelay:0.1];
  }
}

#pragma mark - Parse Function

- (void)addNewActivity:(NSDate*)startTime withDuration:(int)tripDuration {
  
  PFObject *trip = [PFObject objectWithClassName:@"Trip"];
  trip[@"startTime"] = startTime;
  trip[@"duration"] = [NSNumber numberWithInt:tripDuration];
  [trip saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
    if (succeeded) {
      NSLog(@"success!");
      [self getDataForTopView];
    } else {
      NSLog(@"fail");
    }
  }];
}

@end
