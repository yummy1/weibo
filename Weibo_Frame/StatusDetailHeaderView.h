//
//  StatusDetailHeaderView.h
//  Weibo_Frame
//
//  Created by qingyun on 15/9/7.
//  Copyright (c) 2015年 河南青云信息技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StatusDetailHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIButton *reTwitter;
@property (weak, nonatomic) IBOutlet UIButton *comment;
@property (weak, nonatomic) IBOutlet UIButton *like;
@property (weak, nonatomic) IBOutlet UIView *currentSelect;

-(void)selectButton:(UIButton *)button;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ViewLeft;

@end
