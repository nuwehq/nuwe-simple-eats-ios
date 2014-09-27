//Data.mm

#import "Data.h"


@implementation Date


- (id)initWithDate:(NSDate*)date
{
    self = [super init];
    if (self)
    {
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:date];
        
        _nYear = [components year];
        _nMonth = [components month];
        _nDay = [components day];
    }
    
    return self;
}
- (void)setYear:(NSInteger)nYear Month:(NSInteger)nMonth Day:(NSInteger)nDay
{
    _nYear = nYear;
    _nMonth = nMonth;
    _nDay = nDay;
    
}
- (void)setDate:(NSString*)szDob
{
    _nMonth = [[szDob substringWithRange:NSMakeRange(0, 2)] integerValue];
    _nDay = [[szDob substringWithRange:NSMakeRange(3, 2)] integerValue];
    _nYear = [[szDob substringWithRange:NSMakeRange(6, 4)] integerValue];
    
}
- (NSDate*)getNSDate
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setYear:_nYear];
    [components setMonth:_nMonth];
    [components setDay:_nDay];
    
    return [calendar dateFromComponents:components];
}
- (DateCompare)compare:(Date*)date
{
    int nYearUnit1, nYearUnit2;
    if (_nYear < date.nYear)
    {
        nYearUnit1 = 0;
        nYearUnit2 = 1;
    }
    else if (_nYear > date.nYear)
    {
        nYearUnit1 = 1;
        nYearUnit2 = 0;
    }
    else
    {
        nYearUnit1 = 0;
        nYearUnit2 = 0;
    }
    
    int nMonthUnit1, nMonthUnit2;
    if (_nMonth < date.nMonth)
    {
        nMonthUnit1 = 0;
        nMonthUnit2 = 1;
    }
    else if (_nMonth > date.nMonth)
    {
        nMonthUnit1 = 1;
        nMonthUnit2 = 0;
    }
    else
    {
        nMonthUnit1 = 0;
        nMonthUnit2 = 0;
    }
    
    int nDayUnit1, nDayUnit2;
    if (_nDay < date.nDay)
    {
        nDayUnit1 = 0;
        nDayUnit2 = 1;
    }
    else if (_nDay > date.nDay)
    {
        nDayUnit1 = 1;
        nDayUnit2 = 0;
    }
    else
    {
        nDayUnit1 = 0;
        nDayUnit2 = 0;
    }
    
    
    int nCompare1, nCompare2;
    nCompare1 = nYearUnit1 * 100 + nMonthUnit1 * 10 + nDayUnit1;
    nCompare2 = nYearUnit2 * 100 + nMonthUnit2 * 10 + nDayUnit2;
    
    if (nCompare1 < nCompare2)
        return DATE_ORDER_ASCENDING;
    else if (nCompare1 == nCompare2)
        return DATE_ORDER_SAME;
    else
        return DATE_ORDER_DESCENDING;
    
}

@end

@implementation IngredientTopGroup

- (id)init
{
    self = [super init];
    
    if (self)
    {
    }
    
    return self;
}

@end

@implementation IngredientSubGroup

@end

@implementation UserInfo

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.fMale = NO;
        self.nActivity = -1;
        self.rWeight  = -1;
        self.rHeight = -1;
        
        self.birthday = [[Date alloc] init];
        self.birthday.nYear = -1;
        self.birthday.nMonth = -1;
        self.birthday.nDay = -1;
    }
    
    return self;
}

- (NSString*)stringSex
{
    if (_fMale)
        return @"M";
    else
        return @"F";
}

- (NSString*)stringActivity;
{
    if (_nActivity < 0)
        return @"";
    else
        return [NSString stringWithFormat:@"%d", (int)_nActivity];
}


- (NSString*)stringWeight
{
    if (_rWeight < 0)
        return @"";
    else
        return [NSString stringWithFormat:@"%.1f", _rWeight * 1000];
}

- (NSString*)stringHeight
{
    if (_rHeight < 0)
        return @"";
    else
        return [NSString stringWithFormat:@"%.1f", _rHeight * 10];
}

