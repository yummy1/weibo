//
//  LoginViewController.m
//  Weibo_Frame
//
//  Created by qingyun on 15/8/27.
//  Copyright (c) 2015年 河南青云信息技术有限公司. All rights reserved.
//

#import "LoginViewController.h"
#import "Common.h"
#import "AFNetworking.h"
#import "Account.h"
#import "SVProgressHUD.h"

@interface LoginViewController ()<UIWebViewDelegate>

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *url = [NSString stringWithFormat:@"https://api.weibo.com/oauth2/authorize?client_id=%@&redirect_uri=%@&response_type=code", kAPP_KEY, kREdirectURI];
    
    //1.将用户引导到认证界面
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [self.webView loadRequest:request];
    [self.webView setDelegate:self];
    

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)cancel:(id)sender {
    [SVProgressHUD dismiss];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - webView delegate

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    //取出请求的url地址
    NSURL *url = request.URL;
    NSString *urlString = [url absoluteString];
    NSLog(@"%@", urlString);
    
    //2.如请求地址是以回调地址开头
    if ([urlString hasPrefix:kREdirectURI]) {
        //取出code授权码
        NSArray *result = [urlString componentsSeparatedByString:@"code="];
        NSString *code = result[1];
        
        //3.换取授权码
        NSString *urlToken = @"https://api.weibo.com/oauth2/access_token";
        NSDictionary *params = @{@"client_id":kAPP_KEY,
                                 @"client_secret":@"7fd6214d36cd3b1b93209f85b33fa5c0",
                                 @"grant_type":@"authorization_code",
                                 @"code":code,
                                 @"redirect_uri":kREdirectURI};
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
        [manager POST:urlToken parameters:params success:^ void(AFHTTPRequestOperation * operation, id response) {
            NSLog(@"%@", response);
            //4.换取token成功后保存
            [[Account sharedAccount] saveLoginInfo:response];
            
            [self dismissViewControllerAnimated:YES completion:nil];
            
            //发送登陆成功的通知
            [[NSNotificationCenter defaultCenter] postNotificationName:kLogIn object:nil];
            
            //清理cookie
            NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
            for (NSHTTPCookie *cookie in storage.cookies) {
                [storage deleteCookie:cookie];
            }
            
        } failure:^ void(AFHTTPRequestOperation * operation, NSError * error) {
            NSLog(@"%@", error);
        }];
        
        return NO;
        
    }
    
    //    显示等待指示符
    [SVProgressHUD show];
    return YES;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    //加载完成后取消等待指示符
    [SVProgressHUD dismiss];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    //加载失败后取消等待指示符
    [SVProgressHUD dismiss];
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
