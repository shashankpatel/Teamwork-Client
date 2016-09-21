//
//  MenuCell.m
//  pro
//
//  Created by Shashank Patel on 15/09/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import "ButtonCell.h"
#import "UIColor+Teamwork.h"

@interface ButtonCell ()

@end

@implementation ButtonCell

- (void)awakeFromNib{
    [super awakeFromNib];
    self.button.clipsToBounds = YES;
    self.button.layer.cornerRadius = 5;
    self.button.backgroundColor = [UIColor teamwork_DarkBlue];
    [self.button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    UIView* shadowView = self.button.superview;
    shadowView.layer.masksToBounds = NO;
    shadowView.layer.cornerRadius = shadowView.frame.size.width / 2;
    shadowView.layer.shadowColor = self.button.backgroundColor.CGColor;
    shadowView.layer.shadowRadius = 5.0;
    shadowView.layer.shadowOffset = CGSizeMake(0, 3.0);
    shadowView.layer.shadowOpacity = 0.75;
    self.backgroundColor = [UIColor clearColor];
    
    self.clipsToBounds = NO;
}

- (void)setButtonText:(NSString*)str{
    [_button setTitle:str forState:UIControlStateNormal];
}

@end
