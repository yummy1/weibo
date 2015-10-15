//
//  NSObject+Tool.m
//  Weibo_Frame
//
//  Created by qingyun on 15/8/27.
//  Copyright (c) 2015年 河南青云信息技术有限公司. All rights reserved.
//

#import "NSObject+Tool.h"

@implementation NSObject (Tool)

+(NSString *)filePathForDocuments:(NSString *)fileName{
    //归档的文件路径
    NSString *documents = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *filePath = [documents stringByAppendingPathComponent:fileName];
    return filePath;
}

@end
