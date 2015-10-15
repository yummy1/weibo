//
//  CommentsTableViewCell.h
//  Weibo_Frame
//
//  Created by qingyun on 15/9/7.
//  Copyright (c) 2015年 河南青云信息技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Comments;
@interface CommentsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *comments;

//绑定model的方法
-(void)bandleComments:(Comments *)comments;

//计算cell高度
+(CGFloat)cellHeight4Comments:(Comments *)comments;

@end
