//
//  NavigationBar.m
//  ottoinsurance
//
//  Created by Vania Kurniawati on 5/28/15.
//  Copyright (c) 2015 vivavania. All rights reserved.
//

#import "NavigationBar.h"

@implementation NavigationBar

-(instancetype)init {
  self = [super init];
  if (self) {
    
    UILabel *titleMonth = [[UILabel alloc] initWithFrame:CGRectMake(120, 5, 100, 20)];
    titleMonth.text = @"May 2015";
    [titleMonth sizeToFit];
    [self addSubview:titleMonth];
    
  
  }
  return self;
}

- (CGSize)sizeThatFits:(CGSize)size {
  CGSize newSize = CGSizeMake(self.frame.size.width,64);
  return newSize;
}

@end
