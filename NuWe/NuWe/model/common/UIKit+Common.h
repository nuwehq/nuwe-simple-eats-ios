//
//  UIKit+GL.m
//
//  Created by Chang on 10/7/13.
//  Copyright (c) 2013 Pernod. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Common)
+ (UIColor*)colorWithHex:(NSUInteger)hex;
@end

@interface UIView (Common)

- (void)showViewWithAnimation:(NSTimeInterval)interval;
- (void)hideViewWithAnimation:(NSTimeInterval)interval;
- (UIImage*) imageFromView;

@end

@interface UIViewController (Common)
@end

@interface UIFont (Common)
@end

@interface NSObject (Common)
- (void)delayBy:(CGFloat)delay code:(dispatch_block_t)block;
- (void)alertWithTitle:(NSString *)title message:(NSString *)message;
- (void)trackCategory:(NSString *)category action:(NSString *)action;
- (void)trackCategory:(NSString *)category action:(NSString *)action label:(NSString *)label;
@end

@interface NSDate (Common)

- (NSString*)ago;
- (BOOL)isBeforeDate:(NSDate *)date;
- (NSTimeInterval)timeIntervalSinceMidnightToday;

- (NSString*)dateString;
- (NSString*)monthString;
- (NSString*)weekdayString;
- (NSString*)timeString;

- (NSInteger)year;
- (NSInteger)month;
- (NSInteger)day;
- (NSInteger)weekday;

- (NSInteger)yearsSinceDate:(NSDate*)date;
- (NSInteger)monthsSinceDate:(NSDate*)date;
- (NSInteger)daysSinceDate:(NSDate*)date;
- (NSInteger)weeksSinceDate:(NSDate*)date;

@end


@interface NSString (Common)
- (BOOL)checkEmailValidity;
@end
