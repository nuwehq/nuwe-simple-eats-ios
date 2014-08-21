//
//  UIKit+GL.m
//
//  Created by Chang on 10/7/13.
//  Copyright (c) 2013 Pernod. All rights reserved.
//

#import "UIKit+Common.h"

const int kSecondsInMinute = 60;
const int kMinutesInHour = 60;
const int kHoursInDay = 24;
const int kDaysInWeek = 7;
const int kDaysInMonthAvg = 30;
const int kDaysInYear = 365;

const NSInteger kSecondsInDay = 60 * 60 * 24;

@implementation UIColor (Common)

+ (UIColor*)colorWithHex:(NSUInteger)hex
{
	CGFloat r = ((hex & 0xff0000) >> 16) / 255.0f;
	CGFloat g = ((hex & 0x00ff00) >> 8) / 255.0f;
	CGFloat b = (hex & 0x0000ff) / 255.0f;
	CGFloat a = ((hex & 0xff000000) >> 24) / 255.0f;
	return [UIColor colorWithRed:r green:g blue:b alpha:a];
}

@end

@implementation UIView (Common)

-(void)showViewWithAnimation:(NSTimeInterval)interval
{
    self.hidden = NO;
    self.alpha = 0;
    [UIView animateWithDuration:interval animations:^{
        self.alpha = 1;
    }];
}

-(void)hideViewWithAnimation:(NSTimeInterval)interval
{
    self.alpha = 1;
    [UIView animateWithDuration:interval animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

- (UIImage *) imageFromView
{
	UIGraphicsBeginImageContext(self.frame.size);
	[self.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return image;
}

@end

@implementation UIViewController (Common)


@end

@implementation UIFont (Common)


@end

@implementation NSObject (Common)

- (void)delayBy:(CGFloat)delay code:(dispatch_block_t)block
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * delay), dispatch_get_main_queue(), block);
}

- (void)alertWithTitle:(NSString *)title message:(NSString *)message{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(title, nil) message:NSLocalizedString(message,nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

- (void)trackCategory:(NSString *)category action:(NSString *)action
{
    [self trackCategory:category action:action label:nil];
}

- (void)trackCategory:(NSString *)category action:(NSString *)action label:(NSString *)label
{
//#ifndef INTERNAL_BUILD
//    [[GAI sharedInstance].defaultTracker trackEventWithCategory:category
//                                                     withAction:action
//                                                      withLabel:label
//                                                      withValue:nil];
//#endif
}


@end

@implementation NSDate (Common)

- (NSString *)ago
{
    NSDate *now = [NSDate date];
    if ([now isBeforeDate:self]) {
        return [self dateString];
    }
    NSTimeInterval ti = [now timeIntervalSinceDate:self];
    NSTimeInterval tiSinceMidnight = [self timeIntervalSinceMidnightToday];
    //    NSTimeInterval difference = ti - fabs(tiSinceMidnight);
    // any time today
    if(tiSinceMidnight > 0){ // happened today
        if (ti < kSecondsInMinute) {
            NSInteger secondsAgo = ti;
            if (secondsAgo > 1) {
                return [NSString stringWithFormat:NSLocalizedString(@"%ds", nil), (int)ti];
            }
            else {
                return NSLocalizedString(@"1s", nil);
            }
        }
        else if (ti < kSecondsInMinute * kMinutesInHour) {
            NSInteger minutesAgo = ti / kSecondsInMinute;
            if (minutesAgo > 1) {
                return [NSString stringWithFormat:NSLocalizedString(@"%dm", nil), minutesAgo];
            }
            else {
                return NSLocalizedString(@"1m", nil);
            }
        }
        else if (ti < kSecondsInMinute * kMinutesInHour * kHoursInDay) {
            NSInteger hourSeconds = kSecondsInMinute * kMinutesInHour;
            NSInteger hoursAgo = ti / hourSeconds;
            if (hoursAgo > 1) {
                return [NSString stringWithFormat:NSLocalizedString(@"%dh", nil), (int)(ti / hourSeconds)];
            }
            else {
                return NSLocalizedString(@"1h", nil);
            }
        }
    }
    // 00:00 - 23:59 yesterday
    else if(abs(tiSinceMidnight) < kSecondsInMinute * kMinutesInHour * kHoursInDay){
        return [NSString stringWithFormat:NSLocalizedString(@"1d", nil), [self timeString]];
    }
    // 1 week ago or more until 1 year
    else if (ti < kSecondsInMinute * kMinutesInHour * kHoursInDay * kDaysInYear) {
        NSInteger weekSeconds =  kSecondsInMinute * kMinutesInHour * kHoursInDay * kDaysInWeek;
        NSInteger weeksAgo = ti / weekSeconds;
        if (weeksAgo > 1) {
            return [NSString stringWithFormat:NSLocalizedString(@"%dw", nil), (int)weeksAgo];
        }
        else {
            return NSLocalizedString(@"1w", nil);
        }
    }
    // 1 year ago or more
    else {
        NSInteger yearSeconds = kSecondsInMinute * kMinutesInHour * kHoursInDay * kDaysInYear;
        NSInteger yearsAgo = ti / yearSeconds;
        if (yearsAgo > 1) {
            return [NSString stringWithFormat:NSLocalizedString(@"%dy", nil), (int)yearsAgo];
        }
        else {
            return NSLocalizedString(@"1y", nil);
        }
    }
    return nil;
}

- (NSString *)dateString
{
    static NSDateFormatter *dateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    });
    return [dateFormatter stringFromDate:self];
}

