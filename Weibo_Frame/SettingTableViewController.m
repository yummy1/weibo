//
//  SettingTableViewController.m
//  Weibo_Frame
//
//  Created by qingyun on 15/8/27.
//  Copyright (c) 2015年 河南青云信息技术有限公司. All rights reserved.
//

#import "SettingTableViewController.h"
#import "Account.h"
#import "Common.h"
#import "SDImageCache.h"
#import "SVProgressHUD.h"
#import "UITableView+cellIndex.h"

@interface SettingTableViewController ()

@property (nonatomic, strong)NSArray *cellTitle;

@end

@implementation SettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //cell的标题
    
    if ([[Account sharedAccount] isLogin]) {
        self.cellTitle = @[@[@"账号管理"], @[@"通知设置", @"通用设置", @"隐私与安全"], @[@"清理缓存", @"意见反馈", @"关于微博"], @[@"退出当前账号"]];
    }else{
        self.cellTitle = @[@[@"通用设置"], @[@"关于微博"]];
    }
    
    
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return self.cellTitle.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.cellTitle[section] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"settingCell" forIndexPath:indexPath];
    
    UITableViewCell *cell;
    //不同的cell设置为不同的样式
    if (indexPath.section == 3) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.textColor = [UIColor orangeColor];
    }else{
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        
        
        //显示本地的缓存大小
        if (indexPath.section == 2 && indexPath.row == 0) {
            NSInteger size = [[SDImageCache sharedImageCache] getSize];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f MB", (float)size/1024/1024];
        }

    }
    
    //绑定cell上的内容
    cell.textLabel.text = self.cellTitle[indexPath.section][indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch ([tableView indexForIndexPath:indexPath]) {
        case 7:
        {
            //构造控制器
            UIAlertController *controller = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            
            //构造按钮
            UIAlertAction *logout = [UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                //退出登录
                //通知主控制器
                [[NSNotificationCenter defaultCenter] postNotificationName:kLogOut object:nil];
                //返回上一个控制器
                [self.navigationController popViewControllerAnimated:YES];
                
                
            }];
            
            UIAlertAction *alertCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            
            //将按钮添加到控制器
            [controller addAction:logout];
            [controller addAction:alertCancel];
            [self presentViewController:controller animated:YES completion:nil];
        }
            break;
        case 4:{
            //构造控制器
            UIAlertController *controller = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            
            //构造按钮
            UIAlertAction *logout = [UIAlertAction actionWithTitle:@"清除缓存" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                //清除所有的sd的image缓存
                [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
                    //清除缓存成功
                    [SVProgressHUD showSuccessWithStatus:@"清除成功！"];
                    [self.tableView reloadData];
                    
                }];
                
                
            }];
            
            UIAlertAction *alertCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            
            //将按钮添加到控制器
            [controller addAction:logout];
            [controller addAction:alertCancel];
            [self presentViewController:controller animated:YES completion:nil];
        }
            break;
        default:
            break;
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
