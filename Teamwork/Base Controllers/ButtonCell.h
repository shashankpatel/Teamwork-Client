//
//  MenuCell.h
//  pro
//
//  Created by Shashank Patel on 15/09/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ButtonCell : UICollectionViewCell

@property   (nonatomic, strong)     IBOutlet    UIButton    *button;

- (void)setButtonText:(NSString*)str;

@end
