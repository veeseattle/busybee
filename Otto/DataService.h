//
//  DataService.h
//  ottoinsurance
//
//  Created by Vania Kurniawati on 5/27/15.
//  Copyright (c) 2015 vivavania. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreDataStack.h"
#import "Trip.h"

@interface DataService : NSObject

@property (strong,nonatomic) CoreDataStack *coreDataStack;

+(id)sharedService;
-(Trip *)addNewTrip:(NSDate *)tripDate withStartTime:(NSTimeInterval)startTime tripDuration:(NSTimeInterval)duration;

@end
