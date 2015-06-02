//
//  AppUtils.h
//  ottoinsurance
//
//  Created by Vania Kurniawati on 5/30/15.
//  Copyright (c) 2015 vivavania. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppUtils : NSObject

#define globalColor [UIColor colorWithRed:(87.0f/255.0f) green:(205.0f/255.0f) blue:(192.0f/255.0f) alpha:0.8f]

+ (NSInteger) getMonth:(NSDate *)date;
+ (NSString *) formatTimeToString:(int)elapsed;
+ (NSString *) recalculateTotalForMonth:(NSArray *)dataArray;
+ (void)fetchData:(void(^)(NSArray *objects))completionBlock;

@end