- (NSString*)stringBirthday
{
    if (_birthday.nYear < 0)
        return @"";
    else
        return [NSString stringWithFormat:@"%4d-%02d-%02d", (int)_birthday.nYear, (int)_birthday.nMonth, (int)_birthday.nDay];
}

- (NSString*)getFullName
{
    return [NSString stringWithFormat:@"%@ %@", _szFirstName, _szLastName];
}

- (NSInteger)getAge
{
    Date* date = [[Date alloc] initWithDate:[NSDate date]];
    return date.nYear - _birthday.nYear;
}



@end

@implementation MealPreview

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.arrayNutrientTotal = [[NSMutableArray alloc] initWithCapacity:NUTRITION_NUM];
        self.arrayPredictNutrientTotal = [[NSMutableArray alloc] initWithCapacity:NUTRITION_NUM];
        self.arrayPredictNutrientPerc = [[NSMutableArray alloc] initWithCapacity:NUTRITION_NUM];
    }
    
    return self;
}

@end


@implementation Data


+ (Data*)sharedData
{
    static Data* _sharedData = nil;
    
    if (_sharedData == nil)
    {
        _sharedData = [[Data alloc] init];
        
        _sharedData.colorGreen =  [[UIColor alloc] initWithRed:0.f green:0.620f blue:0.472f alpha:1.f];     //(0, 158, 118)
        _sharedData.colorGreenLight = [[UIColor alloc] initWithRed:0.357f green:0.808f blue:0.694f alpha:1.f];     //(91, 206, 177)
        
        _sharedData.colorBrown = [[UIColor alloc] initWithRed:199 / 255.f green:52 / 255.f blue:19 / 255.f alpha:1.f];

        _sharedData.colorOrange = [[UIColor alloc] initWithRed:250 / 255.f green:101 / 255.f blue:25 / 255.f alpha:1.f];



        _sharedData.fontNavBarTitle = [UIFont fontWithName:@"HelveticaNeue-Medium" size:17.0f];
        _sharedData.fontGeneral = [UIFont systemFontOfSize:16];
        
        _sharedData.meInfo = [[UserInfo alloc] init];
        

        _sharedData.aIngredientTopGroups = [[NSMutableArray alloc] init];
        _sharedData.aIngredientSubGroupStartIndex = [[NSMutableArray alloc] init];
        _sharedData.aIngredientSubGroups = [[NSMutableArray alloc] init];
        _sharedData.aIngredientSubGroupAmount = [[NSMutableArray alloc] init];
    }
    
    return _sharedData;
}

- (void)reset
{
    _fInchMode = NO;
    _fPoundMode = NO;
    
    _fDisableHelpForProfileUnit = NO;
    _fDisableHelpForProfileWeight = NO;
    _fDisableHelpForProfileActivity = NO;
    _fDisableHelpForProfileMe = NO;
    _fDisableHelpForMainToday = NO;
    _fDisableHelpForMainTodaySmall = NO;
    _fDisableHelpForMainRecommendMeal = NO;
    _fDisableHelpForIngredientSelect = NO;
    _fDisableHelpForIngredientList = NO;
    _fDisableHelpForSaveMeal = NO;
}

