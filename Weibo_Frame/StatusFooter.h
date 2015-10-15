//
//  StatusFooter.h
//  Weibo_Frame
//
//  Created by qingyun on 15/9/6.
//  Copyright (c) 2015年 河南青云信息技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Status;
@interface StatusFooter : UITableViewHeaderFooterView
@property (weak, nonatomic) IBOutlet UIButton *reTwitterButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;

-(void)setStatus:(Status *)status;


@end
