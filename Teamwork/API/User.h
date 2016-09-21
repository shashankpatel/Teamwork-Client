//
//  User.h
//  Chroma
//
//  Created by Shashank Patel on 14/04/16.
//  Copyright © 2016 Themeefy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TWObject.h"

@interface User : TWObject

@property (nonatomic, strong, nonnull) NSString  *fullName, *email, *password, *token;

typedef void (^UserResultBlock)(User *_Nullable user, NSError *_Nullable error);

+ (nullable User*)currentUser;
+ (void)logOut;
+ (void)logInWithAPITokenInBackground:(nonnull NSString *)APIToken
                             password:(nonnull NSString *)password
                                block:(nullable UserResultBlock)block;
+ (void)requestPasswordResetForEmailInBackground:(nonnull NSString*)email block:(nullable BooleanResultBlock)block;
+ (void)updatePasswordForEmail:(nonnull NSString*)email OTP:(nonnull NSString*)OTP password:(nonnull NSString*)newPassword block:(nullable BooleanResultBlock)block;

- (void)setCurrent;
- (void)signUpInBackgroundWithBlock:(nullable BooleanResultBlock)block;
- (void)fetchProfileInBackgroundWithBlock:(nullable UserResultBlock)block;
- (void)fetchInBackground;
- (void)saveInBackgroundWithBlock:(nullable BooleanResultBlock)block;
- (void)saveInBackground;

- (NSString* _Nullable )profileImageURL;
- (NSString*)baseURLString;

@end
