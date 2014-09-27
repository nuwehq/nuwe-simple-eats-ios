//
//  EatsTodayViewController.m
//  NuWe
//
//  Created by Ahmed Ghalab on 9/23/14.
//  Copyright (c) 2014 Nutribu Limited. All rights reserved.
//

#import "EatsTodayViewController.h"

// Model..
#import "Data.h"
#import "Common.h"

// View..
#import "TodayIngredientSelectCell.h"


@interface EatsTodayViewController ()  <UITableViewDelegate, UITableViewDataSource, EatsTodayIngredientUpdateDelegate>

@property (nonatomic, weak) IBOutlet UILabel* lblTitle;
@property (nonatomic, weak) IBOutlet UITableView* tableView;
@property (nonatomic, weak) IBOutlet UIButton* btnBack;
@property (nonatomic, weak) IBOutlet UIButton* btnUpdate;

@end

@implementation EatsTodayViewController

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
    

    _lblTitle.text = @"Today's eats";
    
    [self.btnBack setImage:[UIImage imageNamed:@"NuWe.bundle/btn_nav_back"] forState:UIControlStateNormal];
    
    if (IS_IOS7)
    {
        if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad && !IS_IPHONE_5)
            _tableView.frame = CGRectMake(0, 70, 320, 480 - 78);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)onBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableView delegate

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.ingredientsCategoriezedDictionary count] +1; // +1 to set a table footer
}


-(NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return (section == [[self.ingredientsCategoriezedDictionary allKeys] count]) ? nil : [[self.ingredientsCategoriezedDictionary allKeys] objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray* sections = [self.ingredientsCategoriezedDictionary allKeys];
    return (section == [sections count]) ? 5 : [[self.ingredientsCategoriezedDictionary objectForKey:[sections objectAtIndex:section]] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        return 51;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray* sections = [self.ingredientsCategoriezedDictionary allKeys];
    if (indexPath.section == [sections count])
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
    
    static NSString* todayIngredientSelectCellIdentifier = @"todayIngredientSelectCellIdentifier";
    TodayIngredientSelectCell* cell = [tableView dequeueReusableCellWithIdentifier:todayIngredientSelectCellIdentifier];
    
    if (cell == nil)
    {
        cell = [[TodayIngredientSelectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:todayIngredientSelectCellIdentifier tableview:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
    
    NSArray* selectedSubIngredientsInCategory = [self.ingredientsCategoriezedDictionary objectForKey:[sections objectAtIndex:indexPath.section]];
    IngredientSubGroup* subGroup = [selectedSubIngredientsInCategory objectAtIndex:indexPath.row];
    
    NSNumber* numberAmount = (NSNumber*)[self.ingredientsAmountsDictionary objectForKey:subGroup.szId];
    [cell updateCellWithIngredient:subGroup withAmount:numberAmount.intValue update:NO];
    cell.clipsToBounds = YES;
    return cell;
}

#pragma mark - EatsTodayIngredientUpdateDelegate Methods
- (void)updateIngredientWithId:(NSString*)ingredientID withAmount:(NSNumber*) amount
{
    [self.ingredientsAmountsDictionary setObject:amount forKey:ingredientID];
    [self.btnUpdate setEnabled:YES];
}

#pragma mark - IBActions Methods
- (IBAction)updateEatsToday:(id)sender
{
    [self showLoadingMessage:@"Updating with new amounts..."];
    [self performSelector:@selector(updateTodayIngredients) withObject:nil afterDelay:0.1];
}

- (void)updateTodayIngredients
{
    HTTPClient* httpClient = [HTTPClient sharedClient];
    httpClient.delegate = self;
    
    NSMutableArray* ingredientsList = [NSMutableArray array];
    for (NSArray* subListIngredients in [self.ingredientsCategoriezedDictionary allValues]) {
        [ingredientsList addObjectsFromArray:subListIngredients];
    }
    
    [httpClient updateTodaysEat:self.lastTodaysEatID withIngredients:ingredientsList withAmounts:self.ingredientsAmountsDictionary];
}


- (void)didEatIngredientsSuccess
{
    [self hideLoadingMessage];
    [self showCoverViewWithMessage:@"today's ingredient amounts are updated successfuly" withDelay:1.5];
    [NSTimer scheduledTimerWithTimeInterval:1.6 target:self selector:@selector(onBack:) userInfo:nil repeats:NO];
}

- (void)didEatIngredientsFailure:(NSString *)szError
{
    [self hideLoadingMessage];
    [self showCoverViewWithMessage:@"Error happens while updating today's ingredient amounts! Please check your internet connection, try again later" withDelay:2.5];
}


@end
