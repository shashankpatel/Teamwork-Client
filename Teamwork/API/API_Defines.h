//
//  API_Defines.h
//  pro
//
//  Created by Shashank Patel on 16/09/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#ifndef API_Defines_h
#define API_Defines_h

#import <AFNetworking/AFNetworking.h>
#import "NSUserDefaults-macros.h"
#import "NSArray+JSON.h"
#import "NSDictionary+JSON.h"
#import "NSString+JSON.h"

#define CURRENT_USER_KEY        @"current_user"
#define LOGIN_END_POINT         @"login"
#define AUTHENTICATE_URL        @"http://authenticate.teamworkpm.net/authenticate.json"
#define ACTIVITIES_URL          @"latestActivity.json?maxItems=25"

#define SIGNUP_END_POINT        @""

#endif /* API_Defines_h */
