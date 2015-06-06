//
//  LogInViewController.m
//  busybee
//
//  Created by Vania Kurniawati on 6/5/15.
//  Copyright (c) 2015 vivavania. All rights reserved.
//

#import "LogInViewController.h"

@interface LogInViewController ()

@end

@implementation LogInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
  [self.logInView setBackgroundColor:[UIColor colorWithRed:87/255.0 green:205/255.0 blue:192/255.0 alpha:1.0]];
  
  [self.logInView setLogo:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"busylogo.png"]]];
  
    UIImageView *fieldsBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"busy bee.png"]];
    fieldsBackground.contentMode = UIViewContentModeTop;
    fieldsBackground.frame = [UIScreen mainScreen].bounds;
    fieldsBackground.alpha = 0.8;
    [self.logInView insertSubview:fieldsBackground atIndex:0];
  
}

- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];
  
  float yOffset = 0;
  
  CGRect fieldFrame = self.logInView.usernameField.frame;
  
  [self.logInView.logInButton setFrame:CGRectMake(35.0f, 385.0f, 250.0f, 40.0f)];
  
  [self.logInView.usernameField setFrame:CGRectMake(fieldFrame.origin.x + 5.0f,
                                                    fieldFrame.origin.y + yOffset,
                                                    fieldFrame.size.width - 10.0f,
                                                    fieldFrame.size.height)];
  yOffset += fieldFrame.size.height;
  
  [self.logInView.passwordField setFrame:CGRectMake(fieldFrame.origin.x + 5.0f,
                                                    fieldFrame.origin.y + yOffset,
                                                    fieldFrame.size.width - 10.0f,
                                                    fieldFrame.size.height)];
  yOffset += fieldFrame.size.height;
  
  [self.logInView.passwordForgottenButton setFrame:CGRectMake(fieldFrame.origin.x + 5.0f,
                                                              fieldFrame.origin.y + yOffset,
                                                              fieldFrame.size.width - 10.0f,
                                                              fieldFrame.size.height)];
  yOffset += fieldFrame.size.height;
  
  [self.logInView.logInButton setFrame:CGRectMake(fieldFrame.origin.x,
                                                  fieldFrame.origin.y + yOffset,
                                                  fieldFrame.size.width,
                                                  fieldFrame.size.height)];
  
}

@end
