//
//  ActivityCell.h
//  busybee
//
//  Created by Vania Kurniawati on 5/26/15.
//  Copyright (c) 2015 vivavania. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *activityLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;


@end
