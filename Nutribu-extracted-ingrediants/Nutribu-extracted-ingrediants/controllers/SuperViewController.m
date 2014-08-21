//
//  SuperViewController.m
//  Nutribu
//
//  Created by ChangShiYuan on 4/5/14.
//  Copyright (c) 2014 Chang. All rights reserved.
//

#import "SuperViewController.h"
// Model ..
#import "Data.h"
#import "AFNetworking.h"
#import "HTTPClient.h"
#import "Common.h"


@interface SuperViewController ()

@end

@implementation SuperViewController 

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
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.f)
        return;
        
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - message handler

@end
