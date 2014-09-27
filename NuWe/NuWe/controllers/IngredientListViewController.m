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
#import "EatsTodayViewController.h"
#import "HelperIngredientGroupViewController.h"

// Views ..
#import "MBProgressHUD.h"
#import "UIKit+AFNetworking.h"

// Model ..
#import "Data.h"
#import "AFNetworking.h"
#import "HTTPClient.h"
#import "Common.h"

@interface IngredientListViewController ()

- (void)loadTodaysIngredients;
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
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:NWUserSavedNoGroupIngrediantsHelp] || ![[[NSUserDefaults standardUserDefaults] objectForKey:NWUserSavedNoGroupIngrediantsHelp] boolValue])
    {
        [self performSelector:@selector(showHelper) withObject:nil afterDelay:0.1];
    }

//    [self.btnNext setImage:[UIImage imageNamed:@"NuWe.bundle/btn_nav_next"] forState:UIControlStateNormal];
    [self.btnDismiss setImage:[UIImage imageNamed:@"NuWe.bundle/btn_nav_x"] forState:UIControlStateNormal];
    
    if (IS_IOS7)
    {
        if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad && !IS_IPHONE_5)
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
        int nIndex = (int)[numberSelected integerValue];
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
    [httpClient eatIngredientsWithConsideringUpdatingLastEat];
}



#pragma mark - UITableView delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [gData.aIngredientTopGroups count] + 1; // +1 For Tracking Today's Eats
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 51;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ingredientListCellIdentifier" forIndexPath:indexPath];

    UIImageView* imageview = (UIImageView*)[cell viewWithTag:1];
    [imageview setBackgroundColor:[UIColor clearColor]];
    
    UILabel* label = (UILabel*)[cell viewWithTag:2];
    UILabel* lblNumber = (UILabel* )[cell viewWithTag:3];
    
    if (indexPath.row == 0) {
        
        [imageview setImage:[UIImage imageNamed:@"NuWe.bundle/btn_round_white_pencil_32"]];
        label.text = @"Today's eat";
        lblNumber.hidden = YES;
        lblNumber.text = @"";
        
    }else
    {
        int nTopGroupIndex = (int)indexPath.row - 1;
        IngredientTopGroup* topGroup = [gData.aIngredientTopGroups objectAtIndex:nTopGroupIndex];
        
        [imageview setImageWithURL:[NSURL URLWithString:topGroup.szIconPathTiny] placeholderImage:nil];
        label.text = topGroup.szName;
        
        NSNumber* number = (NSNumber*)[gData.aIngredientSubGroupStartIndex objectAtIndex:nTopGroupIndex];
        int nStartIndex = (int)[number integerValue];
        
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

    }
    
    return cell;
    
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if ((int)[indexPath row] == 0) {
        
        [self showLoadingMessage:@"Loading Today's Eats..."];
        [self performSelector:@selector(loadTodaysIngredients) withObject:nil afterDelay:0.1];
        
        
        return;
    }
    IngredientSelectViewController* controller = [self.storyboard instantiateViewControllerWithIdentifier:@"ingredientSelectController"];
    int nTopGroupIndex = (int)[indexPath row] - 1 ; //  - 1 beacuase of Today's eats loading cell
    controller.nTopGroupIndex = nTopGroupIndex;
    
    if ([gData.aIngredientSubGroupStartIndex objectAtIndex:nTopGroupIndex] != [NSNull null])
        [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - helper function

- (void)showHelper
{
    HelperIngredientGroupViewController* controller = [self.storyboard instantiateViewControllerWithIdentifier:@"helperIngredientGroupController"];
    [self addChildViewController:controller];
    [self.view addSubview:controller.view];
    
    CGRect frame = self.view.bounds;
    controller.view.frame = CGRectMake(0, frame.size.height, frame.size.width, frame.size.height);
    [UIView animateWithDuration:POPUP_HELPER_DURATION animations:^{
        controller.view.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    }];
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
    
    _btnNext.enabled = NO;
    [self.tableView reloadData];
    [self.tableView setNeedsDisplay];
}

-(void) dismissFrameworkView
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
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
    [self showCoverViewWithMessage:@"Your meal is synced successfuly" withDelay:1.5];
    [NSTimer scheduledTimerWithTimeInterval:1.6 target:self selector:@selector(dismissFrameworkView) userInfo:nil repeats:NO];
}

- (void)didEatIngredientsFailure:(NSString *)szError
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self showCoverViewWithMessage:@"Error happens while syncing meal! Please check your internet connection, try again later" withDelay:2.5];
}


- (void)didLoadTodayEat:(NSString*)eatID withIngredientsSuccess:(NSDictionary*)ingredientsCategoriezed withAmounts:(NSMutableDictionary*) amountsComponents
{
    [self hideLoadingMessage];
    NSLog(@"didLoadTodayIngredientsSuccess");
    
    if (!ingredientsCategoriezed || [ingredientsCategoriezed count] == 0 ) {
        [self showCoverViewWithMessage:@"There is no eats done today!" withDelay:2];
    }else
    {
        EatsTodayViewController* controller = [self.storyboard instantiateViewControllerWithIdentifier:@"eatsTodayController"];
        controller.lastTodaysEatID = eatID;
        controller.ingredientsCategoriezedDictionary = ingredientsCategoriezed;
        controller.ingredientsAmountsDictionary = amountsComponents;
        [self.navigationController pushViewController:controller animated:YES];
    }

    
}

- (void)didLoadTodayIngredientsFailure:(NSString*)szError
{
    [self hideLoadingMessage];
    [self showCoverViewWithMessage:@"Error happens while loading Today's eats! Please check your internet connection, try again later" withDelay:2.5];
}

- (void)loadTodaysIngredients
{
    HTTPClient* httpClient = [HTTPClient sharedClient];
    httpClient.delegate = self;
    [httpClient loadTodaysIngredients];
}


@end