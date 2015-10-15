//
//  SendStatusViewController.m
//  Weibo_Frame
//
//  Created by qingyun on 15/9/10.
//  Copyright (c) 2015年 河南青云信息技术有限公司. All rights reserved.
//

#import "SendStatusViewController.h"
#import "Common.h"
#import "AFNetworking.h"
#import "Account.h"
#import "Status.h"
#import "User.h"
#import "UIImageView+WebCache.h"


#define kLineCount 3
#define kImageHeight 90
#define kImagemarge 5
#define kImageWidth 90

@interface SendStatusViewController ()<UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong)UILabel *label;
@property (nonatomic, strong)NSMutableArray *sendImages;

@end

@implementation SendStatusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //取消View的延伸效果
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    //添加占位符
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 100, 20)];
    label.font = [UIFont systemFontOfSize:16.f];
    label.textColor = [UIColor grayColor];
    label.text = @"分享新鲜事...";
    [self.textView addSubview:label];
    self.label = label;
    self.textView.delegate = self;
    
    //如果之前保存有草稿
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *status = [defaults objectForKey:@"status"];
    if (status) {
        self.textView.text = status;
        //清空内同
        [defaults setObject:nil forKey:@"status"];
    }
    
    
    
    if (self.type == kReportsStatus) {
        //如果是转发微博
        UIView *view = [[[NSBundle mainBundle] loadNibNamed:@"ReportsView" owner:self options:nil] objectAtIndex:0];
        self.tableView.tableFooterView = view;
        //绑定内容
        [self.reportsIcon sd_setImageWithURL:[NSURL URLWithString:self.reportsStatus.user.profileImageURL]];
        self.reportsName.text = self.reportsStatus.user.name;
        self.reportsText.text = self.reportsStatus.text;
        
    }else if (self.type == kWriteStatus){
        //默认空内容，不能发送。
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
    
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.type == kWriteStatus) {
        [self layoutImage:self.sendImages forView:self.imageSuperView];
    }
    
    
}

-(void)layoutImage:(NSArray *)images forView:(UIView *)view{
    //1.移除所有的子视图
    NSArray *subViews = view.subviews;
    [subViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    //调整imageSuperView到合适的高度
    CGFloat imageSuperViewHeight = [SendStatusViewController imageSuperViewHeight4Images:images];
    CGRect frame = view.frame;
    frame.size.height = imageSuperViewHeight;
    view.frame = frame;
    
    //添加新的ImageView
    
    for (int i = 0 ; i < images.count; i ++) {
        CGFloat imageX = i%kLineCount * (kImageWidth + kImagemarge);
        CGFloat imageY = i/3*(kImageHeight + kImagemarge);
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageX, imageY, kImageWidth, kImageHeight)];
        imageView.image = images[i];
        [view addSubview:imageView];
    }
    
    //最后添加一个加号按钮
    int i = images.count;
    CGFloat imageX = i%kLineCount * (kImageWidth + kImagemarge);
    CGFloat imageY = i/3*(kImageHeight + kImagemarge);
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(imageX, imageY, kImageWidth, kImageHeight)];
    [button setBackgroundColor:[UIColor grayColor]];
    [button setTitle:@"+" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(addImage) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    
}

-(void)addImage{
    UIImagePickerController *imagepicker = [[UIImagePickerController alloc] init];
    //指定为图片选择器
    imagepicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagepicker.delegate = self;
    //显示
    [self presentViewController:imagepicker animated:YES completion:nil];
    
}

//计算图片显示需要的高度
+(CGFloat)imageSuperViewHeight4Images:(NSArray *)images{

    //加上加号按钮
    NSInteger count = images.count + 1;
    
    //计算出图片的需要的行数
    NSInteger line = (count - 1)/kLineCount + 1;
    
    
    //    图片显示需要的高度
    NSInteger imageHeight = line *kImageHeight + (line - 1)*kImagemarge;
    return imageHeight;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)cancel:(id)sender {
//    [self dismissViewControllerAnimated:YES completion:nil];
    
    //如果用输入有内容，则保存到UserDefaults；
    if (self.textView.text != nil || ![self.textView.text isEqualToString:@""]) {
        NSUserDefaults *userDe = [NSUserDefaults standardUserDefaults];
        [userDe setObject:self.textView.text forKey:@"status"];
        [userDe synchronize];
    }
    
    //通过通知，通知根视图控制器，取消modal， 可以两个modal一起消失
    [[NSNotificationCenter defaultCenter] postNotificationName:@"dismissModal" object:nil];
    
    
    
}

