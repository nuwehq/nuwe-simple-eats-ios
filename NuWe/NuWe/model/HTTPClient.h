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
- (void)eatIngredients:(NSDictionary*)dictParam;

- (void)eatIngredientsWithConsideringUpdatingLastEat;
- (void)loadTodaysIngredients;


-(void) updateTodaysEat:(NSString*)eatID withIngredients:(NSArray*)ingredients withAmounts:(NSDictionary*) amountsDictionary;
@end

@protocol HTTPClientDelegate <NSObject>

@optional
- (void)didLoadIngredientsSuccess;
- (void)didLoadIngredientsFailure:(NSString*)szError;
- (void)didEatIngredientsSuccess;
- (void)didEatIngredientsFailure:(NSString*)szError;

- (void)didLoadTodayIngredientsSuccess:(NSDictionary*)ingredientsCategoriezed withAmounts:(NSMutableDictionary*) amountsComponents;
- (void)didLoadTodayIngredientsFailure:(NSString*)szError;


@end
