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

+ (NSInteger) getMonth:(NSDate *)date {
  NSDate *currentDate = [NSDate date];
  NSCalendar *calendar = [NSCalendar currentCalendar];
  NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:currentDate];
  NSInteger currentMonth = [components month];
  return currentMonth;
}


+ (NSString *) recalculateTotalForMonth:(NSArray *)tripsArray {
  int elapsed = 0;
  
  //for every trip from Parse, filter for current month and calculate total hours driven
  for (PFObject *trip in tripsArray) {
    NSInteger tripMonth = [self getMonth:trip.createdAt];
    NSInteger currentMonth = [self getMonth:[NSDate date]];
    if (tripMonth == currentMonth) {
      elapsed += [trip[@"duration"] intValue];
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

+ (void)fetchTrips:(void(^)(NSArray *objects))completionBlock {
  PFQuery *query = [PFQuery queryWithClassName:@"Trip"];
  [query addDescendingOrder:@"createdAt"];
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
