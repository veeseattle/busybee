//
//  DataService.m
//  ottoinsurance
//
//  Created by Vania Kurniawati on 5/27/15.
//  Copyright (c) 2015 vivavania. All rights reserved.
//

#import "DataService.h"

@implementation DataService

+(id)sharedService {
  static DataService *mySharedService = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    mySharedService = [[self alloc] init];
  });
  return mySharedService;
}

-(instancetype)init {
  self = [super init];
  if (self) {
    self.coreDataStack = [[CoreDataStack alloc] init];
  }
  return self;
}

-(Trip *)addNewTrip:(NSDate *)tripDate withStartTime:(NSDate*)startTime tripDuration:(NSTimeInterval)duration {
  Trip *trip = [NSEntityDescription insertNewObjectForEntityForName:@"Trip" inManagedObjectContext:self.coreDataStack.managedObjectContext];
  
  trip.tripDate = tripDate;
  
  NSError *saveError;
  [self.coreDataStack.managedObjectContext save:&saveError];
  if (!saveError) {
    return trip;
  }
  else {
    return nil;
  }
}

@end
