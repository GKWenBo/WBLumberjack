//
//  WBLumberjack.h
//  WBLumberjackHelperDemo
//
//  Created by Mr_Lucky on 2018/9/29.
//  Copyright © 2018 wenbo. All rights reserved.
//

#ifndef WBLumberjack_h
#define WBLumberjack_h

#import <CocoaLumberjack/CocoaLumberjack.h>

#ifdef DEBUG
static const DDLogLevel ddLogLevel = DDLogLevelVerbose;
#else
static const DDLogLevel ddLogLevel = DDLogLevelWarning;
#endif

#endif /* WBLumberjack_h */
