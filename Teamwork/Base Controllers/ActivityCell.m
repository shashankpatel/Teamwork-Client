//
//  MenuCell.m
//  pro
//
//  Created by Shashank Patel on 15/09/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import "ActivityCell.h"
#import "UIColor+Teamwork.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ActivityCell ()

@property   (nonatomic, strong) IBOutlet    UIView  *container;

@end

@implementation ActivityCell

- (void)awakeFromNib{
    [super awakeFromNib];
    self.container.clipsToBounds = YES;
    self.container.layer.cornerRadius = 5;
    self.container.layer.borderWidth = 1;
    self.container.layer.borderColor = [UIColor darkGrayColor].CGColor;
//    static int index = 0;
//    self.container.backgroundColor = [UIColor colorForIndex:(index++ % 4)];
    
    UIView* shadowView = self.container.superview;
    shadowView.layer.masksToBounds = NO;
    shadowView.layer.cornerRadius = shadowView.frame.size.width / 2;
    shadowView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    shadowView.layer.shadowRadius = 5.0;
    shadowView.layer.shadowOffset = CGSizeMake(0, 3.0);
    shadowView.layer.shadowOpacity = 0.75;
    self.backgroundColor = [UIColor clearColor];
    
    self.clipsToBounds = NO;
}

- (void)setActivity:(Activity*)anActivity{
    self.menuLabel.attributedText = [anActivity activityDescription];
    self.menuImageView.image = [anActivity activityImage];
}

@end
