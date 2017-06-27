//
//  Created by iOSDevDK
//  Copyright © 2017 iOSDevDKs. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark
#pragma mark Singletone instance

#define DEFINE_SHARED_INSTANCE_USING_BLOCK(block) \
static dispatch_once_t pred = 0; \
__strong static id _sharedObject = nil; \
dispatch_once(&pred, ^{ \
_sharedObject = block(); \
}); \
return _sharedObject; \

//DLOG

#ifdef DEBUG

#define DLOG(fmt, ...) NSLog(@"%s: " fmt, __PRETTY_FUNCTION__, ##__VA_ARGS__)
#define DCGRect(str, rect) NSLog(@"%@:- %.02f, %.02f, %.02f, %.02f", str, rect.origin.x, rect.origin.y, rect.size.width, rect.size.height)
#define DCGPoint(str, point) NSLog(@"%@:- %.02f, %.02f", str, point.x, point.y)
#else
#define DLOG(...)

#endif

// localized tags

#define kToolBarColor [UIColor colorFromRGBIntegers:55 green:170 blue:214 alpha:1.0]


#define DeviceIsWidescreen ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )


// Localize lable

#define LocalizedValue(str) NSLocalizedString(str, @"")
#define LocalizedString(str) NSLocalizedString(str, @"")

// UIAlertView methods

//alert with only message
#define DisplayAlert(msg) { UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]; [alertView show]; alertView=nil;}
//alert with message and title
#define DisplayAlertWithTitleAndDelegate(msg,title){UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];alertView.tag=22;[alertView show]; alertView=nil;}

#define DisplayAlertWithTitle(msg,title){UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]; [alertView show]; alertView=nil;}
//alert with only localized message
#define DisplayLocalizedAlert(msg){UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(msg,@"") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]; [alertView show]; alertView=nil;}
//alert with localized message and title
#define DisplayLocalizedAlertWithTitle(msg,title){UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(title,@"") message:NSLocalizedString(msg,@"") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]; [alertView show]; alertView=nil;}
#define DisplayAlertWithTitleOnly(title){UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:title message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil]; [alertView show]; alertView=nil;}


//versions
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

// Firmware methods

//#define DeviceID [[UIDevice currentDevice] uniqueIdentifier]
#define OSVersion [[[UIDevice currentDevice] systemVersion] floatValue]
//#define DeviceName [UIDevice currentDevice].name

#define RANDOM(minNumber, maxNumber) random() % (maxNumber-minNumber+1) + minNumber

#define isiPhone  (UI_USER_INTERFACE_IDIOM() == 0)?TRUE:FALSE
#define iPhone5 ([[UIScreen mainScreen ] bounds].size.height >= 568.0f)?YES:FALSE
#define isiOS7 ([[[UIDevice currentDevice] systemVersion] floatValue]>= 7.0)?TRUE:FALSE
