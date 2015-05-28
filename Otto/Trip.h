//
//  Trip.h
//  ottoinsurance
//
//  Created by Vania Kurniawati on 5/27/15.
//  Copyright (c) 2015 vivavania. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Trip : NSObject

@property (strong,nonatomic) NSDate *tripDate;
@property (assign) NSInteger tripDuration;
@property (assign) NSTimeInterval startTime;
@property (assign) NSTimeInterval endTime; 


@end
