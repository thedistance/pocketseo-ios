//
//  UIView+SwiftAppearance.h
//  MozQuito
//
//  Created by Josh Campion on 13/04/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (SwiftAppearance)
// appearanceWhenContainedIn: is not available in Swift. This fixes that.
+ (instancetype)my_appearanceWhenContainedIn:(Class<UIAppearanceContainer>)containerClass;
@end

@interface UIBarButtonItem (SwiftAppearance)
// appearanceWhenContainedIn: is not available in Swift. This fixes that.
+ (instancetype)my_appearanceWhenContainedIn:(Class<UIAppearanceContainer>)containerClass;
@end