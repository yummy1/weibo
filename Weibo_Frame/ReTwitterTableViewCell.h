//
//  TableViewCell.h
//  Weibo_Frame
//
//  Created by qingyun on 15/9/7.
//  Copyright (c) 2015年 河南青云信息技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Status;
@interface ReTwitterTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UILabel *content;

//绑定model
-(void)setStatus:(Status *)status;
//计算cell显示所需要的高度
+(CGFloat)cellHeight4Status:(Status *)status;


@end
