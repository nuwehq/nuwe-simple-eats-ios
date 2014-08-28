//
//  NWViewController.m
//  NuWeDevApp-Uinversal
//
//  Created by Ahmed Ghalab on 8/28/14.
//  Copyright (c) 2014 Nutribu Limited. All rights reserved.
//

#import "NWViewController.h"
#import <NuWe/Nuwe.h>

@interface NWViewController ()

@end

@implementation NWViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)lunchNuWe:(id)sender
{
    [[NuWeManager sharedManager] startServiceWithAuthenticationKey:@"65801fd1-3d94-4599-9d06-475b5ee01e28"];
    [[NuWeManager sharedManager] showIngredientsSubmissionViewAboveViewController:self];
}

@end
