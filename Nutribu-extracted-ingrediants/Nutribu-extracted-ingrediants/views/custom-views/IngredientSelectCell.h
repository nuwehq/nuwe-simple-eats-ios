//
//  IngredientSelectTableViewCell.h
//  Nutribu
//
//  Created by ChangShiYuan on 5/29/14.
//  Copyright (c) 2014 Chang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKSTableViewCell.h"

typedef enum
{
    kIngredientSelectCellStateCenter,
    kIngredientSelectCellStateRight
}IngredientSelectCellCellState;


@interface IngredientSelectCellScrollView : UIScrollView <UIGestureRecognizerDelegate>

@end


@interface IngredientSelectCell : SKSTableViewCell <UIScrollViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UILabel* lblName;
@property (nonatomic, strong) UITextField *textAmount;
@property (nonatomic, strong) UIButton *btnP;
@property (nonatomic, assign) NSInteger nCellIndex;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier tableview:(UITableView *)tableview;
- (void)updateLevel:(int)nAmount update:(BOOL)fUpdate;



@end
