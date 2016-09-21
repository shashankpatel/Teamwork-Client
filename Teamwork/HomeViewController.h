//
//  ProfileViewController.h
//  pro
//
//  Created by Shashank Patel on 12/09/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import "TWController.h"
#import "User.h"

@interface HomeViewController : TWController<UICollectionViewDataSource, UICollectionViewDelegate>

@property   (nonatomic, strong) User  *user;

@end
