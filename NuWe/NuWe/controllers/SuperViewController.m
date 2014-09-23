//
//  SuperViewController.m
//  Nutribu
//
//  Created by ChangShiYuan on 4/5/14.
//  Copyright (c) 2014 Chang. All rights reserved.
//

#import "SuperViewController.h"

// Controllers ..
#import "MBProgressHUD.h"

// Model ..
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
    
    if (IS_IOS7)
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


-(void) onBack:(id)sender
{

}
#pragma mark - message handler
- (void) showCoverViewWithMessage:(NSString *) message withDelay:(NSTimeInterval)delay
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
	
	// Configure for text only and offset down
	hud.mode = MBProgressHUDModeText;
	hud.detailsLabelText = message;
	hud.margin = 10.f;
	hud.yOffset = 150.f;
	hud.removeFromSuperViewOnHide = YES;
	[hud hide:YES afterDelay:delay];
}

-(void)showLoadingMessage:(NSString *)loadingMsg
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
	hud.labelText = loadingMsg;
	hud.removeFromSuperViewOnHide = YES;
}

-(void)hideLoadingMessage
{
    [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:NO];
}

@end
