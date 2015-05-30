//
//  AppUtils.h
//  ottoinsurance
//
//  Created by Vania Kurniawati on 5/30/15.
//  Copyright (c) 2015 vivavania. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppUtils : NSObject

+ (NSInteger) getMonth:(NSDate *)date;
+ (NSString *) recalculateTotalForMonth:(NSArray *)tripsArray;
+ (void)fetchTrips:(void(^)(NSArray *objects))completionBlock;

@end
