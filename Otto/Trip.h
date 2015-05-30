//
//  Trip.h
//  ottoinsurance
//
//  Created by Vania Kurniawati on 5/27/15.
//  Copyright (c) 2015 vivavania. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface Trip : NSObject

@property (strong,nonatomic) NSDate *tripDate;
@property (assign) int tripDuration;
@property (assign) NSDate *startTime;
@property (assign) NSDate *endTime;


@end
