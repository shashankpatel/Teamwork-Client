//
//  User.m
//  Chroma
//
//  Created by Shashank Patel on 14/04/16.
//  Copyright © 2016. All rights reserved.
//

#import "User.h"
#import <AFNetworking/AFNetworking.h>

@implementation User

- (NSString*)objectId{
    return internalObject[@"_id"];
}

- (void)setFullName:(NSString *)fullName{
    internalObject[@"fullName"] = fullName;
}

- (NSString*)fullName{
    NSString *name = internalObject[@"fullName"];
    if (name.length == 0) {
        NSString *firstName = internalObject[@"firstname"];
        NSString *lastName = internalObject[@"lastname"];
        NSMutableArray *nameArray = [NSMutableArray array];
        if (firstName.length) {
            [nameArray addObject:firstName.capitalizedString];
        }
        if (lastName.length) {
            [nameArray addObject:lastName.capitalizedString];
        }
        
        name = [NSString stringWithFormat:@"%@", [nameArray componentsJoinedByString:@" "]];
    }
    return name;
}

- (void)setToken:(NSString *)token{
    internalObject[@"api_token"] = token;
}

- (NSString*)token{
    NSString *tokenString = internalObject[@"api-token"] ? internalObject[@"api-token"] : updateObject[@"api-token"];
    return tokenString;
}

static User *currentUser;

+ (User*)currentUser{
    if (currentUser) {
        return currentUser;
    }
    
    NSDictionary *currentUserDict = [defaults_object(CURRENT_USER_KEY) JSONObject];
    if(currentUserDict){
        currentUser = [[User alloc] initWithDictionary:currentUserDict];
        return currentUser;
    }
    
    return nil;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict{
    if (self = [super initWithDictionary:dict]) {
        
    }
    return self;
}

+ (void)logOut{
    defaults_remove(CURRENT_USER_KEY);
    currentUser = nil;
}

+ (void)logInWithAPITokenInBackground:(nonnull NSString *)APIToken
                             password:(NSString *)password
                                block:(nullable UserResultBlock)block{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    [requestSerializer setAuthorizationHeaderFieldWithUsername:APIToken password:password];
    NSMutableURLRequest *request = [requestSerializer requestWithMethod:@"GET"
                                                              URLString:AUTHENTICATE_URL
                                                             parameters:nil
                                                                  error:nil];

    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
            block(nil, error);
        } else {
            User *user = [[User alloc] initWithDictionary:responseObject[@"account"]];
            user[@"APIToken"] = APIToken;
            user[@"password"] = password;
            [user setCurrent];
            block(user, nil);
        }
    }];
    [dataTask resume];
}

+ (void)requestPasswordResetForEmailInBackground:(nonnull NSString*)email block:(nullable BooleanResultBlock)block{
    
}

- (void)fetchProfileInBackgroundWithBlock:(nullable UserResultBlock)block{
    
}

- (void)fetchInBackground{
    [self fetchProfileInBackgroundWithBlock:nil];
}

- (void)setCurrent{
    for (NSString *key in updateObject.allKeys) {
        internalObject[key] = updateObject[key];
    }
    defaults_set_object(CURRENT_USER_KEY, [internalObject JSONString]);
}

- (void)signUpInBackgroundWithBlock:(nullable BooleanResultBlock)block{
    
}

- (void)saveInBackgroundWithBlock:(nullable BooleanResultBlock)block{
    
}

- (void)saveInBackground{
    [self saveInBackgroundWithBlock:nil];
}

+ (void)updatePasswordForEmail:(NSString*)email OTP:(NSString*)OTP password:(NSString*)newPassword block:(BooleanResultBlock)block{
    
}

- (NSString*)description{
    return [NSString stringWithFormat:@"Internal:%@ \n Update: %@", [internalObject description], [updateObject description]];
}

- (NSString*)profileImageURL{
    NSString *avatarURLString = [self[@"avatar-url"] stringByRemovingPercentEncoding];
    NSRange range = [avatarURLString rangeOfString:@"//"];
    if (range.location != NSNotFound) {
        range.length = range.location + range.length;
        range.location = 0;
        avatarURLString = [avatarURLString stringByReplacingCharactersInRange:range withString:@""];
    }
    
//    if (![avatarURLString hasPrefix:@"http:"]) {
        avatarURLString = [@"https://" stringByAppendingString:avatarURLString];
//    }
    return avatarURLString;
}

- (NSString*)baseURLString{
    return self[@"URL"];
}

@end