-(void)sendReportsStatus{
    //转发微博
    NSString *urlString = [kBaseURL stringByAppendingPathComponent:@"repost.json"];
    
    NSMutableDictionary *dic = [[Account sharedAccount] requestParameters];
    [dic setObject:self.reportsStatus.idStr forKey:@"id"];
    
    //转发微博允许内容为空
    if (self.textView.text && ![self.textView.text isEqualToString:@""]) {
        [dic setObject:self.textView.text forKey:@"status"];
    }
    
    //发送请求
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:urlString parameters:dic success:^void(AFHTTPRequestOperation * operation, id responseobject) {
        NSLog(@"%@", responseobject);
        
        
        //通过通知，通知根视图控制器，取消modal， 可以两个modal一起消失
        [[NSNotificationCenter defaultCenter] postNotificationName:@"dismissModal" object:nil];
        
    } failure:^void(AFHTTPRequestOperation * operation, NSError * error) {
        
    }];
}

-(void)sendStaus{
    //发送带图片的微博
    if (self.sendImages.count != 0) {
        NSString *urlString = [kBaseURL stringByAppendingPathComponent:@"upload.json"];
        NSMutableDictionary *dic = [[Account sharedAccount] requestParameters];
        [dic setObject:self.textView.text forKey:@"status"];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager POST:urlString parameters:dic constructingBodyWithBlock:^void(id<AFMultipartFormData> formData) {
            //将第0张转化为二进制数据
            NSData *imageData = UIImagePNGRepresentation(self.sendImages[0]);
            [formData appendPartWithFileData:imageData name:@"pic" fileName:@"statusImage" mimeType:@"image/jpeg"];
        } success:^void(AFHTTPRequestOperation * operation, id responseObject) {
            NSLog(@"%@", responseObject);
            //通过通知，通知根视图控制器，取消modal， 可以两个modal一起消失
            [[NSNotificationCenter defaultCenter] postNotificationName:@"dismissModal" object:nil];
        } failure:^void(AFHTTPRequestOperation * operation, NSError * error) {
            NSLog(@"%@", error);
            
        }];
        
        
    }else{
        //发送文字微博
        NSString *urlString = [kBaseURL stringByAppendingPathComponent:@"update.json"];
        
        NSMutableDictionary *dic = [[Account sharedAccount] requestParameters];
        [dic setObject:self.textView.text forKey:@"status"];
        //发送请求
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager POST:urlString parameters:dic success:^void(AFHTTPRequestOperation * operation, id responseobject) {
            NSLog(@"%@", responseobject);
            
            
            //通过通知，通知根视图控制器，取消modal， 可以两个modal一起消失
            [[NSNotificationCenter defaultCenter] postNotificationName:@"dismissModal" object:nil];
            
        } failure:^void(AFHTTPRequestOperation * operation, NSError * error) {
            
        }];
        
    }

}

//发送微博
- (IBAction)sender:(id)sender {
    
    if (self.type == kReportsStatus) {
        //转发微博
        [self sendReportsStatus];
    }else{
        //发送普通微博
        [self sendStaus];
    }
    
    
    
    
    
}

#pragma mark - text View delegate

-(void)textViewDidChange:(UITextView *)textView{
    if (self.textView.text == nil || [self.textView.text isEqualToString:@""]) {
        //不能发送微博
        self.navigationItem.rightBarButtonItem.enabled = NO;
        self.label.hidden = NO;
    }else{
        self.navigationItem.rightBarButtonItem.enabled = YES;
        self.label.hidden = YES;
    }
}

//控制占位符的显示
//-(void)textViewDidBeginEditing:(UITextView *)textView{
//    
//}
//
//-(void)textViewDidEndEditing:(UITextView *)textView{
//    if (self.textView.text == nil || [self.textView.text isEqualToString:@""]) {
//        
//    }
//}

#pragma mark - image picker delegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    if (!self.sendImages) {
        self.sendImages = [NSMutableArray array];
    }
    //更改数据源
    [self.sendImages addObject:image];
    //更新UI
    [self layoutImage:self.sendImages forView:self.imageSuperView];
    //重新设置，更新tableView
    [self.tableView setTableFooterView:self.imageSuperView];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
