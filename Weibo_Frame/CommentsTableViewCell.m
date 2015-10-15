//
//  CommentsTableViewCell.m
//  Weibo_Frame
//
//  Created by qingyun on 15/9/7.
//  Copyright (c) 2015年 河南青云信息技术有限公司. All rights reserved.
//

#import "CommentsTableViewCell.h"
#import "Common.h"
#import "Comments.h"
#import "Status.h"
#import "User.h"
#import "NSString+size.h"
#import "UIImageView+WebCache.h"


@implementation CommentsTableViewCell

+(CGFloat)cellHeight4Comments:(Comments *)comments{
    //正文高度加上正文开始的高度等于cell高度
    CGFloat cellHeight = 51;
    //正文的高度
    CGFloat textHeight = [comments.text sizeWithFont:[UIFont systemFontOfSize:17] Size:CGSizeMake(kScreenWidth - 75 - 8, MAXFLOAT)].height;
    return cellHeight + textHeight + 8;
    
    
}

- (void)awakeFromNib {
    // Initialization code
}

//绑定model的内容
-(void)bandleComments:(Comments *)comments{
    //用户信息
    [self.icon sd_setImageWithURL:[NSURL URLWithString:comments.user.profileImageURL]];
    self.name.text = comments.user.name;
    
    //格式化时间
    NSString *timeString = [NSDateFormatter localizedStringFromDate:comments.created_at dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
    self.time.text = timeString;
    
    //正文
    self.comments.text = comments.text;
    
    
}



@end
