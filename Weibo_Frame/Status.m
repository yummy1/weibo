//
//  Status.m
//  Weibo_Frame
//
//  Created by qingyun on 15/8/28.
//  Copyright (c) 2015年 河南青云信息技术有限公司. All rights reserved.
//

#import "Status.h"
#import "User.h"
#import "Common.h"
#import "NSDateFormatter+Status.h"

@implementation Status

-(instancetype)initStatusWith:(NSDictionary *)statusInfo{
    self = [super init];
    if (self) {
        //初始化普通属性
        
        //时间的字符串
        NSString *dateString = statusInfo[kStatusCreateTime];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        //将字符串格式化为时间
        self.createdAt = [formatter statusDateFromString:dateString];
        
        self.idStr = statusInfo[kStatusIDStr];
        self.text = statusInfo[kStatusText];
        NSString *sourceString =  statusInfo[kStatusSource];
        self.source = [self sourceWithString:sourceString];
        self.favorited = [statusInfo[kstatusFavorited] boolValue];
        self.geo = statusInfo[kstatusGeo];

        //初始化user，
        NSDictionary *user = statusInfo[kStatusUserInfo];
        self.user = [[User alloc] initUserWith:user];
        
        NSDictionary *reStatus = statusInfo[kStatusRetweetStatus];
        if (reStatus) {
            self.reStatus = [[Status alloc] initStatusWith:reStatus];
        }
        self.repostsCount = [statusInfo[kStatusRepostsCount] integerValue];
        self.commentsCount = [statusInfo[kStatusCommentsCount] integerValue];
        self.attitudesCount = [statusInfo[kStatusAttitudesCount] integerValue];
        self.picUrls = statusInfo[kStatusPicUrls];
        
    }
    
    return self;
}

//重写timeago的get方法
-(NSString *)timeAgo{
    //1.微博的创建时间与当前的时间差
    NSTimeInterval intervel = [[NSDate date] timeIntervalSinceDate:self.createdAt];
    
    if (intervel < 60) {
        //秒级
        return @"刚刚";
    }else if (intervel < 60* 60){
        //分钟级
        return [NSString stringWithFormat:@"%d 分钟前", (int)intervel / 60];
    }else if (intervel < 60 * 60 * 24){
        //小时级
        return [NSString stringWithFormat:@"%d 小时前", (int)intervel/ (60 * 60)];
    }else if (intervel < 60 * 60 * 24 * 30){
        //天
        return [NSString stringWithFormat:@"%d 天前", (int)intervel/(60 *60 * 24)];
    }else{
        //返回时间
        return [NSDateFormatter localizedStringFromDate:self.createdAt dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterNoStyle];
    }
    
}

-(NSString *)sourceWithString:(NSString *)string{
    
    if ([string isKindOfClass:[NSNull class]]  || [string isEqualToString:@""] || string == nil) {
        return nil;
    }
    
    //1.正则表达式
    NSString *regExStr = @">.+<";
    
    NSError *error;
    NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:regExStr options:0 error:&error];
    //查找符合条件的结果
    NSTextCheckingResult *result = [expression firstMatchInString:string options:0 range:NSMakeRange(0, string.length)];
    if (result) {
        NSRange range = result.range;
        NSString *souce = [string substringWithRange:NSMakeRange(range.location + 1, range.length -2)];
        return [NSString stringWithFormat:@"来自 %@", souce];
    }
    
    return nil;
    
    
    
}


@end
