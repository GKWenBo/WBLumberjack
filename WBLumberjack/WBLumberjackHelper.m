//
//  WBLumberjackHelper.m
//  Start
//
//  Created by Mr_Lucky on 2018/9/29.
//  Copyright © 2018 jmw. All rights reserved.
//

#import "WBLumberjackHelper.h"
#import <libkern/OSAtomic.h>

static NSString *const kDateFormatString = @"yyyy/MM/dd HH:mm:ss";

@implementation WBLumberjackHelper

+ (void)wb_configLumberjack {
    [[DDLog sharedInstance] addLogger:[DDTTYLogger sharedInstance]];
    [DDTTYLogger sharedInstance].logFormatter = [[WBCustomLogFormatter alloc]init];
}

+ (void)wb_setFileLoggerEnabled {
    DDFileLogger *fileLogger = [[DDFileLogger alloc] init];
    fileLogger.rollingFrequency = 60 * 60 * 24; // 24 hour rolling
    fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
    [DDLog addLogger:fileLogger];
}

+ (void)wb_setASLLoggerEnabled {
    [[DDLog sharedInstance] addLogger:[DDASLLogger sharedInstance]];
}

@end

@implementation WBCustomLogFormatter

- (NSString *)stringFromDate:(NSDate *)date {
    int32_t loggerCount = OSAtomicAdd32(0, &_atomicLoggerCount);
    
    if (loggerCount <= 1) {
        // Single-threaded mode.
        
        if (_threadUnsafeDateFormatter == nil) {
            _threadUnsafeDateFormatter = [[NSDateFormatter alloc] init];
            [_threadUnsafeDateFormatter setDateFormat:kDateFormatString];
        }
        
        return [_threadUnsafeDateFormatter stringFromDate:date];
    } else {
        // Multi-threaded mode.
        // NSDateFormatter is NOT thread-safe.
        
        NSString *key = @"MyCustomFormatter_NSDateFormatter";
        
        NSMutableDictionary *threadDictionary = [[NSThread currentThread] threadDictionary];
        NSDateFormatter *dateFormatter = [threadDictionary objectForKey:key];
        
        if (dateFormatter == nil) {
            dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:kDateFormatString];
            [threadDictionary setObject:dateFormatter forKey:key];
        }
        
        return [dateFormatter stringFromDate:date];
    }
}

#pragma mark - DDLogFormatter
- (NSString *)formatLogMessage:(DDLogMessage *)logMessage {
    NSString *logLevel; // 日志等级
    switch (logMessage->_flag) {
        case DDLogFlagError    : logLevel = @"Error";   break;
        case DDLogFlagWarning  : logLevel = @"Warning"; break;
        case DDLogFlagInfo     : logLevel = @"Info";    break;
        case DDLogFlagDebug    : logLevel = @"Debug";   break;
        default                : logLevel = @"Verbose"; break;
    }
    
    NSString *dateAndTime = [self stringFromDate:(logMessage.timestamp)]; // 日期和时间
    NSString *logFileName = logMessage -> _fileName; // 文件名
    NSString *logFunction = logMessage -> _function; // 方法名
    NSUInteger logLine = logMessage -> _line;        // 行号
    NSString *logMsg = logMessage->_message;         // 日志消息
    
    // 日志格式：日期和时间 文件名 方法名 : 行数 <日志等级> 日志消息
    return [NSString stringWithFormat:@"%@ %@ %@ : %lu <%@> %@", dateAndTime, logFileName, logFunction, logLine, logLevel, logMsg];
}

- (void)didAddToLogger:(id <DDLogger>)logger {
    OSAtomicIncrement32(&_atomicLoggerCount);
}

- (void)willRemoveFromLogger:(id <DDLogger>)logger {
    OSAtomicDecrement32(&_atomicLoggerCount);
}

@end
