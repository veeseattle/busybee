//
//  AppUtils.h
//  busybee
//
//  Created by Vania Kurniawati on 5/30/15.
//  Copyright (c) 2015 vivavania. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppUtils : NSObject

#define globalColor [UIColor colorWithRed:(96.0f/255.0f) green:(227.0f/255.0f) blue:(212.0f/255.0f) alpha:1.0f]

+ (NSInteger) getMonth:(NSDate *)date;
+ (NSString *) formatTimeToString:(int)elapsed;
+ (NSString *) recalculateTotalForMonth:(NSArray *)dataArray;
+ (void)fetchData:(NSString *)className withBlock:(void(^)(NSArray *objects))completionBlock;

@end
