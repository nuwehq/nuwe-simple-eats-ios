//
//  NuWeManager.h
//  Saily
//
//  Created by Ahmed Ghalab on 4/10/14.
//  Copyright (c) 2014 Saily.co. All rights reserved.
//

// Frameworks
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NuWeManager : NSObject

+ (instancetype)sharedManager;

- (void)startServiceWithAuthenticationKey:(NSString*) authenticationKey;
- (BOOL)showIngredientsSubmissionViewAboveViewController:(UIViewController*) presentedViewController;
@end
