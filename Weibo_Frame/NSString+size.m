//
//  NSString+size.m
//  MLLabelCell
//
//  Created by qingyun on 15/9/1.
//  Copyright (c) 2015年 河南青云信息技术有限公司. All rights reserved.
//

#import "NSString+size.h"

@implementation NSString (size)

-(CGSize)sizeWithFont:(UIFont *)font Size:(CGSize)size{
    CGSize resultSize;
    
    //根据系统不同版本，调用不同方法
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7) {
        //运行在7.0以前的设备
        resultSize = [self sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
        
    }else{
        NSDictionary *attributes = @{NSFontAttributeName : font};
        
        resultSize = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    }
    
    //cell的整体高度
    return resultSize ;
    

}

@end
