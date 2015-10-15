//
//  UINavigationController+notification.m
//  Weibo_Frame
//
//  Created by qingyun on 15/9/6.
//  Copyright (c) 2015年 河南青云信息技术有限公司. All rights reserved.
//

#import "UINavigationController+notification.h"
#import "Common.h"

@implementation UINavigationController (notification)

-(void)showNotification:(NSString *)text{
    
    //初始化label，用于显示
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 22, kScreenWidth, 44)];
    label.backgroundColor = [UIColor orangeColor];
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:14];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = text;
    
    //添加label到navbar的下面
    [self.view insertSubview:label belowSubview:self.navigationBar];
    
    //下落动画
    [UIView animateWithDuration:.5f animations:^{
        label.frame = CGRectOffset(label.frame, 0, 44);
    } completion:^(BOOL finished) {
        
        //停留时间
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //回归动画
            [UIView animateWithDuration:.5f animations:^{
                label.frame = CGRectOffset(label.frame, 0, -44);
            } completion:^(BOOL finished) {
                [label removeFromSuperview];
            }];
        });
    }];
    
}

@end
