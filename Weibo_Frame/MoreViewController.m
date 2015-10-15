//
//  MoreViewController.m
//  Weibo_Frame
//
//  Created by qingyun on 15/9/10.
//  Copyright (c) 2015年 河南青云信息技术有限公司. All rights reserved.
//

#import "MoreViewController.h"
#import "Common.h"

@interface MoreViewController ()

@end

@implementation MoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    //按钮的弹出动画
    
    for (int i = 0; i < self.actionButton.count; i ++) {
        //按钮的动画开始时间依次递增
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(i * 0.03 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //将按钮移动到开始位置
            UIButton *button = self.actionButton[i];
            CGRect originFrame = button.frame;
            
            button.frame = CGRectOffset(button.frame, 0, self.view.frame.size.height - button.frame.origin.y);
            button.hidden = NO;
            [UIView animateWithDuration:.3f animations:^{
                button.frame = CGRectOffset(originFrame, 0, -15);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:.1f animations:^{
                    button.frame = originFrame;
                }];
            }];
            
            
            
        });
    }
    
}
- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
