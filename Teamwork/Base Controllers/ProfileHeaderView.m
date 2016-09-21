//
//  ProfileHeaderView.m
//  pro
//
//  Created by Shashank Patel on 15/09/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import "ProfileHeaderView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <MBProgressHUD/MBProgressHUD.h>

@interface ProfileHeaderView ()

@property (nonatomic, strong)   IBOutlet    UIImageView         *profileImageView;
@property (nonatomic, strong)   IBOutlet    UILabel             *profileName;

@end

@implementation ProfileHeaderView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    
    UIView* shadowView = self.profileImageView.superview;
    shadowView.layer.masksToBounds = NO;
    shadowView.layer.cornerRadius = shadowView.frame.size.width / 2;
    shadowView.layer.shadowColor = [UIColor blackColor].CGColor;
    shadowView.layer.shadowRadius = 15.0;
    shadowView.layer.shadowOffset = CGSizeMake(3.0, 3.0);
    shadowView.layer.shadowOpacity = 0.5;
}

- (void)layoutSubviews{
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height / 2;
}

- (void)setUser:(User *)user{
    self.profileName.text = [user fullName];
    [MBProgressHUD showHUDAddedTo:self.profileImageView animated:YES];
    [self.profileImageView sd_setImageWithURL:[NSURL URLWithString:[user profileImageURL]]
                             placeholderImage:nil
                                      options:SDWebImageProgressiveDownload | SDWebImageRefreshCached
                                    completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                        [MBProgressHUD hideHUDForView:self.profileImageView animated:YES];
                                    }];
}

@end
