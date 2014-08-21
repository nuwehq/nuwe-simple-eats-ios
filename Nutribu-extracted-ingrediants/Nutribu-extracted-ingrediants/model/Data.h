//Data.h

#import <UIKit/UIKit.h>
#define gData [Data sharedData]

//#define SIMULATOR

#define FACEBOOK_ID   @"389315437880473"

#define IMAGE_NORMAL_SIZE       600

#define PROFILE_WHEEL_SIZE      170
#define PROFILE_WHEEL_TOP_Y     170

#define LBS_PER_KG              2.20462f
#define CMS_PER_INCH            2.54f

#define POPUP_HELPER_DURATION   0.5f

#define MAIN_CIRCLE_MAX_OFFSET                  60
#define MAIN_CIRCLE_MIN_SIZE                    140
#define MAIN_CIRCLE_HIGHLIGHT_OFFSET            20
#define MAIN_CIRCLE_BOUNCE_TIME_INTERVAL        0.05
#define MAIN_CIRCLE_BOUNCE_SIZE_INTERVAL         10


#define MAIN_SMALL_CIRCLE_RING_WIDTH        7
#define MAIN_SMALL_CIRCLE_CT_Y1             308
#define MAIN_SMALL_CIRCLE_CT_Y2             418
#define MAIN_SMALL_CIRCLE_LABEL_OFFSET_Y    45
#define MAIN_SMALL_CIRCLE_LABEL_OFFSET_Y1    60


static NSString *const kUserDefaultsKeyUserEmail = @"UserDefaultsKeyUserEmail";
static NSString *const kUserDefaultsKeyUserPassword = @"UserDefaultsKeyUserPassword";

static NSString *const kUserDefaultsKeyInchMode = @"UserDefaultsKeyInchMode";
static NSString *const kUserDefaultsKeyPoundMode = @"UserDefaultsKeyPoundMode";

static NSString *const kUserDefaultsDisableHelpForProfileUnit = @"UserDefaultsDisableHelpForProfileUnit";
static NSString *const kUserDefaultsDisableHelpForProfileWeight = @"UserDefaultsDisableHelpForProfileWeight";
static NSString *const kUserDefaultsDisableHelpForProfileActivity = @"UserDefaultsDisableHelpForProfileActivity";
static NSString *const kUserDefaultsDisableHelpForProfileMe = @"UserDefaultsDisableHelpForProfileMe";
static NSString *const kUserDefaultsDisableHelpForMainToday = @"UserDefaultsDisableHelpForMainToday";
static NSString *const kUserDefaultsDisableHelpForMainTodaySmall = @"UserDefaultsDisableHelpForMainTodaySmall";
static NSString *const kUserDefaultsDisableHelpForMainRecommendMeal = @"UserDefaultsDisableHelpForMainRecommendMeal";
static NSString *const kUserDefaultsDisableHelpForIngredientList = @"UserDefaultsDisableHelpForIngredientList";
static NSString *const kUserDefaultsDisableHelpForIngredientSelect = @"UserDefaultsDisableHelpForIngredientSelect";
static NSString *const kUserDefaultsDisableHelpForSaveMeal = @"UserDefaultsDisableHelpForSaveMeal";

typedef enum
{
    MEAL_BREAKFAST = 0,
    MEAL_LUNCH,
    MEAL_DINNER,
    MEAL_SNACK,
    MEAL_TYPE_NUM
}MealType;

typedef enum NUTRITION
{
    NUTRITION_KCAL,
    NUTRITION_PROTEIN,
    NUTRITION_FIBRE,
    NUTRITION_CARBS,
    NUTRITION_FATU,
    NUTRITION_FATS,
    NUTRITION_SALT,
    NUTRITION_SUGAR,
    NUTRITION_NUM
}NUTRITION;


typedef enum
{
    DATE_ORDER_ASCENDING = -1,
    DATE_ORDER_SAME = 0,
    DATE_ORDER_DESCENDING = 1
}DateCompare;


@interface Date : NSObject
{
    
};

@property (nonatomic, assign) NSInteger nYear;
@property (nonatomic, assign) NSInteger nMonth;
@property (nonatomic, assign) NSInteger nDay;

- (id)initWithDate:(NSDate*)date;
- (void)setYear:(NSInteger)nYear Month:(NSInteger)nMonth Day:(NSInteger)nDay;
- (void)setDate:(NSString*)szDob;
- (NSDate*)getNSDate;
- (DateCompare)compare:(Date*)date;

@end

@interface IngredientTopGroup : NSObject

@property (nonatomic, strong) NSString* szId;
@property (nonatomic, strong) NSString* szName;
@property (nonatomic, strong) NSString* szIconPathTiny;
@property (nonatomic, strong) NSString* szIconPathSmall;
@property (nonatomic, strong) NSString* szIconPathMedium;
@property (nonatomic, assign) int nSubGroupNum;

@end

@interface IngredientSubGroup : NSObject

