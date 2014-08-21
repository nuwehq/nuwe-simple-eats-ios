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

@end

@protocol HTTPClientDelegate <NSObject>

@optional
- (void)didLoadIngredientsSuccess;
- (void)didLoadIngredientsFailure:(NSString*)szError;
- (void)didEatIngredientsSuccess;
- (void)didEatIngredientsFailure:(NSString*)szError;

@end
