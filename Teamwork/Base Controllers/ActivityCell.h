//
//  MenuCell.h
//  pro
//
//  Created by Shashank Patel on 15/09/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Activity.h"

@interface ActivityCell : UICollectionViewCell

@property   (nonatomic, strong)     IBOutlet    UIImageView     *menuImageView;
@property   (nonatomic, strong)     IBOutlet    UILabel         *menuLabel;

- (void)setActivity:(Activity*)anActivity;

@end
