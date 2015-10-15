//
//  SendStatusViewController.h
//  Weibo_Frame
//
//  Created by qingyun on 15/9/10.
//  Copyright (c) 2015年 河南青云信息技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    kWriteStatus,
    kReportsStatus,
    kComments,
} kSendStatusType;

@class Status;
@interface SendStatusViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIView *imageSuperView;
@property (weak, nonatomic) IBOutlet UIImageView *reportsIcon;
@property (weak, nonatomic) IBOutlet UILabel *reportsName;
@property (weak, nonatomic) IBOutlet UILabel *reportsText;

@property (nonatomic, strong)Status *reportsStatus;

@property (nonatomic)kSendStatusType type;

- (IBAction)cancel:(id)sender;
- (IBAction)sender:(id)sender;

@end
