//
//  Common.h
//
//  Created by Chang on 22/1/14.
//  Copyright (c) 2014 Chang. All rights reserved.
//


#import "UIKit+Common.h"

#define IS_WIDESCREEN ([[UIScreen mainScreen] bounds].size.height > 480.0)
#define IS_IPHONE   ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
#define IS_IPHONE_5 (IS_IPHONE && IS_WIDESCREEN)
#define IS_IOS7 ([[UIDevice currentDevice].systemVersion floatValue] >= 7.f)


