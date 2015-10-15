//
//  StatusDetailHeaderView.m
//  Weibo_Frame
//
//  Created by qingyun on 15/9/7.
//  Copyright (c) 2015年 河南青云信息技术有限公司. All rights reserved.
//

#import "StatusDetailHeaderView.h"

@implementation StatusDetailHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)selectButton:(UIButton *)button{
    //重置UI布局
    //设置选择的按钮
//    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [button.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [self setButton:button Selected:YES];
    
    //复原之前选择的按钮
    if (self.reTwitter != button) {
//        [self.reTwitter setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//        [self.reTwitter.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [self setButton:self.reTwitter Selected:NO];
    }
    if (self.comment != button) {
//        [self.comment setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//        [self.comment.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [self setButton:self.comment Selected:NO];
    }
    if (self.like != button) {
//        [self.like setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//        [self.like.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [self setButton:self.like Selected:NO];
    }
    
    //移动到选择按钮下面
//    self.currentSelect.center = CGPointMake(button.center.x, self.currentSelect.center.y);
    
    self.ViewLeft.constant = button.center.x -self.currentSelect.frame.size.width/2;
    
}

-(void)setButton:(UIButton *)button Selected:(BOOL )selected{
    if (selected) {
        //选择状态
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:16]];
    }else{
        //未选择
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
    }
}

@end
