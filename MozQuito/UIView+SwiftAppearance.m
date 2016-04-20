//
//  UIView+SwiftAppearance.m
//  MozQuito
//
//  Created by Josh Campion on 13/04/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

#import "UIView+SwiftAppearance.h"

@implementation UIView (SwiftAppearance)

+ (instancetype)my_appearanceWhenContainedIn:(Class<UIAppearanceContainer>)containerClass {
    return [self appearanceWhenContainedIn:containerClass, nil];
}

@end

@implementation UIBarButtonItem (SwiftAppearance)

+ (instancetype)my_appearanceWhenContainedIn:(Class<UIAppearanceContainer>)containerClass {
    return [self appearanceWhenContainedIn:containerClass, nil];
}


@end