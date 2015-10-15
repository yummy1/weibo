//
//  UITableView+cellIndex.h
//  Weibo_Frame
//
//  Created by qingyun on 15/8/31.
//  Copyright (c) 2015年 河南青云信息技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (cellIndex)

//根据cell的indexPath转化为index；
-(NSInteger)indexForIndexPath:(NSIndexPath *)indexPath;
//根据cell找到所对应的index；
-(NSInteger)indexForCell:(UITableViewCell *)cell;


@end
