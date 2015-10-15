//
//  StatusFooter.m
//  Weibo_Frame
//
//  Created by qingyun on 15/9/6.
//  Copyright (c) 2015年 河南青云信息技术有限公司. All rights reserved.
//

#import "StatusFooter.h"
#import "Status.h"


@implementation StatusFooter

-(void)awakeFromNib{
    //从xib初始化后被调用
    self.backgroundView = [[UIView alloc] init];
    self.backgroundView.backgroundColor = [UIColor whiteColor];
    
}

-(void)setStatus:(Status *)status{
    //绑定内容
    [self.reTwitterButton setTitle:[[NSNumber numberWithInteger:status.repostsCount] stringValue] forState:UIControlStateNormal];
    [self.commentButton setTitle:[NSString stringWithFormat:@"%ld", status.commentsCount] forState:UIControlStateNormal];
    [self.likeButton setTitle:[NSString stringWithFormat:@"%ld", status.attitudesCount] forState:UIControlStateNormal];
    
    
}

@end
