//
//  MainViewController.m
//  Weibo_Frame
//
//  Created by qingyun on 15/8/25.
//  Copyright (c) 2015年 河南青云信息技术有限公司. All rights reserved.
//

#import "MainViewController.h"
#import "Common.h"
#import "Account.h"
#import "AFNetworking.h"

@interface MainViewController ()<UITabBarControllerDelegate>

@property (nonatomic, strong)NSTimer *timer;//刷新未读消息数

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //tabbarViewController deleagte
    self.delegate = self;
    
    //设置tabbar的tintColor
    self.tabBar.tintColor = [UIColor orangeColor];
    self.tabBar.translucent = NO;
    //设置默认选择的控制器
    
    if(![[Account sharedAccount] isLogin]){
        
        
        //为了触发首页控制器的didload方法
        UINavigationController *nav = self.viewControllers[0];
        [nav.viewControllers[0] view];
        
        self.selectedIndex = 2;
    }
    
    
    //监听退出登录
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logout) name:kLogOut object:nil];
    //监听登录成功
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(login) name:kLogIn object:nil];
    
    //发微博页面 取消通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancel:) name:kDismissModal object:nil];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:4.f target:self selector:@selector(refreshUnReadMessage:) userInfo:nil repeats:YES];
    
    [self installTabbar];
    
}

//取消模态视图
- (void)cancel:(id)noti {
    //修改modal的动画方式
    self.presentedViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self dismissViewControllerAnimated:YES completion:nil];
}

//在tabbar上添加按钮
-(void)installTabbar{
    CGFloat buttonWidth = 50;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    //居中显示
    button.frame = CGRectMake((kScreenWidth - buttonWidth) / 2, 7, buttonWidth, 40);
    [button setBackgroundColor:[UIColor orangeColor]];
    [button setImage:[UIImage imageNamed:@"tabbar_compose_icon_add"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(middleButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    
    //tabbar直接子视图
    [self.tabBar addSubview:button];
}

-(void)middleButtonPress:(id)sender{
    //显示more的页面
    UIViewController *more = [self.storyboard instantiateViewControllerWithIdentifier:@"more"];
    more.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:more animated:YES completion:nil];
    
    
}

-(void)logout{
    //收到退出登陆的通知
    //1.登录界面
    //2.切换控制器
    //3.清空保存登录信息
    UIViewController *login = [self.storyboard instantiateViewControllerWithIdentifier:@"loginNav"];
    [self presentViewController:login animated:YES completion:nil];
    
    self.selectedIndex = 2;
    [[Account sharedAccount] logout];
    
}

-(void)login{
    //选择到首页控制器
    self.selectedIndex = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)refreshUnReadMessage:(NSTimer *)timer{
    
//    请求的url
    NSString *urlString = @"https://rm.api.weibo.com/2/remind/unread_count.json";
    //用户的请求参数
    
    NSMutableDictionary *token_dic = [[Account sharedAccount] requestParameters];
    if (!token_dic) {
        //如果为空，则没用登录，不刷新
        return;
    }
    [token_dic setObject:[[Account sharedAccount] currentUserUid] forKey:@"uid"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlString parameters:token_dic success:^void(AFHTTPRequestOperation * operation, id responseObject) {
        //设置未读消息数量
        //未读的微博数量
        NSNumber *statusNumber = responseObject[@"status"];
        if ([statusNumber isEqualToNumber:@0]) {
            //设置不显示内容
            [[self.viewControllers[0] tabBarItem] setBadgeValue:nil];
        }else{
            //设置显示未读消息数量
            NSLog(@"%@", statusNumber.stringValue);
            [[self.viewControllers[0] tabBarItem] setBadgeValue:statusNumber.stringValue];
        }
        
        
        
    } failure:^void(AFHTTPRequestOperation * operation, NSError *error) {
        NSLog(@"%@", error);
    }];
    
    
    
}

-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    //已经选择到第0个控制，并且再次选择到第0个控制器
    if (self.selectedIndex == 0 && viewController == self.viewControllers[0]) {
        //首页刷新
        UINavigationController *nav = self.viewControllers[0];
        [nav.viewControllers[0] performSelector:@selector(refreshData) withObject:nil];
        
    }
    
    if (viewController == self.viewControllers[2]) {
        //占位控制器，不能触发选择
        return NO;
    }
    
    
    return YES;
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
