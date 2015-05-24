//
//  MenuTableViewController.m
//  Otto
//
//  Created by Vania Kurniawati on 5/23/15.
//  Copyright (c) 2015 vivavania. All rights reserved.
//

#import "MenuTableViewController.h"

@interface MenuTableViewController ()



@end

@implementation MenuTableViewController

-(void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [self.delegate menuOptionSelected:indexPath.row];
  
}

@end
