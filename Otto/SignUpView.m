//
//  SignUpView.m
//  busybee
//
//  Created by Vania Kurniawati on 5/7/15.
//  Copyright (c) 2015 Vania Kurniawati. All rights reserved.
//

#import "SignUpView.h"

@interface SignUpView ()

@end

@implementation SignUpView


- (void)viewDidLoad
{
  [super viewDidLoad];
  
  [self.signUpView setBackgroundColor:[UIColor colorWithRed:87/255.0 green:205/255.0 blue:192/255.0 alpha:1.0]];

  //just to cover up Parse logo
  [self.signUpView setLogo:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]]];
  
  UIImageView *fieldsBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"beelogo.jpeg"]];
  fieldsBackground.contentMode = UIViewContentModeScaleAspectFill;
  fieldsBackground.frame = [UIScreen mainScreen].bounds;
  fieldsBackground.alpha = 0.8;
  [self.signUpView insertSubview:fieldsBackground atIndex:0];
  
}


- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];
  
  // Move all fields down on smaller screen sizes
  float yOffset = [UIScreen mainScreen].bounds.size.height <= 480.0f ? 30.0f : 0.0f;
  
  CGRect fieldFrame = self.signUpView.usernameField.frame;
  
  [self.signUpView.logo setFrame:CGRectMake(66.5f, 70.0f, 250.0f, 80.5f)];
  
  [self.signUpView.usernameField setFrame:CGRectMake(fieldFrame.origin.x + 5.0f,
                                                     fieldFrame.origin.y + yOffset,
                                                     fieldFrame.size.width - 10.0f,
                                                     fieldFrame.size.height)];
  yOffset += fieldFrame.size.height;
  
  [self.signUpView.passwordField setFrame:CGRectMake(fieldFrame.origin.x + 5.0f,
                                                     fieldFrame.origin.y + yOffset,
                                                     fieldFrame.size.width - 10.0f,
                                                     fieldFrame.size.height)];
  yOffset += fieldFrame.size.height;
  
  [self.signUpView.emailField setFrame:CGRectMake(fieldFrame.origin.x + 5.0f,
                                                  fieldFrame.origin.y + yOffset,
                                                  fieldFrame.size.width - 10.0f,
                                                  fieldFrame.size.height)];
  yOffset += fieldFrame.size.height;
  
  [self.signUpView.signUpButton setFrame:CGRectMake(fieldFrame.origin.x,
                                                       fieldFrame.origin.y + yOffset,
                                                       fieldFrame.size.width,
                                                       fieldFrame.size.height)];  

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
@end
