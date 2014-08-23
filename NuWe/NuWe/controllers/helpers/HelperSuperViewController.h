//
//  HelperSuperViewController.h
//  Nutribu
//
//  Created by ChangShiYuan on 6/19/14.
//  Copyright (c) 2014 Chang. All rights reserved.
//

#import "SuperViewController.h"

@interface HelperSuperViewController : SuperViewController<UIScrollViewDelegate>

@property (nonatomic, weak) IBOutlet UIScrollView* scrollView;
@property (nonatomic, weak) IBOutlet UIPageControl* pageControl;
@property (nonatomic, weak) IBOutlet UIButton* btnNoShow;

@property (nonatomic, weak) IBOutlet UIImageView* tipInsideTriangleImageView;

- (IBAction)onClose:(id)sender;
- (IBAction)onNoShow:(id)sender;
- (IBAction)onPageControlChanged:(id)sender;

- (void)hideHelper;
@end
