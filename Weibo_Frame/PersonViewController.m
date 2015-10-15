//
//  PersonViewController.m
//  Weibo_Frame
//
//  Created by qingyun on 15/9/11.
//  Copyright (c) 2015年 河南青云信息技术有限公司. All rights reserved.
//

#import "PersonViewController.h"

@interface PersonViewController ()<UITableViewDataSource, UIScrollViewDelegate>

@end

@implementation PersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //正在滚动，
    //scrollView的偏移
    CGFloat contentOffset = scrollView.contentOffset.y;
    
    if (contentOffset < 0){
      //bg要增加的高度
        CGFloat imageAddHeight = -contentOffset;
        self.bgImageView.frame = CGRectMake(0, -imageAddHeight, self.bgImageView.frame.size.width, imageAddHeight + self.bgImageView.superview.frame.size.height);
    }
}

@end
