//
//  User.m
//  Chroma
//
//  Created by Shashank Patel on 14/04/16.
//  Copyright © 2016 Themeefy. All rights reserved.
//

#import "User.h"
#import <AFNetworking/AFNetworking.h>

@implementation User

- (NSString*)objectId{
    return internalObject[@"_id"];
}

- (void)setEmail:(NSString *)email{
    internalObject[@"kh-auth-user"] = email;
}

- (NSString*)email{
    return internalObject[@"kh-auth-user"];
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
    NSDictionary *loginHeaders = @{@"kh-auth-user" : self.email};
    NSDictionary *parameters = @{@"api_token" : self.token};
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    
    NSString *URLString = [API_BASE_URL stringByAppendingPathComponent:USER_PROFILE_END_POINT];
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST"
                                                                                 URLString:URLString
                                                                                parameters:parameters
                                                                                     error:nil];
    for (NSString *headerKey in loginHeaders.allKeys) {
        [request setValue:loginHeaders[headerKey] forHTTPHeaderField:headerKey];
    }
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
            if(block)block(nil, error);
        } else {
            if ([responseObject[@"status"] isEqualToString:@"success"]) {
                NSMutableDictionary *userDict = [responseObject[@"data"] mutableCopy];
                for (id<NSCopying> key in userDict.allKeys) {
                    if([userDict[key] isKindOfClass:[NSNull class]]){
                        userDict[key] = @"";
                    }
                }
//                [[NSNotificationCenter defaultCenter] postNotificationName:USER_RELOADED_NOTIFICATION object:nil];
                self[@"profile"] = userDict;
                [self setCurrent];
                if(block)block(self, nil);
            }
        }
    }];
    [dataTask resume];
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
    NSDictionary *signUpDict = @{@"fullName" : self.fullName,
                                 @"email" : self.email,
                                 @"password" : self.password};
    NSString *URLString = [API_BASE_URL stringByAppendingPathComponent:SIGNUP_END_POINT];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST"
                                                                                 URLString:URLString
                                                                                parameters:signUpDict
                                                                                     error:nil];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
            block(NO, error);
        } else {
            NSLog(@"%@ %@", response, responseObject);
            block(YES, nil);
        }
    }];
    [dataTask resume];
}

- (void)saveInBackgroundWithBlock:(nullable BooleanResultBlock)block{
    /*
    NSString *urlEndPoint = USER_PROFILE_END_POINT;
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:API_BASE_URL]];
    manager.requestSerializer = [AFJSONRequestSerializer new];
    [manager.requestSerializer setValue:self.token forHTTPHeaderField:@"Authorization"];
    [manager PATCH:urlEndPoint
        parameters:updateObject
           success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
               NSLog(@"responseObject: %@", [responseObject description]);
               [self resetDetails:responseObject[@"user"]];
               [self setCurrent];
               if(block)block(YES, nil);
               [[NSNotificationCenter defaultCenter] postNotificationName:USER_RELOADED_NOTIFICATION object:nil];
           }
           failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
               if(block)block(NO, error);
               NSLog(@"Error: %@", error.description);
           }];
     */
}

- (void)saveInBackground{
    [self saveInBackgroundWithBlock:nil];
}

+ (void)updatePasswordForEmail:(NSString*)email OTP:(NSString*)OTP password:(NSString*)newPassword block:(BooleanResultBlock)block{
    /*
    NSDictionary *parameters = @{@"email": email,
                                 @"otp" : OTP,
                                 @"newPassword" : newPassword};
    NSString *urlEndPoint = UPDATE_PASSWORD_END_POINT;
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:API_BASE_URL]];
    manager.requestSerializer = [AFJSONRequestSerializer new];
    [manager.requestSerializer setValue:[User currentUser].token forHTTPHeaderField:@"Authorization"];
    [manager PATCH:urlEndPoint
        parameters:parameters
           success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
               NSLog(@"responseObject: %@", [responseObject description]);
               if(block)block(YES, nil);
           }
           failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
               if(block)block(NO, error);
               NSLog(@"Error: %@", error.description);
           }];
     */
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
