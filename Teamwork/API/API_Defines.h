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
#define RESOURCES_BASE_URL      @"https://www.konecthealth.com"
#define PROFILE_IMAGE_END_POINT @"assets/uploads/profile"
#define USER_PROFILE_END_POINT  @"getprofile"
#define API_BASE_URL            @"http://dev.konecthealth.com/api/v1"
#define LOGIN_END_POINT         @"login"
#define AUTHENTICATE_URL        @"http://authenticate.teamworkpm.net/authenticate.json"
#define ACTIVITIES_URL          @"latestActivity.json?maxItems=25"

#define SIGNUP_END_POINT        @""

#endif /* API_Defines_h */
