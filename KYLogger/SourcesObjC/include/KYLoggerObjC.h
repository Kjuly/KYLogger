//
//  KYLoggerObjC.h
//  KYLogger
//
//  Created by Kjuly on 9/24/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kKYLogTypeCritical @"❌ CRITICAL"
#define kKYLogTypeError    @"🔴 ERROR"
#define kKYLogTypeWarn     @"⚠️ WARN"
#define kKYLogTypeNotice   @"🔵 NOTICE"
#define kKYLogTypeSuccess  @"✅ SUCCESS"
#define kKYLogTypeDebug    @"🎯 DEBUG"

#ifdef DEBUG

  // MARK: - Xcode Color
  /*
  #define XCODE_COLORS_ESCAPE_MAC @"\033["
  #define XCODE_COLORS_ESCAPE_IOS @"\xC2\xA0["

  //#if TARGET_OS_IPHONE
  #if TARGET_IPHONE_SIMULATOR || TARGET_OS_MAC
  #define XCODE_COLORS_ESCAPE XCODE_COLORS_ESCAPE_MAC
  #else
  #define XCODE_COLORS_ESCAPE XCODE_COLORS_ESCAPE_IOS
  #endif

  #define XCODE_COLORS_RESET_FG XCODE_COLORS_ESCAPE @"fg;" // Clear any foreground color
  #define XCODE_COLORS_RESET_BG XCODE_COLORS_ESCAPE @"bg;" // Clear any background color
  #define XCODE_COLORS_RESET    XCODE_COLORS_ESCAPE @";"   // Clear any foreground or background color
   */

  // MARK: - KYLog

  //#define NSLog(__FORMAT__, ...) NSLog((@"%s [Line %d] " __FORMAT__), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
  //#define KYLog(__FORMAT__, ...) NSLog((XCODE_COLORS_ESCAPE @"fg114,142,200;" __FORMAT__ XCODE_COLORS_RESET), ##__VA_ARGS__)
  //#define KYLog(__FORMAT__, ...) NSLog((@"%s L%d " __FORMAT__), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

  //
  // Since Xcode 8, it does not support related plugin any more.
  //
  // #define KYLogWithColor(color, type, __FORMAT__, ...) NSLog((XCODE_COLORS_ESCAPE color @"%s L%d %@: " XCODE_COLORS_RESET __FORMAT__), __PRETTY_FUNCTION__, __LINE__, type, ##__VA_ARGS__)
  //
  #define KYLogWithColor(color, type, __FORMAT__, ...) NSLog((@"%@ %s L%d: " __FORMAT__), type, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

  #define KYLogCritical(__FORMAT__, ...) KYLogWithColor(@"bg255,70,71;",  kKYLogTypeCritical, __FORMAT__, ##__VA_ARGS__)
  #define KYLogError(__FORMAT__, ...)    KYLogWithColor(@"fg255,70,71;",  kKYLogTypeError,    __FORMAT__, ##__VA_ARGS__)
  #define KYLogWarn(__FORMAT__, ...)     KYLogWithColor(@"fg255,147,0;",  kKYLogTypeWarn,     __FORMAT__, ##__VA_ARGS__)
  #define KYLogNotice(__FORMAT__, ...)   KYLogWithColor(@"fg0,178,255;",  kKYLogTypeNotice,   __FORMAT__, ##__VA_ARGS__)
  #define KYLogSuccess(__FORMAT__, ...)  KYLogWithColor(@"fg74,210,87;",  kKYLogTypeSuccess,  __FORMAT__, ##__VA_ARGS__)
  #define KYLogDebug(__FORMAT__, ...)    KYLogWithColor(@"fg152,181,79;", kKYLogTypeDebug,    __FORMAT__, ##__VA_ARGS__)

#else
  //#undef NSLog
  #define NSLog(args, ...);

  #define KYLogWithColor(color, type, __FORMAT__, ...);

  #define KYLogCritical(__FORMAT__, ...);
  #define KYLogError(__FORMAT__, ...);
  #define KYLogWarn(__FORMAT__, ...);
  #define KYLogNotice(__FORMAT__, ...);
  #define KYLogSuccess(__FORMAT__, ...);
  #define KYLogDebug(__FORMAT__, ...);
#endif // END #ifdef DEBUG


NS_ASSUME_NONNULL_BEGIN

@interface KYLoggerObjC : NSObject

@end

NS_ASSUME_NONNULL_END
