//
//  StartStopViewController.h
//  Otto
//
//  Created by Vania Kurniawati on 5/23/15.
//  Copyright (c) 2015 vivavania. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface StartStopViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *lapsedTimeLabel;
@property (strong, nonatomic) PFObject *activity;

@end