@property (nonatomic, strong) NSString* szId;
@property (nonatomic, strong) NSString* szName;
@property (nonatomic, assign) CGFloat rKcal;
@property (nonatomic, assign) CGFloat rProt;
@property (nonatomic, assign) CGFloat rFibre;
@property (nonatomic, assign) CGFloat rCarbs;
@property (nonatomic, assign) CGFloat rUFat;
@property (nonatomic, assign) CGFloat rSFat;
@property (nonatomic, assign) CGFloat rSalt;
@property (nonatomic, assign) CGFloat rSugar;
@property (nonatomic, assign) int nSmallDefaultPortion;
@property (nonatomic, assign) int nMediumDefaulPortion;
@property (nonatomic, assign) int nLargeDefaulPortion;

@end


@interface UserInfo : NSObject
{
    
}

@property (nonatomic, copy) NSString* szId;
@property (nonatomic, copy) NSString* szEmail;
@property (nonatomic, copy) NSString* szTokenApi;
@property (nonatomic, copy) NSString* szTokenApp;
@property (nonatomic, copy) NSString* szPassword;

@property (nonatomic, assign) BOOL fMale;
@property (nonatomic, copy) NSString* szFirstName;
@property (nonatomic, copy) NSString* szLastName;
@property (nonatomic, assign) CGFloat rHeight;
@property (nonatomic, assign) CGFloat rWeight;
@property (nonatomic, strong) Date* birthday;
@property (nonatomic, assign) NSInteger nActivity;
@property (nonatomic, copy) NSString* szAvatarMediumPath;
@property (nonatomic, copy) NSString* szAvatarSmallPath;
@property (nonatomic, copy) NSString* szAvatarTinyPath;

//protein data

@property (nonatomic, assign) CGFloat rPsnKcal;
@property (nonatomic, assign) CGFloat rPsnProt;
@property (nonatomic, assign) CGFloat rPsnFibre;
@property (nonatomic, assign) CGFloat rPsnCarbs;
@property (nonatomic, assign) CGFloat rPsnUFat;
@property (nonatomic, assign) CGFloat rPsnSFat;
@property (nonatomic, assign) CGFloat rPsnSalt;
@property (nonatomic, assign) CGFloat rPsnSugar;

- (NSString*)stringSex;
- (NSString*)stringActivity;
- (NSString*)stringWeight;
- (NSString*)stringHeight;
- (NSString*)stringBirthday;
- (NSString*)getFullName;
- (NSInteger)getAge;

@end

@interface MealPreview: NSObject

@property (nonatomic, assign) CGFloat  score;
@property (nonatomic, assign) CGFloat  diff;
@property (nonatomic, strong) NSMutableArray* arrayNutrientTotal;
@property (nonatomic, strong) NSMutableArray* arrayPredictNutrientTotal;
@property (nonatomic, strong) NSMutableArray* arrayPredictNutrientPerc;

@end

@interface Data : NSObject
{

}

@property (nonatomic, strong)  UIColor* colorGreen;
@property (nonatomic, strong)  UIColor* colorGreenLight;
@property (nonatomic, strong)  UIColor* colorGreenDark;
@property (nonatomic, strong)  UIColor* colorBrown;
@property (nonatomic, strong)  UIColor* colorOrange;

@property (nonatomic, strong) UIFont* fontNavBarTitle;
@property (nonatomic, strong) UIFont* fontGeneral;


//basic data
@property (nonatomic, assign) BOOL fInchMode;
@property (nonatomic, assign) BOOL fPoundMode;

@property (nonatomic, assign) BOOL fDisableHelpForProfileUnit;
@property (nonatomic, assign) BOOL fDisableHelpForProfileWeight;
@property (nonatomic, assign) BOOL fDisableHelpForProfileActivity;
@property (nonatomic, assign) BOOL fDisableHelpForProfileMe;
@property (nonatomic, assign) BOOL fDisableHelpForMainToday;
@property (nonatomic, assign) BOOL fDisableHelpForMainTodaySmall;
@property (nonatomic, assign) BOOL fDisableHelpForMainRecommendMeal;
@property (nonatomic, assign) BOOL fDisableHelpForIngredientList;
@property (nonatomic, assign) BOOL fDisableHelpForIngredientSelect;
@property (nonatomic, assign) BOOL fDisableHelpForSaveMeal;

@property (nonatomic, strong) UserInfo* meInfo;

@property (nonatomic, strong) NSMutableArray* aIngredientTopGroups;
@property (nonatomic, strong) NSMutableArray* aIngredientSubGroups;
@property (nonatomic, strong) NSMutableArray* aIngredientSubGroupStartIndex;
@property (nonatomic, strong) NSMutableArray* aIngredientSubGroupAmount;

@property (nonatomic, strong) MealPreview* mealPreview;


+ (Data*)sharedData;

- (void)reset;
- (void)load;
- (void)save;
- (void)saveUserAcccount:(NSString*)szEmail password:(NSString*)szPassword;

- (int)getIngredientLevelFromAmount:(int)amount index:(int)nIndex;
- (int)getDefaultIngrededientAmount:(int)nLevel index:(int)nIndex;



@end

