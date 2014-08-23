//
//  SuperViewController.h
//  Nutribu
//
//  Created by ChangShiYuan on 4/5/14.
//  Copyright (c) 2014 Chang. All rights reserved.
//

#import <UIKit/UIKit.h>

// Model ..
#import "HTTPClient.h"

@interface SuperViewController : UIViewController <HTTPClientDelegate>


- (IBAction)onBack:(id)sender;

@end
