//
//  NSObject+Tool.h
//  Weibo_Frame
//
//  Created by qingyun on 15/8/27.
//  Copyright (c) 2015年 河南青云信息技术有限公司. All rights reserved.
//

//得到Documents文件夹下文件的路径

#import <Foundation/Foundation.h>

@interface NSObject (Tool)

+(NSString *)filePathForDocuments:(NSString *)fileName;

@end
