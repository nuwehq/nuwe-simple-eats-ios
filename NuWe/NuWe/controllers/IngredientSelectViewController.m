//
//  IngredientSelectViewController.m
//  Nutribu
//
//  Created by ChangShiYuan on 5/29/14.
//  Copyright (c) 2014 Chang. All rights reserved.
//

#import "Data.h"
#import "Common.h"
#import "IngredientSelectViewController.h"
//#import "HelperIngredientSelectViewController.h"

@interface IngredientSelectViewController ()
{
    NSInteger _nCount;
    NSInteger _nRealCount;
    NSInteger _nSubGroupStartIndex;
}

@end

@implementation IngredientSelectViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
    IngredientTopGroup* topGroup = [gData.aIngredientTopGroups objectAtIndex:_nTopGroupIndex];
    _lblTitle.text = topGroup.szName;
    
    NSNumber* number = (NSNumber*)[gData.aIngredientSubGroupStartIndex objectAtIndex:_nTopGroupIndex];
    _nSubGroupStartIndex = [number integerValue];

    
    _nRealCount = topGroup.nSubGroupNum;
    _nCount = _nRealCount + 5;
    
    
    
    if (IS_IOS7)
    {
        if (!IS_IPHONE_5)
            _tableView.frame = CGRectMake(0, 70, 320, 480 - 78);
    }
    
//    if (gData.fDisableHelpForIngredientSelect == NO)
//    {
//        [self performSelector:@selector(showHelper) withObject:nil afterDelay:0.1];
//    }


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark message handler

- (IBAction)onBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableView delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _nCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 51;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = [indexPath row];
    
    if (index >= _nRealCount)
    {
        static NSString *nullCellIdentifier = @"nullCellIdentifier";
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:nullCellIdentifier];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nullCellIdentifier];
            cell.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
        
        return cell;
    }
    
    static NSString* ingredientSelectCellIdentifier = @"ingredientSelectCellIdentifier";
    
    IngredientSelectCell* cell = [tableView dequeueReusableCellWithIdentifier:ingredientSelectCellIdentifier];
    
    if (cell == nil)
    {
        cell = [[IngredientSelectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ingredientSelectCellIdentifier tableview:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    int nSubGroupIndex = (int)(_nSubGroupStartIndex + index);
    cell.nCellIndex = nSubGroupIndex;
    IngredientSubGroup* subGroup = [gData.aIngredientSubGroups objectAtIndex:nSubGroupIndex];
    cell.lblName.text = subGroup.szName;
    
    NSNumber* numberAmount = (NSNumber*)[gData.aIngredientSubGroupAmount objectAtIndex:nSubGroupIndex];
    [cell updateLevel:(int)numberAmount.integerValue update:NO];
    return cell;
}

#pragma mark - helper function

- (void)showHelper
{
//    HelperIngredientSelectViewController* controller = [self.storyboard instantiateViewControllerWithIdentifier:@"helperIngredientSelectController"];
//    [self addChildViewController:controller];
//    [self.view addSubview:controller.view];
//    
//    CGRect frame = self.view.bounds;
//    controller.view.frame = CGRectMake(0, frame.size.height, frame.size.width, frame.size.height);
//    [UIView animateWithDuration:POPUP_HELPER_DURATION animations:^{
//        controller.view.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
//    }];
    
}

@end
