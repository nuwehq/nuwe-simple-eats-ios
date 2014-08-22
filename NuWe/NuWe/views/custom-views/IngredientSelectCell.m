//
//  IngredientSelectTableViewCell.m
//  Nutribu
//
//  Created by ChangShiYuan on 5/29/14.
//  Copyright (c) 2014 Chang. All rights reserved.
//

#import "IngredientSelectCell.h"
#import <QuartzCore/QuartzCore.h>
#import "Data.h"

#define kIngredientSelectCellRightViewWidth 120

@implementation IngredientSelectCellScrollView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    // Find out if the user is actively scrolling the tableView of which this is a member.
    // If they are, return NO, and don't let the gesture recognizers work simultaneously.
    //
    // This works very well in maintaining user expectations while still allowing for the user to
    // scroll the cell sideways when that is their true intent.
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        
        // Find the current scrolling velocity in that view, in the Y direction.
        CGFloat yVelocity = [(UIPanGestureRecognizer*)gestureRecognizer velocityInView:gestureRecognizer.view].y;
        
        // Return YES iff the user is not actively scrolling up.
        return fabs(yVelocity) <= 0.25;
        
    }
    return YES;
}

@end

@interface IngredientSelectCell ()
{
    CGFloat _height;
    IngredientSelectCellCellState _cellState;
}

@property (nonatomic, weak) UITableView* tableview;
@property (nonatomic, strong) IngredientSelectCellScrollView *cellScrollView;
@property (nonatomic, strong) UIView *viewCenter;
@property (nonatomic, strong) UIView *viewRight;


@end

@implementation IngredientSelectCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier tableview:(UITableView *)tableview;
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _height = tableview.rowHeight - 1;
        self.tableview = tableview;
        self.highlighted = NO;
        [self initializer];
    }
    
    return self;
}


- (void)initializer
{
    UIView* viewBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), _height + 1)];
    viewBackground.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:viewBackground];
    
    UIView* viewSeperator = [[UIView alloc] initWithFrame:CGRectMake(0, _height, CGRectGetWidth(self.bounds), 1)];
    viewSeperator.backgroundColor = gData.colorGreen;
    [viewBackground addSubview:viewSeperator];
    
    self.cellScrollView = [[IngredientSelectCellScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), _height)];
    _cellScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.bounds) + kIngredientSelectCellRightViewWidth,  _height);
    _cellScrollView.delegate = self;
    _cellScrollView.showsHorizontalScrollIndicator = NO;
    _cellScrollView.scrollsToTop = NO;
    _cellScrollView.scrollEnabled = YES;
    [viewBackground addSubview:_cellScrollView];
    
