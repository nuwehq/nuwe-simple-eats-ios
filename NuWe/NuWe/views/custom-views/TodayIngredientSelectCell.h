//
//  IngredientSelectTableViewCell.h
//  Nutribu
//
//  Created by ChangShiYuan on 5/29/14.
//  Copyright (c) 2014 Chang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKSTableViewCell.h"
#import "Data.h"

@protocol EatsTodayIngredientUpdateDelegate <NSObject>
- (void)updateIngredientWithId:(NSString*)ingredientID withAmount:(NSNumber*) amount;
@end


typedef enum
{
    kIngredientSelectCellStateCenter,
    kIngredientSelectCellStateRight
}IngredientSelectCellCellState;


@interface TodayIngredientSelectCellScrollView : UIScrollView <UIGestureRecognizerDelegate>

@end


@interface TodayIngredientSelectCell : SKSTableViewCell
@property (nonatomic, strong) id<EatsTodayIngredientUpdateDelegate> delegate;
@property (nonatomic, strong) IngredientSubGroup* mainIngredient;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier tableview:(UITableView *)tableview;
- (void)updateCellWithIngredient:(IngredientSubGroup*)ingredient withAmount:(int)amount update:(BOOL)fUpdate;



@end
