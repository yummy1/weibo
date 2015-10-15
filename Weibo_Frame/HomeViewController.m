//
//  HomeViewController.m
//  Weibo_Frame
//
//  Created by qingyun on 15/8/25.
//  Copyright (c) 2015年 河南青云信息技术有限公司. All rights reserved.
//

#import "HomeViewController.h"
#import "Common.h"
#import "AFNetworking.h"
#import "Account.h"
#import "StatusTableViewCell.h"
#import "Status.h"
#import "DataBaseEngine.h"
#import "UINavigationController+notification.h"
#import "StatusFooter.h"
#import "SendStatusViewController.h"



@interface HomeViewController (){
    BOOL refreshing;
}

@property (nonatomic, strong)NSMutableArray *statues;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.edgesForExtendedLayout = UIRectEdgeNone;

    
    //注册footerView
    UINib *nib = [UINib nibWithNibName:@"StatusFooter" bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nib forHeaderFooterViewReuseIdentifier:@"footer"];
    
    //添加登陆成功的监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(login) name:kLogIn object:nil];
    
    if ([[Account sharedAccount] isLogin]) {
        //从数据库中查询出内容
        self.statues = [NSMutableArray arrayWithArray:[DataBaseEngine statusesFromDB]];
        //网络中请求数据
        [self loadData];
    }
    
    //添加下拉刷新空间
    UIRefreshControl *control = [[UIRefreshControl alloc] init];
    self.refreshControl = control;
    [self.refreshControl addTarget:self action:@selector(reloadNew:) forControlEvents:UIControlEventValueChanged];
    
    //设置refreshControl的标题
    [self setRefreshControlTitle:@"下拉加载更新！"];
    
}


-(void)reloadStatusWith:(NSString *)sineceID MaxID:(NSString *)maxID{
    //如果正在刷新，不在进行请求
    if (refreshing == YES) {
        return;
    }
    
    //请求更新的数据
    NSString *urlString = [kBaseURL stringByAppendingPathComponent:@"friends_timeline.json"];
    //请求的参数
    NSMutableDictionary *tokenDic = [[Account sharedAccount] requestParameters];
    
    //设置请求的id参数
    [tokenDic setObject:sineceID forKey:@"since_id"];
    [tokenDic setObject:maxID forKey:@"max_id"];
    
    //http通信
    AFHTTPRequestOperationManager *manager =[AFHTTPRequestOperationManager manager];
    //开始请求
    refreshing = YES;
    [manager GET:urlString parameters:tokenDic success:^void(AFHTTPRequestOperation * operation, id response) {
        
        //请求到的数据数组
        NSArray *statusesInfo = [NSMutableArray arrayWithArray:response[@"statuses"]];
        
        //第一次请求
        if ([sineceID isEqualToString:@"0"] && [maxID isEqualToString:@"0"]) {
            
            
            
            self.statues = [NSMutableArray array];
            //遍历数据
            for (NSDictionary *info in statusesInfo) {
                Status *status = [[Status alloc] initStatusWith:info];
                [self.statues addObject:status];
            }
            
           
            
        }else if (![sineceID isEqualToString:@"0"]){
            //请求更新
            if (statusesInfo.count != 0) {
                for (int i = 0; i < statusesInfo.count; i++) {
                    //转化为model
                    Status *status = [[Status alloc] initStatusWith:statusesInfo[i]];
                    //保存到现有的数组中
                    [self.statues insertObject:status atIndex:i];
                }
            }
            //当前时间
            NSDate *date = [NSDate date];
            
            //显示当前时间的字符串
            NSString *text = [NSString stringWithFormat:@"最后更新时间%@", [NSDateFormatter localizedStringFromDate:date dateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterMediumStyle]];
            //设置显示最后刷新时间
            [self setRefreshControlTitle:text];
            
            //一秒钟后停止刷新，隐藏refreshControl
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.refreshControl endRefreshing];
                
                NSString *notiText = [NSString stringWithFormat:@"更新了%ld条记录", [statusesInfo count]];
                [self.navigationController showNotification:notiText];
            });
        }else{
            //请求更多
            for (NSDictionary *statusInfo in statusesInfo) {
                //转化为model
                Status *status = [[Status alloc] initStatusWith:statusInfo];
                //不等于数组中最后一条的id
                if (![status.idStr isEqualToString:[self.statues.lastObject idStr]]) {
                    [self.statues addObject:status];
                }
                
            }
        }
        
        //重要，更新UI
        [self.tableView reloadData];
        
        //保存数据
        [DataBaseEngine saveStatuses2Database:statusesInfo];
        
        //请求结束
        refreshing = NO;
    } failure:^void(AFHTTPRequestOperation * operation, NSError * error) {
        //请求结束
        refreshing = NO;
    }];
    
    
}

