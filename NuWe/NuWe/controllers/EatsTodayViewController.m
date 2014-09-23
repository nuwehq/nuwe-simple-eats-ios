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
#import "IngredientSelectCell.h"


@interface EatsTodayViewController ()  <UITableViewDelegate, UITableViewDataSource>
{
    NSInteger _nCount;
    NSInteger _nRealCount;
    NSInteger _nSubGroupStartIndex;
}
@property (nonatomic, weak) IBOutlet UILabel* lblTitle;
@property (nonatomic, weak) IBOutlet UITableView* tableView;
@property (nonatomic, weak) IBOutlet UIButton* btnBack;

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
    
    IngredientTopGroup* topGroup = [gData.aIngredientTopGroups objectAtIndex:_nTopGroupIndex];
    _lblTitle.text = topGroup.szName;
    
    NSNumber* number = (NSNumber*)[gData.aIngredientSubGroupStartIndex objectAtIndex:_nTopGroupIndex];
    _nSubGroupStartIndex = [number integerValue];
    
    [self.btnBack setImage:[UIImage imageNamed:@"NuWe.bundle/btn_nav_back"] forState:UIControlStateNormal];
    
    _nRealCount = topGroup.nSubGroupNum;
    _nCount = _nRealCount + 5;
    
    
    
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


-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;//[gData.aIngredientTopGroups count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}


@end
