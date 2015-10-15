//
//  StatusTableViewCell.m
//  Weibo_Frame
//
//  Created by qingyun on 15/8/28.
//  Copyright (c) 2015年 河南青云信息技术有限公司. All rights reserved.
//

#import "StatusTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "Status.h"
#import "User.h"
#import "NSString+size.h"
#import "Common.h"

#define kLineCount 3
#define kImageHeight 90
#define kImagemarge 5
#define kImageWidth 90

@implementation StatusTableViewCell

+(CGFloat)cellHeightWithStatus:(Status *)status{
    CGFloat height = 66;//初始高度；
    
    //微博正文的高度
    CGFloat textHeight = [status.text sizeWithFont:[UIFont systemFontOfSize:17] Size:CGSizeMake(kScreenWidth - 16, MAXFLOAT)].height;
    height += textHeight;
    
    //计算出微博正文图片的高度
    CGFloat imageHeight = [StatusTableViewCell imageSuperViewHeight4PicURLs:status.picUrls];
    height += imageHeight;
    
    //计算转发微博需要的高度
    Status *reStatus = status.reStatus;
    if (reStatus) {
        //计算转发微博正文的高度
        CGFloat reTextHeight = [reStatus.text sizeWithFont:[UIFont systemFontOfSize:17] Size:CGSizeMake(kScreenWidth - 16, MAXFLOAT)].height;
        height += reTextHeight;
        
        //计算转发图片的高度
        CGFloat reStatusImageHeight = [StatusTableViewCell imageSuperViewHeight4PicURLs:reStatus.picUrls];
        height += reStatusImageHeight;
    }
    
    
    //返回cell的总高度
    return height += 9;
    
}

//计算图片显示需要的高度
+(CGFloat)imageSuperViewHeight4PicURLs:(NSArray *)picUrls{
    //没有图片
    if (picUrls.count  == 0) {
        return 0;
    }
    
    //计算出图片的需要的行数
    NSInteger line = (picUrls.count - 1)/kLineCount + 1;
    
//    图片显示需要的高度
    NSInteger imageHeight = line *kImageHeight + (line - 1)*kImagemarge;
    
    
    
    
    return imageHeight;
}



- (void)awakeFromNib {
    // Initialization code
}

-(void)setStatus:(Status *)status{
    
    
    //绑定用户头像
    NSString *urlString = status.user.profileImageURL;
//    //转化为data
//    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
//    //image
//    UIImage *image = [UIImage imageWithData:imageData];
//    self.persionIcon.image = image;
    [self.persionIcon sd_setImageWithURL:[NSURL URLWithString:urlString]];
    
    //用户的昵称
    self.name.text = status.user.name;
    
    //微博的创建时间
    self.time.text = status.timeAgo;
    
    //微博的来源
    self.source.text = status.source;
    
    //微博的正文
    self.content.text = status.text;
    
    //布局微博的图片
    [self layoutImage:status.picUrls forView:self.imageSuperView Constraint:self.imageSuperViewHeight];
    
    //绑定转发微博
    Status *reStatus = [status reStatus];
    self.reStatusContent.text = reStatus.text;
    [self layoutImage:reStatus.picUrls forView:self.reStatusImageSuper Constraint:self.reStatusHeight];
    
    
}

-(void)layoutImage:(NSArray *)images forView:(UIView *)view Constraint:(NSLayoutConstraint *)constranint{
    
//    1.移除所有的子视图
    NSArray *subView = view.subviews;
    [subView makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
//    2.更改父视图到需要的高度
    CGFloat viewHeight = [StatusTableViewCell imageSuperViewHeight4PicURLs:images];
    constranint.constant = viewHeight;
    
    for (int i = 0; i < images.count; i++) {
        //3.添加新的图片
        CGFloat imageX = i%kLineCount * (kImageWidth + kImagemarge);
        CGFloat imageY = i/3* (kImagemarge + kImageHeight);
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageX, imageY, kImageWidth, kImageHeight)];
        //图片的url
        NSString *urlString = [[images objectAtIndex:i] objectForKey:kStatusThumbnailPic];
        [imageView sd_setImageWithURL:[NSURL URLWithString:urlString]];
        [view addSubview:imageView];
    }
    
    
    
    
}

@end
