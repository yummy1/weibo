//
//  TableViewCell.m
//  Weibo_Frame
//
//  Created by qingyun on 15/9/7.
//  Copyright (c) 2015年 河南青云信息技术有限公司. All rights reserved.
//

#import "ReTwitterTableViewCell.h"
#import "Status.h"
#import "User.h"
#import "UIImageView+WebCache.h"
#import "NSString+size.h"
#import "Common.h"

@implementation ReTwitterTableViewCell

+(CGFloat)cellHeight4Status:(Status *)status{
    //正文高度加上正文开始的高度等于cell高度
    CGFloat cellHeight = 51;
    //正文的高度
    CGFloat textHeight = [status.text sizeWithFont:[UIFont systemFontOfSize:17] Size:CGSizeMake(kScreenWidth - 75 - 8, MAXFLOAT)].height;
    return cellHeight + textHeight + 8;
    
    
}

- (void)awakeFromNib {
    // Initialization code
}

//绑定model的内容
-(void)setStatus:(Status *)status{
    //用户信息
    [self.icon sd_setImageWithURL:[NSURL URLWithString:status.user.profileImageURL]];
    self.name.text = status.user.name;
    
    //格式化时间
    NSString *timeString = [NSDateFormatter localizedStringFromDate:status.createdAt dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
    self.label.text = timeString;
    
    //正文
    self.content.text = status.text;
    
    
}


@end
