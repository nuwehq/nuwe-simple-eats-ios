//
//  HelperSuperViewController.m
//  Nutribu
//
//  Created by ChangShiYuan on 6/19/14.
//  Copyright (c) 2014 Chang. All rights reserved.
//

#import "HelperSuperViewController.h"
// Model ..
#import "Data.h"
#import "Common.h"

@interface HelperSuperViewController ()

@end

@implementation HelperSuperViewController

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

    [self.tipInsideTriangleImageView setImage:[UIImage imageNamed:@"NuWe.bundle/icon_help_triangle_inverse"]];
    
    [_scrollView setContentSize:CGSizeMake(_pageControl.numberOfPages * 320, _scrollView.frame.size.height)];
    
    if (!IS_IPHONE_5)
    {
        CGRect frame;
        frame = _pageControl.frame;
        frame.origin.y = 423;
        _pageControl.frame = frame;
        
        frame = _btnNoShow.frame;
        frame.origin.y = 450;
        _btnNoShow.frame = frame;

        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - mesage handler

- (IBAction)onClose:(id)sender
{
    [self hideHelper];
}

- (IBAction)onNoShow:(id)sender
{
    
}

- (IBAction)onPageControlChanged:(id)sender
{
    [_scrollView setContentOffset:CGPointMake(_pageControl.currentPage * 320, 0) animated:YES];
    
}

#pragma mark - help function

- (void)hideHelper
{
    CGRect frame = self.view.frame;
    [UIView animateWithDuration:POPUP_HELPER_DURATION animations:^{
        self.view.frame = CGRectMake(0, frame.size.height, frame.size.width, frame.size.height);
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }];
}

#pragma mark - scrollview delegate

- (IBAction)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _pageControl.currentPage = _scrollView.contentOffset.x / 320;
}


@end
