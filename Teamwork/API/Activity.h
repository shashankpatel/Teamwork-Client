//
//  Activity.h
//  Teamwork
//
//  Created by Shashank Patel on 21/09/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import "TWObject.h"

@class Activity;

typedef void (^ActivitiesResultBlock)(NSArray<Activity *> *_Nullable activities, NSError *_Nullable error);

@interface Activity : TWObject

@property (nonatomic, strong) NSAttributedString  *activityDescription;

+ (void)fetchActivitiesInBackgroundWithBlock:(nullable ActivitiesResultBlock)block;

- (nullable UIImage*)activityImage;
- (CGFloat)cellHeightForWidth:(CGFloat)width;

@end
