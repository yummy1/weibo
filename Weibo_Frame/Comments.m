//
//  Comments.m
//  Weibo_Frame
//
//  Created by qingyun on 15/9/7.
//  Copyright (c) 2015年 河南青云信息技术有限公司. All rights reserved.
//

#import "Comments.h"
#import "User.h"
#import "Status.h"
#import "Common.h"
#import "NSDateFormatter+Status.h"

@implementation Comments

-(instancetype)initCommentWithInfo:(NSDictionary *)commentInfo{
    self = [super init];
    if (self) {
        
        //解析时间
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        self.created_at = [formatter statusDateFromString:commentInfo[kStatusCreateTime]];
        self.text = commentInfo[kStatusText];
        self.source = commentInfo[kStatusSource];
        
        //解析usermodel
        NSDictionary *user = commentInfo[kStatusUserInfo];
        self.user = [[User alloc] initUserWith:user];
        self.idstr = commentInfo[kStatusIDStr];
        
        //解析StatusModel
        NSDictionary *statusInfo = commentInfo[@"status"];
        self.status = [[Status alloc] initStatusWith:statusInfo];
        
        //解析reply_comment
        NSDictionary *reply = commentInfo[@"reply_comment"];
        if (reply) {
            self.reply_comment = [[Comments alloc] initCommentWithInfo:reply];
        }
    }
    return self;
}

@end
