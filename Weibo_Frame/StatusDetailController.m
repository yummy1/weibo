//
//  StatusDetailController.m
//  Weibo_Frame
//
//  Created by qingyun on 15/9/7.
//  Copyright (c) 2015年 河南青云信息技术有限公司. All rights reserved.
//

#import "StatusDetailController.h"
#import "Status.h"
#import "StatusTableViewCell.h"
#import "StatusDetailHeaderView.h"
#import "Common.h"
#import "Account.h"
#import "AFNetworking.h"
#import "ReTwitterTableViewCell.h"
#import "Comments.h"
#import "CommentsTableViewCell.h"

typedef enum : NSUInteger {
    kReTwitter,
    kComments,
    kLike,
} kDetailType;

@interface StatusDetailController ()

@property (nonatomic, strong)StatusDetailHeaderView *headerView;

@property (nonatomic,strong)NSArray *reTwitter;//转发的微博的列表
@property (nonatomic,strong)NSArray *comments;//评论的数据源

@property (nonatomic)kDetailType selectedType;//当前选择在哪个类型

@end

@implementation StatusDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.title = @"微博正文";
    //设置默认选择
    self.selectedType = kReTwitter;
    [self.headerView selectButton:self.headerView.reTwitter];
    
}

-(StatusDetailHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[[NSBundle mainBundle] loadNibNamed:@"StatusDetailHeaderView" owner:nil options:nil] objectAtIndex:0];
    }
    return _headerView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)reTwitter:(id)sender{
    [self.headerView selectButton:sender];
    
    //请求转发微博的数据
    //url
    NSString *urlString = [kBaseURL stringByAppendingPathComponent:@"repost_timeline.json"];
    
    //请求的参数
    NSMutableDictionary *tokenDic =[[Account sharedAccount] requestParameters];
    [tokenDic setObject:self.status.idStr forKey:@"id"];
    
    //通过http向服务器发送请求
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlString parameters:tokenDic success:^void(AFHTTPRequestOperation * operation, id responseObject) {
        //返回结果
        NSLog(@"%@", responseObject);
        NSArray *statusesInfo = responseObject[@"reposts"];
        NSMutableArray *resultArray = [NSMutableArray array];
        for (NSDictionary *statusInfo in statusesInfo) {
            //转化为model
            Status *status = [[Status alloc] initStatusWith:statusInfo];
            //加入数组中保存
            [resultArray addObject:status];
        }
        //作为数据源
        self.reTwitter = resultArray;
        
        //设置选择的类型
        self.selectedType = kReTwitter;
        
        //更新UI
        [self.tableView reloadData];
        
        
        
        
        
        
    } failure:^void(AFHTTPRequestOperation * operation, NSError * error) {
        NSLog(@"%@", error);
    }];
    
    
    
    
}

-(void)comment:(id)sender{
    [self.headerView selectButton:sender];
//    请求微博的评论数据
//    url
    NSString *urlString = [kBaseCommentURL stringByAppendingPathComponent:@"show.json"];
    //请求的参数
    NSMutableDictionary *tokenDic = [[Account sharedAccount] requestParameters];
    [tokenDic setObject:self.status.idStr forKey:@"id"];
    
    //http通信
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:urlString parameters:tokenDic success:^void(AFHTTPRequestOperation * operation, id responseObject) {
        NSLog(@"%@", responseObject);
        NSArray *commentsInfo = responseObject[@"comments"];
        NSMutableArray *result = [NSMutableArray array];
        for (NSDictionary *commentInfo in commentsInfo) {
            Comments *comment = [[Comments alloc] initCommentWithInfo:commentInfo];
            [result addObject:comment];
        }
        self.comments = result;
        
        //设置选择的类型
        self.selectedType = kComments;
        
        //更新UI
        [self.tableView reloadData];
        
        
    } failure:^void(AFHTTPRequestOperation * operation, NSError * error) {
        NSLog(@"%@", error);
    }];
    
    
    
    
    
}

-(void)like:(id)sender{
    [self.headerView selectButton:sender];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (section == 0) {
        //正文
        return 1;
    }else{
        switch (self.selectedType) {
            case kReTwitter:
            {
                return self.reTwitter.count;
            }
                break;
            case kComments:{
                return self.comments.count;
            }
                break;
            case kLike:{
                return 0;
            }
                break;
            default:
                break;
        }

        return 0;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        //显示正文
        StatusTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"statusCell" forIndexPath:indexPath];
        [cell setStatus:self.status];
        return cell;
    }else{
        //显示的转发
        if (self.selectedType == kReTwitter) {
            ReTwitterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reTwitter" forIndexPath:indexPath];
            [cell setStatus:self.reTwitter[indexPath.row]];
            return cell;
        }else if (self.selectedType == kComments){
            //选择的类型是评论的时候
            CommentsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"comments" forIndexPath:indexPath];
            [cell bandleComments:self.comments[indexPath.row]];
            return cell;
        }else{
            return nil;
        }
        
    }
    
    
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    //计算cell高度
    
    if (indexPath.section == 0) {
       return [StatusTableViewCell cellHeightWithStatus:self.status];
    }else{
        
        if (self.selectedType == kReTwitter) {
            return [ReTwitterTableViewCell cellHeight4Status:self.reTwitter[indexPath.row]];
        }else if (self.selectedType == kComments){
            //当选择的是评论的时候，根据评论计算高度
            return [CommentsTableViewCell cellHeight4Comments:self.comments[indexPath.row]];
        }else{
            return 0;
        }
        
    }
    
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        
        //按钮添加事件
        [self.headerView.reTwitter addTarget:self action:@selector(reTwitter:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.headerView.comment addTarget:self action:@selector(comment:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.headerView.like addTarget:self action:@selector(like:) forControlEvents:UIControlEventTouchUpInside];
        return self.headerView;
    }else{
        return nil;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return .1f;
    }else {
        return 30.f;
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
