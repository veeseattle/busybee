//
//  AppUtils.m
//  ottoinsurance
//
//  Created by Vania Kurniawati on 5/30/15.
//  Copyright (c) 2015 vivavania. All rights reserved.
//

#import "AppUtils.h"
#import <Parse/Parse.h>

@implementation AppUtils

#pragma mark - topViewStat method

//given NSDate, return current month (e.g. 6, 5)
+ (NSInteger) getMonth:(NSDate *)date {
  NSDate *currentDate = date;
  NSCalendar *calendar = [NSCalendar currentCalendar];
  NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:currentDate];
  NSInteger currentMonth = [components month];
  return currentMonth;
}

+ (NSString *) formatTimeToString:(int)elapsed {
  int hours = (int) (elapsed / 3600);
  elapsed -= hours * 3600;
  int mins = (int) (elapsed/60);
  elapsed -= mins * 60;
  int secs = (int) elapsed;
  NSString *time = [NSString stringWithFormat:@"%u h %u m %02u s", hours, mins, secs];
  return time;
}

+ (NSString *) recalculateTotalForMonth:(NSArray *)dataArray {
  int elapsed = 0;
  
  //for every session from Parse, filter for current month and calculate total hours
  for (PFObject *data in dataArray) {
    NSInteger sessionMonth = [self getMonth:data.createdAt];
    NSInteger currentMonth = [self getMonth:[NSDate date]];
    if (sessionMonth == currentMonth) {
      elapsed += [data[@"duration"] intValue];
    }
  }
  
  //format total hours, mins, secs
  int hours = (int) (elapsed / 3600);
  elapsed -= hours * 3600;
  int mins = (int) (elapsed / 60);
  elapsed -= mins * 60;
  int secs = (int) elapsed;
  
  //format current date into MMMM yyyy (e.g. May 2015)
  NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
  [dateFormat setDateFormat:@"MMMM yyyy"];
  NSString *dateString = [dateFormat stringFromDate:[NSDate date]];
  
  NSString *totalStatLabel = [NSString stringWithFormat:@"%@ | %u h %u m %02u s", dateString, hours, mins, secs];
  return totalStatLabel;
}

#pragma mark - Parse methods

+ (void)fetchData:(void(^)(NSArray *objects))completionBlock {
  PFQuery *query = [PFQuery queryWithClassName:@"Activity"];
  [query whereKey:@"owner" equalTo:[PFUser currentUser]];
  [query addDescendingOrder:@"updatedAt"];
  [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
    if (!error) {
      completionBlock(objects);
    }
    else {
      NSLog(@"Error: %@ %@", error, [error userInfo]);
    }
  }];
}

@end
