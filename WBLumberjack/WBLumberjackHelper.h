//
//  WBLumberjackHelper.h
//  Start
//
//  Created by Mr_Lucky on 2018/9/29.
//  Copyright © 2018 jmw. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WBLumberjack.h"

NS_ASSUME_NONNULL_BEGIN

@interface WBLumberjackHelper : NSObject

/**
 添加控制台日志输出，与NSLog效果相同
 */
+ (void)wb_configLumberjack;

/**
 The standard implementation for a file logger.
 */
+ (void)wb_setFileLoggerEnabled;

/**
 开启输出到 iOS console
 */
+ (void)wb_setASLLoggerEnabled;

@end

/**
 自定义控制台s日志输出格式
 */
@interface WBCustomLogFormatter : NSObject <DDLogFormatter>
{
    int _atomicLoggerCount;
    NSDateFormatter *_threadUnsafeDateFormatter;
}

@end

NS_ASSUME_NONNULL_END