- (NSString*)monthString
{
    static NSDateFormatter *monthdayFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        monthdayFormatter = [[NSDateFormatter alloc] init];
        [monthdayFormatter setDateFormat:@"MMM"];
    });
    
    return [monthdayFormatter stringFromDate:self];
}

- (NSString *)weekdayString
{
    static NSDateFormatter *weekdayFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        weekdayFormatter = [[NSDateFormatter alloc] init];
        [weekdayFormatter setDateFormat:@"EEE"];
    });
    
    return [weekdayFormatter stringFromDate:self];
}

- (NSString *)timeString
{
    static NSDateFormatter *timeFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        timeFormatter = [[NSDateFormatter alloc] init];
        [timeFormatter setTimeStyle:NSDateFormatterShortStyle];
    });
    
    return [timeFormatter stringFromDate:self];
}

- (BOOL)isBeforeDate:(NSDate *)date
{
    return [self compare:date] == NSOrderedAscending;
}

- (NSTimeInterval)timeIntervalSinceMidnightToday
{
    NSCalendar *gregorian = [NSCalendar autoupdatingCurrentCalendar];
    [gregorian setTimeZone:[NSTimeZone defaultTimeZone]];
    
    //2. Get tomorrow's date
    NSDateComponents *offsetComponents = [gregorian components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:[NSDate date]];
    [offsetComponents setHour:0];
    [offsetComponents setMinute:0];
    [offsetComponents setSecond:0];
    NSDate *midnight = [gregorian dateFromComponents:offsetComponents];
    NSTimeInterval diff = [self timeIntervalSinceDate:midnight];
    return diff;
}

- (NSInteger)year
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSYearCalendarUnit fromDate:self];
    
    return [components year];
}

- (NSInteger)month
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSMonthCalendarUnit     fromDate:self];
    
    return [components month];
}

- (NSInteger)weekday
{
    NSDateComponents* comp = [[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:self];

    return [comp weekday];
}
- (NSInteger)day
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:self];
    
    return [components day];
}

- (NSInteger)yearsSinceDate:(NSDate*)date
{
    NSInteger years = 0;
    
    NSDate* fromDate;
    NSDate* toDate;
    
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    [calendar rangeOfUnit:NSYearCalendarUnit startDate:&fromDate interval:nil forDate:self];
        [calendar rangeOfUnit:NSYearCalendarUnit startDate:&toDate interval:nil forDate:date];
    
    NSDateComponents* components = [[NSCalendar currentCalendar]
                      components:NSYearCalendarUnit
                      fromDate:fromDate
                      toDate:toDate
                      options:0];
    

    years = abs((int)[components year]);
    
    return years;
}

- (NSInteger)monthsSinceDate:(NSDate*)date
{
    NSInteger months = 0;
    
    NSDate* fromDate;
    NSDate* toDate;
    
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    [calendar rangeOfUnit:NSMonthCalendarUnit startDate:&fromDate interval:nil forDate:self];
    [calendar rangeOfUnit:NSMonthCalendarUnit startDate:&toDate interval:nil forDate:date];
    
    NSDateComponents* components = [[NSCalendar currentCalendar]
                                    components:NSMonthCalendarUnit
                                    fromDate:fromDate
                                    toDate:toDate
                                    options:0];
    
    
    months = abs((int)[components month]);
    
    return months;
}

- (NSInteger)weeksSinceDate:(NSDate*)date
{
    NSInteger weeks = 0;
    
    NSDate* fromDate;
    NSDate* toDate;
    
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    [calendar rangeOfUnit:NSWeekCalendarUnit startDate:&fromDate interval:nil forDate:self];
    [calendar rangeOfUnit:NSWeekCalendarUnit startDate:&toDate interval:nil forDate:date];
    
    NSDateComponents* components = [[NSCalendar currentCalendar]
                                    components:NSWeekCalendarUnit
                                    fromDate:fromDate
                                    toDate:toDate
                                    options:0];
    
    
    weeks = abs((int)[components week]);
    
    return weeks;
}

- (NSInteger)daysSinceDate:(NSDate*)date
{
    NSInteger days = 0;
    
    NSDate* fromDate;
    NSDate* toDate;
    
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    [calendar rangeOfUnit:NSDayCalendarUnit startDate:&fromDate interval:nil forDate:self];
    [calendar rangeOfUnit:NSDayCalendarUnit startDate:&toDate interval:nil forDate:date];
    
    NSDateComponents* components = [[NSCalendar currentCalendar]
                                    components:NSDayCalendarUnit
                                    fromDate:fromDate
                                    toDate:toDate
                                    options:0];
    
    
    days = abs((int)[components day]);
    
    return days;
}

@end

@implementation NSString (GL)

- (BOOL)checkEmailValidity
{
    BOOL filter = YES ;
    NSString* filterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString* laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    NSString* emailRegex = filter ? filterString : laxString;
    NSPredicate* emailTest = [ NSPredicate predicateWithFormat : @"SELF MATCHES %@", emailRegex ];
    
    if( [emailTest evaluateWithObject:self ] == NO )
        return NO;
    return YES ;
}

@end

