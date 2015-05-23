//
//  MenuTableViewController.h
//  Otto
//
//  Created by Vania Kurniawati on 5/23/15.
//  Copyright (c) 2015 vivavania. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuPressedDelegate.h"

@interface MenuTableViewController : UITableViewController

@property (weak,nonatomic) id<MenuPressedDelegate> delegate;


@end
