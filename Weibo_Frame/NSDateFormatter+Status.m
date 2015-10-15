//
//  NSDateFormatter+Status.m
//  Weibo_Frame
//
//  Created by qingyun on 15/8/31.
//  Copyright (c) 2015年 河南青云信息技术有限公司. All rights reserved.
//

#import "NSDateFormatter+Status.h"

@implementation NSDateFormatter (Status)

-(NSDate *)statusDateFromString:(NSString *)dateString{
    
    //指定时间格式
    self.dateFormat = @"EEE MMM dd HH:mm:ss zzz yyyy";
    return [self dateFromString:dateString];
}

@end