- (void)load
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];

    _fInchMode = [userDefaults boolForKey:kUserDefaultsKeyInchMode];
    _fPoundMode = [userDefaults boolForKey:kUserDefaultsKeyPoundMode];
    
    _fDisableHelpForProfileUnit = [userDefaults boolForKey:kUserDefaultsDisableHelpForProfileUnit];
    _fDisableHelpForProfileWeight = [userDefaults boolForKey:kUserDefaultsDisableHelpForProfileWeight];
    _fDisableHelpForProfileActivity = [userDefaults boolForKey:kUserDefaultsDisableHelpForProfileActivity];
    _fDisableHelpForProfileMe = [userDefaults boolForKey:kUserDefaultsDisableHelpForProfileMe];
    _fDisableHelpForMainToday = [userDefaults boolForKey:kUserDefaultsDisableHelpForMainToday];
    _fDisableHelpForMainTodaySmall = [userDefaults boolForKey:kUserDefaultsDisableHelpForMainTodaySmall];
    _fDisableHelpForMainRecommendMeal= [userDefaults boolForKey:kUserDefaultsDisableHelpForMainRecommendMeal];
    _fDisableHelpForIngredientList= [userDefaults boolForKey:kUserDefaultsDisableHelpForIngredientList];
    _fDisableHelpForIngredientSelect= [userDefaults boolForKey:kUserDefaultsDisableHelpForIngredientSelect];
    _fDisableHelpForSaveMeal= [userDefaults boolForKey:kUserDefaultsDisableHelpForSaveMeal];
}

- (void)save
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setBool:_fInchMode forKey:kUserDefaultsKeyInchMode];
    [userDefaults setBool:_fPoundMode forKey:kUserDefaultsKeyPoundMode];
    
    [userDefaults setBool:_fDisableHelpForProfileUnit forKey:kUserDefaultsDisableHelpForProfileUnit];
    [userDefaults setBool:_fDisableHelpForProfileWeight forKey:kUserDefaultsDisableHelpForProfileWeight];
    [userDefaults setBool:_fDisableHelpForProfileActivity forKey:kUserDefaultsDisableHelpForProfileActivity];
    [userDefaults setBool:_fDisableHelpForProfileMe forKey:kUserDefaultsDisableHelpForProfileMe];
    [userDefaults setBool:_fDisableHelpForMainToday forKey:kUserDefaultsDisableHelpForMainToday];
    [userDefaults setBool:_fDisableHelpForMainTodaySmall forKey:kUserDefaultsDisableHelpForMainTodaySmall];
    [userDefaults setBool:_fDisableHelpForMainRecommendMeal forKey:kUserDefaultsDisableHelpForMainRecommendMeal];
    [userDefaults setBool:_fDisableHelpForIngredientSelect forKey:kUserDefaultsDisableHelpForIngredientSelect];
    [userDefaults setBool:_fDisableHelpForIngredientList forKey:kUserDefaultsDisableHelpForIngredientList];
    [userDefaults setBool:_fDisableHelpForSaveMeal forKey:kUserDefaultsDisableHelpForSaveMeal];
    
    [userDefaults synchronize];
    
}

- (void)saveUserAcccount:(NSString*)szEmail password:(NSString*)szPassword
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setValue:szEmail forKey:kUserDefaultsKeyUserEmail];
    [userDefaults setValue:szPassword forKey:kUserDefaultsKeyUserPassword];
    
    [userDefaults synchronize];

}

- (int)getIngredientLevelFromAmount:(int)amount index:(int)nIndex
{
    IngredientSubGroup* subGroup = [self.aIngredientSubGroups objectAtIndex:nIndex];
    return [self getIngredientLevelFromAmount:amount ingredient:subGroup];
}
- (int)getDefaultIngrededientAmount:(int)nLevel index:(int)nIndex
{
    IngredientSubGroup* subGroup = [self.aIngredientSubGroups objectAtIndex:nIndex];
    return [self getDefaultIngrededientAmount:nLevel ingredient:subGroup];
}

- (int)getIngredientLevelFromAmount:(int)amount ingredient:(IngredientSubGroup*)ingredient
{
    if (amount == 0)
        return 0;
    else if (amount <= ingredient.nSmallDefaultPortion)
        return 1;
    else if (amount <= ingredient.nMediumDefaulPortion)
        return 2;
    else
        return 3;
}

- (int)getDefaultIngrededientAmount:(int)nLevel ingredient:(IngredientSubGroup*)ingredient
{
    if (nLevel == 0)
        return 0;
    else if (nLevel == 1)
        return ingredient.nSmallDefaultPortion;
    else if (nLevel == 2)
        return ingredient.nMediumDefaulPortion;
    else
        return ingredient.nLargeDefaulPortion;
}

@end