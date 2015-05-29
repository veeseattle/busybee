//
//  CustomNavigationBar.h
//  ottoinsurance
//
//  Created by Vania Kurniawati on 5/28/15.
//  Copyright (c) 2015 vivavania. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomNavigationBar : UINavigationBar

@property (strong,nonatomic) UILabel *topTitle;
@property (strong,nonatomic) UILabel *subTitle;

-(instancetype)init;

@end
