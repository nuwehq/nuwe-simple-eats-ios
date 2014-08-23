//
//  HTTPClient.m
//  Nutribu
//
//  Created by ChangShiYuan on 4/23/14.
//  Copyright (c) 2014 Chang. All rights reserved.
//

#import "HTTPClient.h"
#import "Data.h"
#import "Common.h"

@implementation HTTPClient

static NSString* const API_URL = @"https://api.nuapi.co/v1";

//nutribu v1
static NSString* const APP_ID  = @"d7ff5505";
static NSString* const APP_KEY = @"b0df05161e98e0997ac325386d426cad";


//error message
static NSString* const ERR_SERVICE_UNAVAILABLE = @"Service is unavailable.";


+ (HTTPClient*)sharedClient
{
    static HTTPClient* _sharedHTTPClient = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedHTTPClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:API_URL]];
    });
    
    return _sharedHTTPClient;
}

- (instancetype)initWithBaseURL:(NSURL *)url
{
   self = [super initWithBaseURL:url];
    
    if (self)
    {
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        self.requestSerializer = [AFJSONRequestSerializer serializer];

    }
    
    return self;
}

#pragma mark
#pragma mark Groups API

- (void)loadIngredientGroup
{
    gData.aIngredientTopGroups = nil;
    gData.aIngredientSubGroups = nil;
    gData.aIngredientSubGroupStartIndex = nil;

    
    [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [self GET:@"ingredient_groups.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"get ingredient groups successfully : %@", responseObject);
         
         NSInteger nStatusCode = operation.response.statusCode;
         if (nStatusCode == 200)
         {
             NSDate* start = [NSDate date];
             NSArray *array = (NSArray*)[(NSDictionary*)responseObject objectForKey:@"ingredient_groups"];
             int count = (int)[array count];

             
             gData.aIngredientTopGroups = [[NSMutableArray alloc] initWithCapacity:count];
             gData.aIngredientSubGroups = [[NSMutableArray alloc] init];
             gData.aIngredientSubGroupStartIndex =  [[NSMutableArray alloc] initWithCapacity:count];
             for (int i = 0; i < count ; i++)
             {
                 NSDictionary* dict = [array objectAtIndex:i];
                 
                 IngredientTopGroup* topGroup = [[IngredientTopGroup alloc] init];
                 
                 topGroup.szId = [dict objectForKey: @"id"];
                 topGroup.szName = [dict objectForKey: @"name"];
                 
                 NSDictionary* dictIconPath =[dict objectForKey:@"icon"];
                 topGroup.szIconPathTiny = [dictIconPath objectForKey:@"tiny"];
                 topGroup.szIconPathSmall = [dictIconPath objectForKey:@"small"];
                 topGroup.szIconPathMedium = [dictIconPath objectForKey:@"medium"];
                 
                 int nFirstIndex = (int)[gData.aIngredientSubGroups count];
                 
                 NSArray* arraySubGroup = [dict objectForKey:@"ingredients"];
                 if (arraySubGroup != (NSArray*)[NSNull null])
                 {
                     int nCount = (int)[arraySubGroup count];
                     topGroup.nSubGroupNum = nCount;
                     
                     NSMutableArray* arraySub = [NSMutableArray arrayWithCapacity:nCount];
                     
                     for (NSDictionary* dict in arraySubGroup)
                     {
                         //NSDictionary* dict = [arraySubGroup objectAtIndex:j];
                         IngredientSubGroup* subGroup = [[IngredientSubGroup alloc] init];
                         subGroup.szId = [dict objectForKey: @"id"];
                         subGroup.szName = [dict objectForKey: @"name"];
                         subGroup.rKcal = [[dict objectForKey:@"kcal"] floatValue];
                         subGroup.rProt = [[dict objectForKey:@"protein"] floatValue];
                         subGroup.rFibre = [[dict objectForKey:@"fibre"] floatValue];
                         subGroup.rCarbs = [[dict objectForKey:@"carbs"] floatValue];
                         subGroup.rUFat = [[dict objectForKey:@"fat_u"] floatValue];
                         subGroup.rSFat = [[dict objectForKey:@"fat_s"] floatValue];
                         subGroup.rSalt = [[dict objectForKey:@"salt"] floatValue];
                         subGroup.rSugar = [[dict objectForKey:@"sugar"] floatValue];
                         
                         subGroup.nSmallDefaultPortion = (int)[[dict objectForKey: @"small_portion"] integerValue];
                         subGroup.nMediumDefaulPortion = (int)[[dict objectForKey: @"medium_portion"] integerValue];
                         subGroup.nLargeDefaulPortion = (int)[[dict objectForKey: @"large_portion"] integerValue];
                         
                         [arraySub addObject:subGroup];
                     }
                     
                     [gData.aIngredientSubGroups addObjectsFromArray:arraySub];
                     [gData.aIngredientSubGroupStartIndex addObject:[NSNumber numberWithInteger:nFirstIndex]];
                 }
                 else
                 {
                     [gData.aIngredientSubGroupStartIndex addObject:[NSNull null]];
                 }
                 
                 [gData.aIngredientTopGroups addObject:topGroup];
             }
             
             [_delegate didLoadIngredientsSuccess];
             
             NSTimeInterval timeInteval = [[NSDate date] timeIntervalSinceDate:start];
             NSLog(@"ingredient time interval - %f", timeInteval);
         }
         else
         {
             NSString* szMsg = [(NSDictionary*)responseObject objectForKey:@"error"];
             [_delegate didLoadIngredientsFailure:szMsg];

         }
         
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"get the top ingredients failure: %@", error);
         [_delegate didLoadIngredientsFailure:@"Service is unavailable"];
         
     }];
}


#pragma mark - eat api
- (void)eatIngredients
{
    [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSString* strToken = [NSString stringWithFormat:@"Token %@", [[NSUserDefaults standardUserDefaults] objectForKey:NWUserSavedAuthenticationToken]];
    [self.requestSerializer setValue:strToken forHTTPHeaderField:@"Authorization"];
    
    int nCount = (int)[gData.aIngredientSubGroups count];
    NSMutableArray* arrayIngredients = [[NSMutableArray alloc] initWithCapacity:nCount];
    
    for (int i = 0; i < nCount; i++)
    {
        NSNumber* numberAmount = (NSNumber*)[gData.aIngredientSubGroupAmount objectAtIndex:i];
        int nAmount = numberAmount.intValue;
        if (!nAmount)
            continue;
        
        NSMutableDictionary* dictIngredient = [[NSMutableDictionary alloc] init];
        
        IngredientSubGroup* subGroup = [gData.aIngredientSubGroups objectAtIndex:i];
        [dictIngredient setObject:subGroup.szId forKey:@"ingredient_id"];
        [dictIngredient setObject:[NSNumber numberWithInt:nAmount] forKey:@"amount"];
        
        [arrayIngredients addObject:dictIngredient];
    }
    
    NSDictionary* dictParam = @{@"eat":@{@"components":arrayIngredients}};
    NSLog(@"%@", dictParam);

    [self POST:@"eats.json" parameters:dictParam success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"eat ingredients successfully : %@", responseObject);
         
         NSInteger nStatusCode = operation.response.statusCode;
         if (nStatusCode == 201)
         {
             [_delegate didEatIngredientsSuccess];
         }
         else
         {
             [_delegate didEatIngredientsFailure:@"eat ingredients failure"];
         }
         
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"eat ingredients error: %@", error);
         
         [_delegate didEatIngredientsFailure:@"eat ingredients failure"];
         
     }];
}

@end