//    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onHandleTap:)];
//    [_cellScrollView addGestureRecognizer:_tapGestureRecognizer];
    self.viewRight = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.bounds), 0, kIngredientSelectCellRightViewWidth, _height)];
    _viewRight.backgroundColor = [UIColor whiteColor];
    [_cellScrollView addSubview:_viewRight];
    
    
    self.btnP = [[UIButton alloc] initWithFrame:CGRectMake(4, 9, 32, 32)];
    _btnP.tag = 53;
    _btnP.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_btnP setBackgroundImage:[UIImage imageNamed:@"NuWe.bundle/btn_round_white_pencil_32.png"] forState:UIControlStateNormal];
    [_btnP setBackgroundImage:[UIImage imageNamed:@"NuWe.bundle/btn_round_green_pencil_32.png"] forState:UIControlStateSelected];
    [_btnP addTarget:self action:@selector(onPencil:) forControlEvents:UIControlEventTouchUpInside];
    [_viewRight addSubview:_btnP];
    
    UIView* viewAmount = [[UIView alloc] initWithFrame:CGRectMake(46, 9, 40, 32)];
    viewAmount.backgroundColor = [UIColor clearColor];
    viewAmount.layer.borderWidth = 1;
    viewAmount.layer.borderColor = gData.colorGreen.CGColor;
    [_viewRight addSubview:viewAmount];
    
    self.textAmount = [[UITextField alloc] initWithFrame:CGRectMake(48, 13, 36, 24)];
    _textAmount.userInteractionEnabled = NO;
    _textAmount.delegate = self;
    _textAmount.font = [UIFont systemFontOfSize:16.f];
    _textAmount.backgroundColor = [UIColor whiteColor];
    _textAmount.textColor = gData.colorGreen;
    _textAmount.textAlignment = NSTextAlignmentRight;
    _textAmount.returnKeyType = UIReturnKeyDone;
    _textAmount.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    [_textAmount addTarget:self action:@selector(onTextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_viewRight addSubview:_textAmount];
    
    UILabel* lblUnit = [[UILabel alloc] initWithFrame:CGRectMake(88, 9, 23, 32)];
    lblUnit.text = @"g";
    lblUnit.font = [UIFont systemFontOfSize:16];
    lblUnit.textColor = gData.colorGreen;
    lblUnit.backgroundColor = [UIColor clearColor];
    [_viewRight addSubview:lblUnit];
    
    
    self.viewCenter = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), _height)];
    _viewCenter.backgroundColor = [UIColor whiteColor];
    [_cellScrollView addSubview:_viewCenter];

    
    self.lblName= [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 190, _height)];
    _lblName.font = [UIFont systemFontOfSize:16];
    _lblName.textColor = gData.colorGreen;
    _lblName.backgroundColor = [UIColor clearColor];
    [_viewCenter addSubview:_lblName];
    
    
    UIButton* btnS = [[UIButton alloc] initWithFrame:CGRectMake(204, 9, 32, 32)];
    btnS.tag = 50;
    btnS.titleLabel.font = [UIFont systemFontOfSize:16];
    btnS.titleLabel.textAlignment = NSTextAlignmentCenter;
    [btnS setTitle:@"S" forState:UIControlStateNormal];
    [btnS setTitleColor:gData.colorGreen forState:UIControlStateNormal];
    [btnS setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [btnS setBackgroundImage:[UIImage imageNamed:@"NuWe.bundle/btn_round_white_32.png"] forState:UIControlStateNormal];
    [btnS setBackgroundImage:[UIImage imageNamed:@"NuWe.bundle/btn_round_green_32.png"] forState:UIControlStateSelected];
    [btnS addTarget:self action:@selector(onSelectLevel:) forControlEvents:UIControlEventTouchUpInside];
    [_viewCenter addSubview:btnS];

    
    UIButton* btnM = [[UIButton alloc] initWithFrame:CGRectMake(244, 9, 32, 32)];
    btnM.tag = 51;
    btnM.titleLabel.font = [UIFont systemFontOfSize:16];
    btnM.titleLabel.textAlignment = NSTextAlignmentCenter;
    [btnM setTitle:@"M" forState:UIControlStateNormal];
    [btnM setTitleColor:gData.colorGreen forState:UIControlStateNormal];
    [btnM setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [btnM setBackgroundImage:[UIImage imageNamed:@"NuWe.bundle/btn_round_white_32.png"] forState:UIControlStateNormal];
    [btnM setBackgroundImage:[UIImage imageNamed:@"NuWe.bundle/btn_round_green_32.png"] forState:UIControlStateSelected];
    [btnM addTarget:self action:@selector(onSelectLevel:) forControlEvents:UIControlEventTouchUpInside];
    [_viewCenter addSubview:btnM];
    
    UIButton* btnL = [[UIButton alloc] initWithFrame:CGRectMake(284, 9, 32, 32)];
    btnL.tag = 52;
    btnL.titleLabel.font = [UIFont systemFontOfSize:16];
    btnL.titleLabel.textAlignment = NSTextAlignmentCenter;
    [btnL setTitle:@"L" forState:UIControlStateNormal];
    [btnL setTitleColor:gData.colorGreen forState:UIControlStateNormal];
    [btnL setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [btnL setBackgroundImage:[UIImage imageNamed:@"NuWe.bundle/btn_round_white_32.png"] forState:UIControlStateNormal];
    [btnL setBackgroundImage:[UIImage imageNamed:@"NuWe.bundle/btn_round_green_32.png"] forState:UIControlStateSelected];
    [btnL addTarget:self action:@selector(onSelectLevel:) forControlEvents:UIControlEventTouchUpInside];
    [_viewCenter addSubview:btnL];
    
}


#pragma mark - message hanlder

- (void)onSelectLevel:(UIButton*)button
{
    if (button.selected == YES)
    {
        button.selected = NO;
        _textAmount.text = @"";
        [gData.aIngredientSubGroupAmount replaceObjectAtIndex:_nCellIndex withObject:[NSNumber numberWithInt:0]];
    }
    else
    {
        for (int i = 0; i < 3; i++)
        {
            NSInteger index = 50 + i;
            UIButton* btn = (UIButton*)[self viewWithTag:index];
            if (index == button.tag)
            {
                btn.selected = YES;
                int nLevel = (int)button.tag - 50 + 1;
                
                int nAmount = (int)[gData getDefaultIngrededientAmount:nLevel index:(int)_nCellIndex];
                _textAmount.text = [NSString stringWithFormat:@"%d", nAmount];
                [gData.aIngredientSubGroupAmount replaceObjectAtIndex:_nCellIndex withObject:[NSNumber numberWithInt:nAmount]];
            }
            else
                btn.selected = NO;
        }
    }
}

- (void)onPencil:(UIButton*)button
{
    if (button.selected == NO)
    {
        _textAmount.userInteractionEnabled = YES;
        [_textAmount becomeFirstResponder];
    }
    else
    {
        _textAmount.userInteractionEnabled = NO;
        [_textAmount resignFirstResponder];
        
        [self hideUtilityButtonsAnimated:YES];
    }
    
    button.selected = !button.selected;
}

#pragma  mark text field function

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self hideUtilityButtonsAnimated:YES];
    return YES;
}



- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (!string.length) // allow backspace
    {
        return YES;
    }
    
    
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    NSCharacterSet *myCharSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    for (int i = 0; i < [string length]; i++)
    {
        unichar c = [string characterAtIndex:i];
        if ([myCharSet characterIsMember:c])
        {
            if (newLength <= 3)
            {
                return YES;
            }
        }
    }
    
    return NO;
}

- (void)onTextFieldDidChange:(UITextField*)textField
{
    int nAmount = [textField.text intValue];
    [self updateLevel:nAmount update:YES];
}

- (void)updateLevel:(int)nAmount update:(BOOL)fUpdate
{
    
    int nLevel = [gData getIngredientLevelFromAmount:nAmount index:(int)_nCellIndex];
    
    if (nLevel == 0)
    {
        _textAmount.text = @"";
        
        for (int i = 0; i < 3; i++)
        {
            UIButton* button = (UIButton*)[self viewWithTag:50 + i];
            button.selected = NO;
        }
        
    }
    else
    {
        for (int i = 0; i < 3; i++)
        {
            UIButton* button = (UIButton*)[self viewWithTag:50 + i];
            button.selected = NO;
            
            if (i + 1 == nLevel)
            {
                _textAmount.text = [NSString stringWithFormat:@"%d", nAmount];
                button.selected = YES;
            }
        }
    }
    
    if (fUpdate)
    {
        [gData.aIngredientSubGroupAmount replaceObjectAtIndex:_nCellIndex withObject:[NSNumber numberWithInt:nAmount]];
    }
    
}


#pragma mark UIScrollView helpers

- (void)scrollToRight:(inout CGPoint *)targetContentOffset
{
    targetContentOffset->x = kIngredientSelectCellRightViewWidth;
    _cellState = kIngredientSelectCellStateRight;
    
    
//    if ([_delegate respondsToSelector:@selector(swipeableTableViewCell:scrollingToState:)])
//    {
//        [_delegate swipeableTableViewCell:self scrollingToState:kCellStateRight];
//    }
}

- (void)scrollToCenter:(inout CGPoint *)targetContentOffset
{
    targetContentOffset->x = 0;
    _cellState = kIngredientSelectCellStateCenter;
    
    
//    if ([_delegate respondsToSelector:@selector(swipeableTableViewCell:scrollingToState:)])
//    {
//        [_delegate swipeableTableViewCell:self scrollingToState:kCellStateCenter];
//    }
}

- (void)hideUtilityButtonsAnimated:(BOOL)animated {
    // Scroll back to center
    
    // Force the scroll back to run on the main thread because of weird scroll view bugs
    dispatch_async(dispatch_get_main_queue(), ^{
        [_cellScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    });
    
    _cellState = kIngredientSelectCellStateCenter;
    
//    if ([_delegate respondsToSelector:@selector(swipeableTableViewCell:scrollingToState:)]) {
//        [_delegate swipeableTableViewCell:self scrollingToState:kCellStateCenter];
//    }
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    switch (_cellState)
    {
        case kIngredientSelectCellStateCenter:
        {
            if (velocity.x >= 0.5f)
            {
                [self scrollToRight:targetContentOffset];
            }
            else if (velocity.x <= -0.5f)
            {
                //[self scr:targetContentOffset];
            }
            else
            {
                if (targetContentOffset->x > kIngredientSelectCellRightViewWidth / 2)
                    [self scrollToRight:targetContentOffset];
                else
                    [self scrollToCenter:targetContentOffset];
            }
        }
          
        case kIngredientSelectCellStateRight:
        {
            if (velocity.x >= 0.5f)
            {
                // No-op
            }
            else if (velocity.x <= -0.5f)
            {
                [self scrollToCenter:targetContentOffset];
            }
            else
            {
                if (targetContentOffset->x > kIngredientSelectCellRightViewWidth / 2)
                    [self scrollToRight:targetContentOffset];
                else
                    [self scrollToCenter:targetContentOffset];
            }
            break;
        }
        default:
            break;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.tableview.scrollEnabled = NO;
    
    _viewRight.frame = CGRectMake(scrollView.contentOffset.x + (CGRectGetWidth(self.bounds) - kIngredientSelectCellRightViewWidth), 0, kIngredientSelectCellRightViewWidth, _height);
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
     self.tableview.scrollEnabled = YES;
    
    if (_cellState == kIngredientSelectCellStateCenter)
    {
        _btnP.selected = NO;
        _textAmount.userInteractionEnabled = NO;
        [self.textAmount resignFirstResponder];
    }

}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    self.tableview.scrollEnabled = YES;
    
    if (_cellState == kIngredientSelectCellStateCenter)
    {
        _btnP.selected = NO;
         _textAmount.userInteractionEnabled = NO;
        [self.textAmount resignFirstResponder];
    }
}


@end
