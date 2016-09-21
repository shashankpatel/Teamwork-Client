//
//  AppDelegate.m
//  pro
//
//  Created by Shashank Patel on 12/09/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import "AppDelegate.h"
#import "Macros.h"
#import "User.h"
#import "HomeViewController.h"
#import "LoginController.h"

@interface AppDelegate ()

@property (nonatomic, strong)   HomeViewController  *homeVC;
@property (nonatomic, strong)   LoginController     *loginVC;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self setController];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

+ (void)setController{
    [(AppDelegate *)[UIApplication sharedApplication].delegate setController];
    
}

- (void)setController{
//    [User logInWithEmailInBackground:@"drjinesh123@gmail.com" password:@"jinesh.kh" block:^(User * _Nullable user, NSError * _Nullable error) {
//        if (user) {
//            self.homeVC = ControllerFromMainStoryBoard(@"HomeViewController");
//            self.homeVC.user = user;
//            self.window.rootViewController = self.homeVC;
//        }
//        
//    }];
////    return;
    if ([User currentUser]) {
        self.homeVC = ControllerFromMainStoryBoard(@"HomeViewController");
        self.homeVC.user = [User currentUser];
        self.window.rootViewController = self.homeVC;
    }else{
        //Show Login
        self.loginVC = ControllerFromMainStoryBoard(@"LoginController");
        self.window.rootViewController = self.loginVC;
    }
}

@end
