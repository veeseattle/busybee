//
//  StartStopViewController.m
//  Otto
//
//  Created by Vania Kurniawati on 5/23/15.
//  Copyright (c) 2015 vivavania. All rights reserved.
//

#import "StartStopViewController.h"

@interface StartStopViewController()

@property (assign) NSTimeInterval startTime;
@property (assign) int seconds;
@property (assign) BOOL isRunning;
@property (assign) NSTimeInterval elapsed;
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

}

- (void)stopwatchButtonClicked:(id)sender {
  
  if (!self.isRunning) {
    self.isRunning = true;
    self.startTime = [NSDate timeIntervalSinceReferenceDate];
    [sender setTitle:@"STOP" forState:UIControlStateNormal];
    [sender setBackgroundColor:[UIColor redColor]];
    [self addTime];
  }
  
  else {
    self.isRunning = false;
    [sender setTitle:@"START" forState:UIControlStateNormal];
    [sender setBackgroundColor:[UIColor colorWithRed:26/255.0 green:195/255.0 blue:71/255.0 alpha:1.0]];
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
