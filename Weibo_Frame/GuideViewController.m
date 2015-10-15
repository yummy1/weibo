//
//  GuideViewController.m
//  Weibo_Frame
//
//  Created by qingyun on 15/8/25.
//  Copyright (c) 2015年 河南青云信息技术有限公司. All rights reserved.
//

#import "GuideViewController.h"
#import "AppDelegate.h"

@interface GuideViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@end

@implementation GuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.delegate = self;
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //scrollView的size有内容决定
//    self.scrollView.contentSize = self.contentView.frame.size;
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    //约束在viewDidAppear之后起作用，调整contentView的大小，根据其大小调整scrollViewContentSize
    self.scrollView.contentSize = self.contentView.frame.size;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)guideEnd:(id)sender {
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    [delegate guideEnd];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //计算出第几页
    self.pageControl.currentPage = self.scrollView.contentOffset.x/self.scrollView.frame.size.width;
}

@end
