//
//  Macros.h
//  pro
//
//  Created by Shashank Patel on 16/09/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#ifndef Macros_h
#define Macros_h

#define ControllerFromStoryBoard(storyboard, identifier) [[UIStoryboard storyboardWithName:storyboard bundle:nil] instantiateViewControllerWithIdentifier:identifier]
#define ControllerFromMainStoryBoard(identifier) ControllerFromStoryBoard(@"Main", identifier)

#define NavigationControllerWithController(controller) [[UINavigationController alloc] initWithRootViewController:controller]

#endif /* Macros_h */
