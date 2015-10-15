//
//  MeViewController.m
//  Weibo_Frame
//
//  Created by qingyun on 15/8/25.
//  Copyright (c) 2015年 河南青云信息技术有限公司. All rights reserved.
//

#import "MeViewController.h"

@interface MeViewController ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation MeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableView data source / delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"meCell" forIndexPath:indexPath];
    return cell;
}

@end
