//
//  ViewController.m
//  busybee
//
//  Created by Vania Kurniawati on 5/22/15.
//  Copyright (c) 2015 vivavania. All rights reserved.
//

#import "ViewController.h"
#import "ActivityCell.h"
#import "AppUtils.h"
#import "StartStopViewController.h"
#import "LogInViewController.h"
#import "SignUpViewController.h"
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>

@interface ViewController () <UITableViewDataSource, UITableViewDelegate, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *profilePicture;
@property (strong, nonatomic) UIImage *userProfilePicture;
@property (weak, nonatomic) IBOutlet UIButton *addActivityButton;
@property (weak, nonatomic) IBOutlet UITextField *activityNameTextField;
@property (strong, nonatomic) NSString *myName;
@property (weak, nonatomic) IBOutlet UILabel *greetingLabel;
@property (strong, nonatomic) NSArray *dataArray;
@property (strong, nonatomic) LogInViewController *logInViewController;

@end

@implementation ViewController

-(void)viewDidAppear:(BOOL)animated {
  
  [super viewDidAppear:true];
  
  if (![PFUser currentUser])
  {
    SignUpViewController *signUpViewController = [[SignUpViewController alloc] init];
    signUpViewController.delegate = self;
    signUpViewController.fields = PFSignUpFieldsDefault;
    
    self.logInViewController = [[LogInViewController alloc] init];
    self.logInViewController.fields = (PFLogInFieldsUsernameAndPassword | PFLogInFieldsLogInButton | PFLogInFieldsSignUpButton | PFLogInFieldsPasswordForgotten | PFLogInFieldsFacebook);
    self.logInViewController.delegate = self;
    self.logInViewController.facebookPermissions = @[@"public_profile"];
    self.logInViewController.signUpController = signUpViewController;
    
    [self presentViewController:self.logInViewController animated:YES completion:nil];
  }
  
  if ([PFUser currentUser]) {
    [self refreshDataInTable];
  }
  
}

- (void)viewDidLoad {
  
  [super viewDidLoad];
  
  [self getUserData];
  
  UINib *nib = [UINib nibWithNibName:@"ActivityCell" bundle:nil];
  [self.tableView registerNib:nib forCellReuseIdentifier:@"ACTIVITY_CELL"];
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  self.tableView.rowHeight = 50;
  
  if (!self.userProfilePicture) {
    [self.profilePicture setBackgroundImage:[UIImage imageNamed:@"camera.png"] forState:UIControlStateNormal];
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

#pragma mark - UIImagePickerControllerDelegate
- (void)pickImage:(UIButton *)sender {
  
  UIImagePickerController *picker = [[UIImagePickerController alloc] init];
  picker.delegate = self;
  picker.allowsEditing = YES;
  picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
  [self presentViewController:picker animated:YES completion:nil];
  
}

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

#pragma mark - segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(NSIndexPath *)sender {
  
  if ([segue.identifier isEqualToString:@"SHOW_DETAIL"]) {
    StartStopViewController *destinationVC = (StartStopViewController *)segue.destinationViewController;
    PFObject *object = self.dataArray[sender.row];
    destinationVC.activity = object;
  }
  
}

#pragma mark - parse commands
- (void)getUserData {
  
  if ([PFUser currentUser]) {
    [self refreshDataInTable];
    BOOL isLinkedToFacebook = [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]];
    if (isLinkedToFacebook) {
      [self fetchUserDataInFacebook];
    }
    else {
      [self fetchUserDataInParse];
    }
  }
}

- (void)fetchUserDataInParse {
  
  PFUser *user = [PFUser currentUser];
  PFQuery *query = [PFUser query];
  [query getObjectInBackgroundWithId:user.objectId block:^(PFObject *user, NSError *error){
  if (!error) {
  NSData *profilePictureData = user[@"image"];
  self.userProfilePicture = [UIImage imageWithData:profilePictureData];
  self.greetingLabel.text = [NSString stringWithFormat:@"Hi, %@!", user[@"firstName"]];
  self.greetingLabel.font = [UIFont fontWithName:@"Georgia" size:24.0];
  [self.profilePicture setBackgroundImage:self.userProfilePicture forState:UIControlStateNormal];
    }
    else {
    
    }
  }];
}

