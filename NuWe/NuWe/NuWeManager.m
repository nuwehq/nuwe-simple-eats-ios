//
//  NuWeManager.m
//  Saily
//
//  Created by Ahmed Ghalab on 4/10/14.
//  Copyright (c) 2014 Saily.co. All rights reserved.
//

#import "NuWeManager.h"
#import "Common.h"

@implementation NuWeManager

static NSString* settingsFileName = @"app-settings.plist";

- (id)init {
    self = [super init];
    
    if(self) {
        // Do custom Intialization ..
    }
    
    return self;
}

+ (instancetype)sharedManager {
    static NuWeManager *sharedSingleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedSingleton = [[self alloc]init];
    });
    
    return sharedSingleton;
}


- (void)startServiceWithAuthenticationKey:(NSString*) authenticationKey
{
    if (authenticationKey && ![authenticationKey isEqualToString:@""]) {
        [[NSUserDefaults standardUserDefaults] setObject:authenticationKey forKey:NWUserSavedAuthenticationToken];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (BOOL)showIngredientsSubmissionViewAboveViewController:(UIViewController*) presentedViewController
{
    if (![[NSUserDefaults standardUserDefaults] objectForKey:NWUserSavedAuthenticationToken]) {
        return NO;
    }
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"NuWe.bundle/NuWeMain" bundle:nil];
    UINavigationController* controller = [storyboard instantiateViewControllerWithIdentifier:@"IngredientListViewController"];
    [controller setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [presentedViewController presentViewController:controller animated:NO completion:NULL];
    return YES;
}

@end
