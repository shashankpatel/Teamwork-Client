//
//  Activity.m
//  Teamwork
//
//  Created by Shashank Patel on 21/09/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import "Activity.h"
#import "User.h"

@implementation Activity

+ (void)fetchActivitiesInBackgroundWithBlock:(nullable ActivitiesResultBlock)block{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    User *user = [User currentUser];
    
    NSString *activityURLString = [[user baseURLString] stringByAppendingPathComponent:ACTIVITIES_URL];
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    [requestSerializer setAuthorizationHeaderFieldWithUsername:user[@"APIToken"] password:user[@"password"]];
    NSMutableURLRequest *request = [requestSerializer requestWithMethod:@"GET"
                                                              URLString:activityURLString
                                                             parameters:nil
                                                                  error:nil];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
            block(nil, error);
        } else {
            NSArray *activitiesArray = responseObject[@"activity"];
            NSMutableArray<Activity*> *activities = [NSMutableArray array];
            for (NSDictionary *activityDict in activitiesArray) {
                Activity *anActivity = [[Activity alloc] initWithDictionary:activityDict];
                [activities addObject:anActivity];
            }
            block(activities, nil);
        }
    }];
    [dataTask resume];
}

- (NSAttributedString*)activityDescription{
    if (!_activityDescription) {
        NSString *userName = self[@"fromusername"];
        NSString *type = self[@"type"];
        NSString *didWhat = [self[@"activitytype"] isEqualToString:@"new"] ? @"added" : self[@"activitytype"];
        NSString *extraDescription = self[@"description"];
        NSString *actDescription = [NSString stringWithFormat:@"%@ %@ %@: \"%@\"", userName, didWhat, type, extraDescription];
        
        NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        [style setLineBreakMode:NSLineBreakByWordWrapping];

        NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"OpenSans-Light" size:18],
                                     NSParagraphStyleAttributeName: style};
        NSDictionary *boldAttributes = @{NSFontAttributeName: [UIFont fontWithName:@"OpenSans-Semibold" size:18]};
    
        const NSRange userNameRange = [actDescription rangeOfString:userName];
        
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:actDescription
                                                                                           attributes:attributes];
        [attributedText setAttributes:boldAttributes
                                range:userNameRange];
        _activityDescription = attributedText;
    }
    
    return _activityDescription;
}

- (UIImage*)activityImage{
    NSString *imageName = @"info";
    if([self[@"type"] isEqualToString:@"task"]){
        imageName = @"checkmark";
    }else if([self[@"type"] isEqualToString:@"task_comment"]){
        imageName = @"comment";
    }else if([self[@"type"] isEqualToString:@"project"]){
        imageName = @"inbox";
    }
    return [UIImage imageNamed:imageName];
}

- (CGFloat)cellHeightForWidth:(CGFloat)width{
    CGSize contentSize = [self.activityDescription boundingRectWithSize:CGSizeMake(width - 92, CGFLOAT_MAX)
                                                         options:NSStringDrawingUsesLineFragmentOrigin
                                                         context:nil].size;
    if (contentSize.height <= 40) {
        return 60;
    }
    return contentSize.height + 20;
}

@end
