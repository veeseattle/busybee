//
//  AlertViewController.m
//  ottoinsurance
//
//  Created by Vania Kurniawati on 5/26/15.
//  Copyright (c) 2015 vivavania. All rights reserved.
//

#import "AlertViewController.h"

@interface AlertViewController ()
@property (weak, nonatomic) IBOutlet UIButton *lowBatteryButton;
@property (weak, nonatomic) IBOutlet UIButton *policyExpiredButton;
@property (weak, nonatomic) IBOutlet UIButton *declinedTripButton;
@property (weak, nonatomic) IBOutlet UIButton *declinedTripButton2;

@end

@implementation AlertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  [self.lowBatteryButton addTarget:self action:@selector(lowBatteryButtonClicked) forControlEvents:UIControlEventTouchUpInside];
  self.lowBatteryButton.layer.cornerRadius = 5;
  self.lowBatteryButton.layer.borderColor = [[UIColor grayColor] CGColor];
  self.lowBatteryButton.layer.borderWidth = 1;
  
  [self.policyExpiredButton addTarget:self action:@selector(policyExpiredButtonClicked) forControlEvents:UIControlEventTouchUpInside];
  self.policyExpiredButton.layer.cornerRadius = 5;
  self.policyExpiredButton.layer.borderColor = [[UIColor grayColor] CGColor];
  self.policyExpiredButton.layer.borderWidth = 1;
  
  [self.declinedTripButton addTarget:self action:@selector(declinedTripButtonClicked) forControlEvents:UIControlEventTouchUpInside];
  self.declinedTripButton.layer.cornerRadius = 5;
  self.declinedTripButton.layer.borderColor = [[UIColor grayColor] CGColor];
  self.declinedTripButton.layer.borderWidth = 1;
  
  [self.declinedTripButton2 addTarget:self action:@selector(declinedTripButtonClicked) forControlEvents:UIControlEventTouchUpInside];
  self.declinedTripButton2.layer.cornerRadius = 5;
  self.declinedTripButton2.layer.borderColor = [[UIColor grayColor] CGColor];
  self.declinedTripButton2.layer.borderWidth = 1;
  
  
  
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
  NSLog(@"didSelectItem: %ld", (long)item.tag);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)lowBatteryButtonClicked {
  [self createAlert:@"Low Battery Warning" withMessage:@"Your battery is below 15%. Your insurance will remain on until you charge your device over 25%."];
  
}

- (void)policyExpiredButtonClicked {
  [self createTwoButtonAlert:@"Policy Expiration" withMessage:@"Your Insurance will expire in 5 days" andFirstButton:@"Renew" andSecondButton:@"Cancel"];
}

- (void)declinedTripButtonClicked {
  UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"otto Drive Monitoring"   message:@"We have detected you are moving. If you are not driving your car, select STOP so you don't activate insurance fees."  preferredStyle:UIAlertControllerStyleAlert];
  UIAlertAction *leftActionButton = [UIAlertAction actionWithTitle:@"Stop" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    [self dismissViewControllerAnimated:true completion:nil];
    [self createTwoButtonAlert:@"otto Drive Monitoring" withMessage:@"Are you sure you want to stop? Go to otto to activate insurance." andFirstButton:@"Yes" andSecondButton:@"Start otto"];
  }];
  UIAlertAction *okActionButton = [UIAlertAction actionWithTitle:@"Ignore" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    [self dismissViewControllerAnimated:true completion:nil];
  }];
  [alert addAction:leftActionButton];
  [alert addAction:okActionButton];
  [self presentViewController:alert animated:true completion:nil];

}


//basic function to create new alert with OK button
-(void)createAlert:(NSString *)title withMessage:(NSString *)message {
  UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
  UIAlertAction *okActionButton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    [self dismissViewControllerAnimated:true completion:nil];
  }];
  
  [alert addAction:okActionButton];
  [self presentViewController:alert animated:true completion:nil];
}

- (void)createTwoButtonAlert:(NSString *)title withMessage:(NSString *)message andFirstButton:(NSString *)firstTitle andSecondButton:(NSString *)secondTitle {
  UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
  UIAlertAction *leftActionButton = [UIAlertAction actionWithTitle:firstTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    [self dismissViewControllerAnimated:true completion:nil];
  }];
  UIAlertAction *okActionButton = [UIAlertAction actionWithTitle:secondTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    [self dismissViewControllerAnimated:true completion:nil];
  }];
  [alert addAction:leftActionButton];
  [alert addAction:okActionButton];
  [self presentViewController:alert animated:true completion:nil];
  
}

@end
