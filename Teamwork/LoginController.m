//
//  LoginController.m
//  pro
//
//  Created by Shashank Patel on 16/09/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import "LoginController.h"
#import "UIColor+Teamwork.h"
#import "User.h"
#import "AppDelegate.h"
#import <UIAlertView+Blocks/UIAlertView+Blocks.h>
#import <MBProgressHUD/MBProgressHUD.h>

@interface LoginController ()

@property (nonatomic, strong)   IBOutlet    UITextField *emailField, *passwordField;
@property (nonatomic, strong)   IBOutlet    UIButton    *loginButton, *signUpButton;

@end

@implementation LoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self applyVisualStyle];
    // Do any additional setup after loading the view.
}

- (void)applyVisualStyle{
    
    NSArray *fields = @[self.emailField, self.passwordField, self.loginButton];
    
    for (UIView *view in fields) {
        view.clipsToBounds = YES;
        view.layer.cornerRadius = 5;
        continue;
        UIView* shadowView = view.superview;
        shadowView.layer.masksToBounds = NO;
        shadowView.layer.cornerRadius = shadowView.frame.size.width / 2;
        shadowView.layer.shadowColor = [UIColor whiteColor].CGColor;
        shadowView.layer.shadowRadius = 1.0;
        shadowView.layer.shadowOpacity = 0.5;
    }

    [self.loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.loginButton.backgroundColor = [UIColor teamwork_Blue];
    
    self.view.clipsToBounds = NO;
}

- (IBAction)loginTapped:(id)sender{
    if (!self.passwordField.text.length ||
        !self.emailField.text.length) {
        [UIAlertView showWithTitle:@"Error"
                           message:@"Password is a required field."
                 cancelButtonTitle:@"Ok"
                 otherButtonTitles:nil
                          tapBlock:nil];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [User logInWithAPITokenInBackground:self.emailField.text
                                 password:self.passwordField.text
                                    block:^(User * _Nullable user, NSError * _Nullable error) {
                                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                                        if (error) {
                                            [UIAlertView showWithTitle:@"Error"
                                                               message:@"Invalid Credentials"
                                                     cancelButtonTitle:@"Ok"
                                                     otherButtonTitles:nil
                                                              tapBlock:nil];
                                        }else{
                                            [AppDelegate setController];
                                        }
                                        
                                    }];
}

- (BOOL)NSStringIsValidEmail:(NSString *)checkString{
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
