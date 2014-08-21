//
//  IngredientListViewController.h
//  Nutribu
//
//  Created by ChangShiYuan on 5/28/14.
//  Copyright (c) 2014 Chang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IngredientListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView* tableView;
@property (nonatomic, weak) IBOutlet UIButton* btnNext;

- (IBAction)onClose;
- (IBAction)onNext;


@end
