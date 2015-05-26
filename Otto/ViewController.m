//
//  ViewController.m
//  Otto
//
//  Created by Vania Kurniawati on 5/22/15.
//  Copyright (c) 2015 vivavania. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *ottobiglabel;

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.ottobiglabel.font = [UIFont fontWithName:@"Avenir-Black" size:35.0];
  
  
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
