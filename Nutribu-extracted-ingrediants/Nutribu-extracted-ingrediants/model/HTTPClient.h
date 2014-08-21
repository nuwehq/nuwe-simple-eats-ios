//
//  HTTPClient.h
//  Nutribu
//
//  Created by ChangShiYuan on 4/23/14.
//  Copyright (c) 2014 Chang. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"

@protocol HTTPClientDelegate;

@interface HTTPClient : AFHTTPRequestOperationManager

@property (nonatomic, weak) id <HTTPClientDelegate> delegate;

+ (HTTPClient*)sharedClient;

- (void)loadIngredientGroup;
- (void)eatIngredients;
//- (void)saveMeal:(NSString*)szName andImage:(UIImage*)image;
//- (void)previewMeal;

@end

@protocol HTTPClientDelegate <NSObject>

@optional
//- (void)didSignupSuccess;
//- (void)didSignupFailure:(NSString*)szError;
//- (void)didSigninSuccess:(BOOL)fLoadProfile;
//- (void)didSigninFailure:(NSString*)szError;
//- (void)didUpdateProfileSuccess;
//- (void)didUpdateProfileFailure:(NSString*)szError;
- (void)didLoadIngredientsSuccess;
- (void)didLoadIngredientsFailure:(NSString*)szError;
- (void)didEatIngredientsSuccess;
- (void)didEatIngredientsFailure:(NSString*)szError;
//- (void)didSaveMealSuccess;
//- (void)didSaveMealFailure:(NSString*)szError;
//- (void)didPreviewMealSuccess;
//- (void)didPreviewMealFailure:(NSString*)szError;


@end
