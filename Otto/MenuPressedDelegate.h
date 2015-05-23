//
//  MenuPressedDelegate.h
//  Otto
//
//  Created by Vania Kurniawati on 5/23/15.
//  Copyright (c) 2015 vivavania. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MenuPressedDelegate <NSObject>

-(void)menuOptionSelected:(NSInteger)selectedRow;

@end