//点击tabbarItem的刷新方法
-(void)refreshData{
    //触发下拉刷新
    [self reloadNew:self.refreshControl];
    //下拉刷新UI触发
    [self.refreshControl beginRefreshing];
    //显示出refrshControl
    [self.tableView setContentOffset:CGPointMake(0, -70)];
    
}

-(void)reloadNew:(UIRefreshControl*)refreshControl{
    NSLog(@"%@", @"开始刷新");
    //设置显示的提示内容
    [self setRefreshControlTitle:@"正在加载"];
    //第一条微博
    if (self.statues.count) {
        Status *status = self.statues.firstObject;
        //请求更新
        [self reloadStatusWith:status.idStr MaxID:@"0"];
    }else{
        [self reloadStatusWith:@"0" MaxID:@"0"];
    }
    
    
    
    
}

-(void)reloadMore{
    
    //取出最后一条微博
    Status *status = [self.statues lastObject];
    //请求更多
    [self reloadStatusWith:@"0" MaxID:status.idStr];
    
    
}


-(void)login{
    //请求数据
    [self loadData];
}


//设置refreshControl的标题
-(void)setRefreshControlTitle:(NSString *)title{
    
    //构造属性
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:14],
                          NSForegroundColorAttributeName : [UIColor orangeColor]};
    //构造属性字符串
    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title attributes:dic];
    
    //设置到refreshControl的title
    [self.refreshControl setAttributedTitle:attString];
}

-(void)loadData{
    //向微博平台请求数据
    [self reloadStatusWith:@"0" MaxID:@"0"];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)reTwitter:(id)sender{
    NSLog(@"%d", [sender tag]);
    //要转发的微博
    Status *reportsStatus = self.statues[[sender tag]];
    UINavigationController *nav = [self.storyboard instantiateViewControllerWithIdentifier:@"sendStatusNav"];
    [nav.viewControllers[0] performSelector:@selector(setReportsStatus:) withObject:reportsStatus];
    SendStatusViewController *sendStatusVC = nav.viewControllers[0];
    sendStatusVC.type = kReportsStatus;
    
    [self presentViewController:nav animated:YES completion:nil];
    
    
    
}

-(void)comment:(id)sender{
    
}

-(void)like:(id)sender{
    
}

#pragma mark - tableView delegate datasource


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    //用section区分
    return self.statues.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    StatusTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"statusCell" forIndexPath:indexPath];
    
    [cell setStatus:self.statues[indexPath.section]];
    return cell;
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    //当倒数第五条时，触发加载更多方法
    if (self.statues.count - indexPath.section <= 5) {
        [self reloadMore];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //计算cell需要的高度
    return  [StatusTableViewCell cellHeightWithStatus:self.statues[indexPath.section]];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 20.f;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    StatusFooter *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"footer"];
    
    [footer setStatus:self.statues[section]]; 
    
    //footView的按钮添加事件
    [footer.reTwitterButton addTarget:self action:@selector(reTwitter:) forControlEvents:UIControlEventTouchUpInside];
    footer.reTwitterButton.tag = section;
    
    [footer.commentButton addTarget:self action:@selector(comment:) forControlEvents:UIControlEventTouchUpInside ];
    [footer.likeButton addTarget:self action:@selector(like:) forControlEvents:UIControlEventTouchUpInside];
    return footer;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"statusDetail"]) {
        //找到跳转的下一个控制器
        UIViewController *detailVC= segue.destinationViewController;
        
        //sender就是cell，通过cell找到Status详情
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        //将要显示的status
        Status *status = self.statues[indexPath.section];
        //赋值给下一个控制器
        [detailVC setValue:status forKey:@"status"];
    }
    
    
}


@end
