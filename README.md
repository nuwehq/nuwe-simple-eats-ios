nuwe-simple-eats
================

A library for including a simple ingredient selection interface for users to track what they are eating quickly and easily with full nutritional data.

Features
================

Full API Integration with Nuapi for Making and Retreiving Eat Events.
Ingredient nutritional data from the USDA Database
Sample View Controller and Storyboards for UI Creation
Optional extended access to Nutritional history for reporting and analysis

Simple Usage
=================

Download the framework and include it into your project (see our guide for building the static framework).
We recommend including as a Git Submodule.

###TODO Enable CocoaPods support

Add the following pre-requisite libraries:

• UIKit.framework
• Foundation.framework
• CoreGraphics.framework
• MobileCoreServices.framework
• SystemConfiguration.framework
• libc++.dylib

NOTE: We currently include a copy of the AFNetworking library in this framework, if you also use AFNetworking in your app, you will have issues with duplicate symbols. We are working to resolve this in the framework, check back for future updates.

NOTE: You will require a Developer Account and to register a user to submit Eat events for that user. See [NuAPI Docs](https://api.nuapi.co/v1/index.html#registration)

Import the Framework

```
#import <NuWe/Nuwe.h>
```

Intitialise it:

```
[[NuWeManager sharedManager] 
startServiceWithAuthenticationKey:@"65801fd1-XXXX-XXXX-XXXX-XXXXX"];
```

Load the Views:

```
// self is a UIViewController that the Nutribu tracking view will appear 
above its displayed view.
[[NuWeManager sharedManager] 
showIngredientsSubmissionViewAboveViewController:self];
```

