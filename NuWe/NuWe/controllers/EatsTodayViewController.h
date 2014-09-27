//
//  EatsTodayViewController.h
//  NuWe
//
//  Created by Ahmed Ghalab on 9/23/14.
//  Copyright (c) 2014 Nutribu Limited. All rights reserved.
//

#import "SuperViewController.h"

@interface EatsTodayViewController : SuperViewController

@property (nonatomic, strong) NSString* lastTodaysEatID;
@property (nonatomic, strong) NSDictionary* ingredientsCategoriezedDictionary;
@property (nonatomic, strong) NSMutableDictionary* ingredientsAmountsDictionary;
@end