- (void)fetchUserDataInFacebook {
  
  FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil];
  [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
    if (!error) {
      // result is a dictionary with the user's Facebook data
      NSDictionary *userData = (NSDictionary *)result;
      NSString *facebookID = userData[@"id"]; //used for picture
      self.greetingLabel.text = [NSString stringWithFormat:@"Hi, %@!", userData[@"first_name"]];
      self.greetingLabel.font = [UIFont fontWithName:@"Georgia" size:24.0];
      NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];
      NSURLRequest *urlRequest = [NSURLRequest requestWithURL:pictureURL];
      [NSURLConnection sendAsynchronousRequest:urlRequest
                                         queue:[NSOperationQueue mainQueue]
                             completionHandler:
       ^(NSURLResponse *response, NSData *data, NSError *connectionError) {
         if (connectionError == nil && data != nil) {
           UIImage *userPhoto = [UIImage imageWithData:data];
           [self.profilePicture setBackgroundImage:userPhoto forState:UIControlStateNormal];
         }
       }];
    }
  }];
  
}

- (void)refreshDataInTable {
  [AppUtils fetchData:@"Activity" withBlock:^(NSArray *objects) {
    dispatch_async(dispatch_get_main_queue(), ^{
      self.dataArray = objects;
      [self.tableView reloadData];
    });
  }];
  
}

- (void)uploadUserImage:(NSData *)imageData {
  
  PFUser *user = [PFUser currentUser];
  user[@"image"] = imageData;
  [user saveInBackground];
  
}

- (void)deleteButtonPushed:(PFObject *)activity {
  UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"Confirm Delete?" message:@"Are you sure you want to delete this activity? This action cannot be undone." preferredStyle:UIAlertControllerStyleAlert];
  UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:@"No, cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    [self dismissViewControllerAnimated:true completion:nil];
  }];
  UIAlertAction *deleteButton = [UIAlertAction actionWithTitle:@"Yes, delete" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
    [self deleteActivity:activity];
  }];
  
  [alertView addAction:cancelButton];
  [alertView addAction:deleteButton];
  [self presentViewController:alertView animated:true completion:nil];
  
}

- (void)deleteActivity:(PFObject *)activity {
  
  //delete sessions within this activity
  PFQuery *sessionQuery = [PFQuery queryWithClassName:@"Session"];
  [sessionQuery whereKey:@"activityPointer" equalTo:activity];
  [sessionQuery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
    if (!error) {
      for (PFObject *item in array) {
        [item deleteInBackground];
      }
      NSLog(@"deleted %lu", (unsigned long)array.count);
    }
    else {
      NSLog(@"could not retrieve sessions");
    }
  }];
  
  //then delete the activity
  PFQuery *activityQuery = [PFQuery queryWithClassName:@"Activity"];
  [activityQuery getObjectInBackgroundWithId:activity.objectId block:^(PFObject *activity, NSError *error){
    [activity deleteInBackground];
    dispatch_async(dispatch_get_main_queue(), ^{
      [self refreshDataInTable];
    });
  }];
  
}

- (void)addButtonClicked:(id)sender {
  
  NSString *activityName = self.activityNameTextField.text;
  [self.activityNameTextField resignFirstResponder];
  self.activityNameTextField.text = nil;
  PFObject *newActivity = [PFObject objectWithClassName:@"Activity"];
  newActivity[@"name"] = activityName;
  newActivity[@"totalTime"] = @0;
  PFUser *user = [PFUser currentUser];
  PFRelation *relation = [newActivity relationForKey:@"owner"];
  [relation addObject:user];
  [newActivity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
    if (succeeded) {
      [self createNewAlert:@"New activity added" withMessage:@"Your activity has been added!"];
      [self refreshDataInTable];
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

#pragma mark - UITableView Delegate methods
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [self performSegueWithIdentifier:@"SHOW_DETAIL" sender:indexPath];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
  
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    PFObject *activity = self.dataArray[indexPath.row];
    [self deleteButtonPushed:activity];
  }
  
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
  [self getUserData];
  [self dismissViewControllerAnimated:true completion:nil];
}

- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error {
  [self createNewAlert:@"Error Logging in" withMessage:@"There was an error logging in, please try again later."];
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
