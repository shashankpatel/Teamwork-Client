//
//  UIColor+KH.h
//  pro
//
//  Created by Shashank Patel on 15/09/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

#define RGBCOLOR(r, g, b) [UIColor colorWithRed:r/225.0f green:g/225.0f blue:b/225.0f alpha:1]

@interface UIColor (Teamwork)

+ (UIColor*)teamwork_Green;
+ (UIColor*)teamwork_DarkBlue;
+ (UIColor*)teamwork_Blue;

@end
