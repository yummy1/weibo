//
//  StatusTableViewCell.h
//  Weibo_Frame
//
//  Created by qingyun on 15/8/28.
//  Copyright (c) 2015年 河南青云信息技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Status;
@interface StatusTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *persionIcon;
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *source;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UIView *imageSuperView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageSuperViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *reStatusContent;
@property (weak, nonatomic) IBOutlet UIView *reStatusImageSuper;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *reStatusHeight;

+(CGFloat)cellHeightWithStatus:(Status *)status;

-(void)setStatus:(Status *) status;
@end
