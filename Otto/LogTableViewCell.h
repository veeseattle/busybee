//
//  LogTableViewCell.h
//  ottoinsurance
//
//  Created by Vania Kurniawati on 5/26/15.
//  Copyright (c) 2015 vivavania. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LogTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *sessionDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *sessionDurationLabel;
@property (weak, nonatomic) IBOutlet UIView *view;

@end
