//
//  ViewController.m
//  Otto
//
//  Created by Vania Kurniawati on 5/22/15.
//  Copyright (c) 2015 vivavania. All rights reserved.
//

#import "ViewController.h"
#import "ActivityCell.h"
#import "AppUtils.h"
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>

@interface ViewController () <UITableViewDataSource, UITableViewDelegate, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *profilePicture;
@property (strong, nonatomic) UIImage *userProfilePicture;
@property (weak, nonatomic) IBOutlet UIButton *addActivityButton;
@property (weak, nonatomic) IBOutlet UITextField *activityNameTextField;

@property (strong, nonatomic) NSArray *dataArray;

@property (strong, nonatomic) PFLogInViewController *logInViewController;

@end

@implementation ViewController


-(void)viewDidAppear:(BOOL)animated {
  
  [super viewDidAppear:true];
  
  if (![PFUser currentUser])
  {
    PFSignUpViewController *signUpViewController = [[PFSignUpViewController alloc] init];
    signUpViewController.delegate = self;
    signUpViewController.fields = PFSignUpFieldsDefault;
    
    self.logInViewController = [[PFLogInViewController alloc] init];
    self.logInViewController.fields = (PFLogInFieldsUsernameAndPassword | PFLogInFieldsLogInButton | PFLogInFieldsSignUpButton | PFLogInFieldsPasswordForgotten | PFLogInFieldsFacebook);
    self.logInViewController.delegate = self;
    self.logInViewController.facebookPermissions = @[@"public_profile"];
    
    self.logInViewController.signUpController = signUpViewController;
    
    [self presentViewController:self.logInViewController animated:YES completion:nil];
  }
  
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  //  UIImageView *titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"busybeetitleview.png"]];
  //  self.navigationItem.titleView = titleView;
  
  UINib *nib = [UINib nibWithNibName:@"ActivityCell" bundle:nil];
  [self.tableView registerNib:nib forCellReuseIdentifier:@"ACTIVITY_CELL"];
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  self.tableView.rowHeight = 55;
  
  if ([PFUser currentUser]) {
    [self getData];
    [self fetchUserData];
  }
  
  if (!self.userProfilePicture) {
    [self.profilePicture setBackgroundImage:[UIImage imageNamed:@"cameraIcon.png"] forState:UIControlStateNormal];
  }
  else {
    [self.profilePicture setBackgroundImage:self.userProfilePicture forState:UIControlStateNormal];
  }
  self.profilePicture.layer.cornerRadius = self.profilePicture.frame.size.width/2;
  self.profilePicture.layer.borderColor = [[UIColor whiteColor] CGColor];
  self.profilePicture.layer.borderWidth = 2.0;
  self.profilePicture.layer.masksToBounds = true;
  [self.profilePicture addTarget:self action:@selector(pickImage:) forControlEvents:UIControlEventTouchUpInside];
  
  self.addActivityButton.layer.cornerRadius = 5;
  self.addActivityButton.clipsToBounds = true;
  [self.addActivityButton addTarget:self action:@selector(addButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
  
}

- (void)getData {
  [AppUtils fetchData:^(NSArray *objects) {
    dispatch_async(dispatch_get_main_queue(), ^{
      self.dataArray = objects;
      [self.tableView reloadData];
    });
  }];
}

- (void)pickImage:(UIButton *)sender {
  
  UIImagePickerController *picker = [[UIImagePickerController alloc] init];
  picker.delegate = self;
  picker.allowsEditing = YES;
  picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
  
  [self presentViewController:picker animated:YES completion:nil];
  
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
  
  UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
  self.userProfilePicture = chosenImage;
  
  //resize picture
  CGSize newSize = CGSizeMake(200.0f, 200.0f);
  UIGraphicsBeginImageContext(newSize);
  [chosenImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
  UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  
  //turn it into jpeg representation
  NSData *imageData = UIImageJPEGRepresentation(newImage, 0.85);
  [self uploadUserImage:imageData];
  [self.profilePicture setBackgroundImage:chosenImage forState:UIControlStateNormal];
  
  [picker dismissViewControllerAnimated:YES completion:NULL];
  
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
  
  [picker dismissViewControllerAnimated:YES completion:NULL];
  
}

- (void)uploadUserImage:(NSData *)imageData {
  
  PFUser *user = [PFUser currentUser];
  user[@"image"] = imageData;
  [user saveInBackground];
  
}

#pragma mark - parse commands
- (void)fetchUserData {
  
  PFUser *user = [PFUser currentUser];
  NSData *profilePictureData = user[@"image"];
  self.userProfilePicture = [UIImage imageWithData:profilePictureData];
  //self.userName = user[@"firstName"];
  [self.profilePicture setBackgroundImage:self.userProfilePicture forState:UIControlStateNormal];
  
}

- (void)addButtonClicked:(id)sender {
  
  NSString *activityName = self.activityNameTextField.text;
  PFObject *newActivity = [PFObject objectWithClassName:@"Activity"];
  newActivity[@"name"] = activityName;
  newActivity[@"totalTime"] = @0;
  PFUser *user = [PFUser currentUser];
  PFRelation *relation = [newActivity relationForKey:@"owner"];
  [relation addObject:user];
  [newActivity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
    if (succeeded) {
      [self createNewAlert:@"New activity added" withMessage:@"Your activity has been added!"];
      [self getData];
      
    } else {
      // There was a problem, check error.description
    }
  }];
}


#pragma mark - UITableView Data Source methods

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  ActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ACTIVITY_CELL" forIndexPath:indexPath];
  PFObject *object = self.dataArray[indexPath.row];
  cell.activityLabel.text = object[@"name"];
  int duration = [object[@"totalTime"] intValue];
  cell.totalTimeLabel.text = [AppUtils formatTimeToString:duration];
  return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.dataArray.count;
}

#pragma mark - PFSignUpViewControllerDelegate
- (BOOL)signUpViewController:(PFSignUpViewController *)signUpController shouldBeginSignUp:(NSDictionary *)info {
  BOOL informationComplete = YES;
  
  // loop through all of the submitted data
  for (id key in info) {
    NSString *field = [info objectForKey:key];
    if (!field || field.length == 0) { // check completion
      informationComplete = NO;
      break;
    }
  }
  
  // Display an alert if a field wasn't completed
  if (!informationComplete) {
    [[[UIAlertView alloc] initWithTitle:@"Missing Information"
                                message:@"Make sure you fill out all the fields"
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
  }
  return informationComplete;
}

- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
  [self dismissViewControllerAnimated:true completion:nil];
}

- (void)signUpViewController:(PFSignUpViewController *)signUpController didFailToSignUpWithError:(NSError *)error {
  //NSLog(@"Failed to sign up...");
}

- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController {
  //NSLog(@"User dismissed the signUpViewController");
}

#pragma mark - PFLoginViewControllerDelegate
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
  [self getData];
  [self dismissViewControllerAnimated:true completion:nil];
}

- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error {
  //NSLog(@"Error logging in: %@", error);
}

- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
  [self dismissViewControllerAnimated:true completion:nil];
}

#pragma mark - new alert 
//basic function to create new alert with OK button
- (void)createNewAlert:(NSString *)title withMessage:(NSString *)message {
  UIAlertController *alertView = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
  UIAlertAction *okActionButton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    [self dismissViewControllerAnimated:true completion:nil];
  }];
  [alertView addAction:okActionButton];
  [self presentViewController:alertView animated:true completion:nil];
}
@end
