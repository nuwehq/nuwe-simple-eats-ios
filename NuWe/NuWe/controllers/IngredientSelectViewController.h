//
//  IngredientSelectViewController.h
//  Nutribu
//
//  Created by ChangShiYuan on 5/29/14.
//  Copyright (c) 2014 Chang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IngredientSelectCell.h"
#import "SuperViewController.h"

@interface IngredientSelectViewController : SuperViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) IBOutlet UILabel* lblTitle;
@property (nonatomic, weak) IBOutlet UITableView* tableView;
@property (nonatomic, weak) IBOutlet UIButton* btnBack;

@property (nonatomic, assign) NSInteger nTopGroupIndex;

- (IBAction)onBack;

@end
