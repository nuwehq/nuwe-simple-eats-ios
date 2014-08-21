//
//  IngredientListViewController.m
//  Nutribu
//
//  Created by ChangShiYuan on 5/28/14.
//  Copyright (c) 2014 Chang. All rights reserved.
//

#import "IngredientListViewController.h"

// Controllers ..
#import "IngredientSelectViewController.h"
//#import "HelperIngredientGroupViewController.h"

// Views ..
#import "MBProgressHUD.h"
#import "UIKit+AFNetworking.h"

// Model ..
#import "Data.h"
#import "AFNetworking.h"
#import "HTTPClient.h"
#import "Common.h"

@interface IngredientListViewController () <HTTPClientDelegate>

@end

@implementation IngredientListViewController

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
    
//    if (gData.fDisableHelpForIngredientList == NO)
//    {
//        [self performSelector:@selector(showHelper) withObject:nil afterDelay:0.1];
//    }
    
    if ([[UIDevice currentDevice].systemVersion floatValue] < 7.f)
    {
        for (UIView* view in self.view.subviews)
        {
            if (view.tag < 500)
                continue;
            
            CGRect frame;
            if (view.tag == 500)
            {//navigation bar
                frame = view.frame;
                frame.size.height = 50;
                view.frame = frame;
            }
            else
            {
                frame = view.frame;
                frame.origin.y -= 20;
                view.frame = frame;
            }
        }
    }
    
    if (IS_IOS7)
    {
        if (!IS_IPHONE_5)
            _tableView.frame = CGRectMake(0, 70, 320, 480 - 78);
    }
    
    
    [gData.aIngredientSubGroupAmount removeAllObjects];
    for (int i = 0; i < [gData.aIngredientSubGroups count]; i++)
    {
        [gData.aIngredientSubGroupAmount addObject:[NSNumber numberWithInteger:0]];
    }
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self performSelector:@selector(loadIngredients) withObject:nil afterDelay:0.1];
}

- (void)loadIngredients
{
    HTTPClient* httpClient = [HTTPClient sharedClient];
    httpClient.delegate = self;
    [httpClient loadIngredientGroup];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    int nSelectedGroupCount = 0;
    
    for (int i = 0; i < [gData.aIngredientSubGroupAmount count]; i++)
    {
        NSNumber* numberSelected = (NSNumber*)[gData.aIngredientSubGroupAmount objectAtIndex:i];
        int nIndex = [numberSelected integerValue];
        if (nIndex)
        {
            nSelectedGroupCount = 1;
            break;
        }
        
    }
    
    if (nSelectedGroupCount == 0)
        _btnNext.enabled = NO;
    else
        _btnNext.enabled = YES;
    
    [_tableView reloadData];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - message handler

- (IBAction)onClose
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onNext
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self performSelector:@selector(eatIngredients) withObject:nil afterDelay:0.1];
}

- (void)eatIngredients
{
    HTTPClient* httpClient = [HTTPClient sharedClient];
    httpClient.delegate = self;
    [httpClient eatIngredients];
    
}

- (void)previewMeal
{
//    HTTPClient* httpClient = [HTTPClient sharedClient];
//    httpClient.delegate = self;
//    [httpClient previewMeal];
    
    NSLog(@"preview Meal");
}

#pragma mark - UITableView delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [gData.aIngredientTopGroups count]; // + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 51;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ingredientListCellIdentifier" forIndexPath:indexPath];

    UIImageView* imageview = (UIImageView*)[cell viewWithTag:1];
    //imageview.tintColor = gData.colorGreen;
    
    UILabel* label = (UILabel*)[cell viewWithTag:2];

//    if (indexPath.row == 0)
//    {
//         imageview.image = [UIImage imageNamed:@"icon_scanner.png"];
//         label.text = @"Scanner";
//    }
//    else
//    {
        UILabel* lblNumber = (UILabel* )[cell viewWithTag:3];
        
        int nTopGroupIndex = indexPath.row;
        IngredientTopGroup* topGroup = [gData.aIngredientTopGroups objectAtIndex:nTopGroupIndex];
        
        [imageview setImageWithURL:[NSURL URLWithString:topGroup.szIconPathTiny]];
        label.text = topGroup.szName;

        NSNumber* number = (NSNumber*)[gData.aIngredientSubGroupStartIndex objectAtIndex:nTopGroupIndex];
        int nStartIndex = [number integerValue];
        
        int nSelectCount = 0;
        for (int i = 0; i < topGroup.nSubGroupNum; i++)
        {
            NSNumber* numberAmount = (NSNumber*)[gData.aIngredientSubGroupAmount objectAtIndex:nStartIndex + i];
            if (numberAmount.integerValue)
                nSelectCount++;
        }
       
        if (nSelectCount)
        {
            lblNumber.hidden = NO;
            lblNumber.text = [NSString stringWithFormat:@"%d", nSelectCount];
        }
        else
        {
            lblNumber.hidden = YES;
            lblNumber.text = @"";
        }
//    }
    
    return cell;
    
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if ([indexPath row] == 0)
//    {
//        ScannerViewController* controller = [self.storyboard instantiateViewControllerWithIdentifier:@"scannerController"];
//        
//        UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController:controller];
//        navController.navigationBarHidden = YES;
//        
//        [self presentViewController:navController animated:YES completion:nil];
//    }
//    else
//    {
        IngredientSelectViewController* controller = [self.storyboard instantiateViewControllerWithIdentifier:@"ingredientSelectController"];
       
        int nTopGroupIndex = [indexPath row]; // remove  - 1 as There is no scanner cell
        controller.nTopGroupIndex = nTopGroupIndex;
        
        if ([gData.aIngredientSubGroupStartIndex objectAtIndex:nTopGroupIndex] != [NSNull null])
            [self.navigationController pushViewController:controller animated:YES];
//    }
}

#pragma mark - helper function

- (void)showHelper
{
//    HelperIngredientGroupViewController* controller = [self.storyboard instantiateViewControllerWithIdentifier:@"helperIngredientGroupController"];
//    [self addChildViewController:controller];
//    [self.view addSubview:controller.view];
//    
//    CGRect frame = self.view.bounds;
//    controller.view.frame = CGRectMake(0, frame.size.height, frame.size.width, frame.size.height);
//    [UIView animateWithDuration:POPUP_HELPER_DURATION animations:^{
//        controller.view.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
//    }];
    
}

#pragma mark - httpClient delegate

- (void)didLoadIngredientsSuccess
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    [gData.aIngredientSubGroupAmount removeAllObjects];
    for (int i = 0; i < [gData.aIngredientSubGroups count]; i++)
    {
        [gData.aIngredientSubGroupAmount addObject:[NSNumber numberWithInteger:0]];
    }
    
    [self.tableView reloadData];
    [self.tableView setNeedsDisplay];
}

- (void)didLoadIngredientsFailure:(NSString *)szError
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Nutribu" message:szError delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] ;
    [alertView show];
}


#pragma mark - http client delegate

- (void)didEatIngredientsSuccess
{
    [self didLoadIngredientsSuccess];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)didEatIngredientsFailure:(NSString *)szError
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Nutribu" message:szError delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] ;
    [alertView show];
    
}

@end
