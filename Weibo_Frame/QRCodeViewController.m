//
//  QRCodeViewController.m
//  Weibo_Frame
//
//  Created by qingyun on 15/9/8.
//  Copyright (c) 2015年 河南青云信息技术有限公司. All rights reserved.
//

//二维码识别

#import "QRCodeViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "Common.h"

@interface QRCodeViewController ()<AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong) AVCaptureDevice *device;//采集用的硬件；
@property (nonatomic, strong) AVCaptureDeviceInput *input;//输入管道；
@property(nonatomic, strong) AVCaptureSession *session;//回话；
@property(nonatomic, strong) AVCaptureMetadataOutput *output;//输出数据；

@property (nonatomic, strong)UIView *preView;//显示预览效果

@property (nonatomic, weak)UIImageView *animationView;//动画的视图

@property (nonatomic, strong)NSTimer *timer;


@end

@implementation QRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    //显示预览层
    self.preView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.preView];
    
    //添加边框
    UIImage *image = [UIImage imageNamed:@"qrcode_border"];
    UIImage *borderImage = [image resizableImageWithCapInsets:UIEdgeInsetsMake(25, 25, 26, 26)];

    
    NSInteger margin = 70;//imageView边距；
    //图片的宽
    NSInteger imageW = kScreenWidth - margin * 2;
    
    //显示边框的imageView
    UIImageView *boundView = [[UIImageView alloc] initWithFrame:CGRectMake(margin, margin, imageW, imageW)];
    [boundView setImage:borderImage];
    [self.view addSubview:boundView];
    
    
    //添加上移动的动画的ImageView
    
    UIImageView *animationView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"qrcode_scanline_qrcode"]];
    animationView.frame = boundView.bounds;
    [boundView addSubview:animationView];
    self.animationView = animationView;
    
    //剪切掉子视图
    boundView.clipsToBounds = YES;
    
    
    
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.03f target:self selector:@selector(changeAnimation:) userInfo:nil repeats:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //开启二维码服务
    [self reading];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //停止二维码扫描
    [self stop];
}

#pragma mark - custom

-(void)changeAnimation:(NSTimer *)Timer{
    self.animationView.frame = CGRectOffset(self.animationView.frame, 0, 3.f);
    if (self.animationView.frame.origin.y >= self.animationView.frame.size.height) {
        self.animationView.frame = CGRectOffset(self.animationView.frame, 0, -self.animationView.frame.size.height *2);
    }
    
}

//开始二维码服务
-(void)reading{
    //1.构造device
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //2.构造input
    NSError *error;
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:&error];
    //3.构造output
    self.output = [[AVCaptureMetadataOutput alloc] init];
    
    //4.添加input和output到session
    self.session = [[AVCaptureSession alloc] init];
    [self.session addInput:self.input];
    [self.session addOutput:self.output];
    
    //5.设置out的支持的类型和代理
    [self.output setMetadataObjectTypes:@[AVMetadataObjectTypeCode128Code,
          AVMetadataObjectTypeCode39Code,
          AVMetadataObjectTypeQRCode]];
    
    dispatch_queue_t queue = dispatch_queue_create("myQueue", NULL);
    [self.output setMetadataObjectsDelegate:self queue:queue];
    
    //显示预览层
    
    AVCaptureVideoPreviewLayer *layer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    
    
    [self.preView.layer addSublayer:layer];
    
    [layer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [layer setFrame:self.preView.bounds];
    
    
    
    //添加遮罩层
    
    //开始绘制一张图片
    UIGraphicsBeginImageContextWithOptions( self.preView.bounds.size, NO, [[UIScreen mainScreen] scale]);

    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //添加外层的半透明效果
    //设置半透明填充色
    CGContextSetRGBFillColor(context, 0, 0, 0, .9f);
    //绘制矩形区域
    CGContextAddRect(context, self.preView.bounds);
    //填充内容
    CGContextFillPath(context);
    
    //绘制中间完全不透明区域
    //设置填充色
    CGContextSetRGBFillColor(context, 1, 1, 1, 1.f);
    
    //在边框区域填充颜色
    CGContextAddRect(context, self.animationView.superview.frame);
    //绘制内容
    CGContextFillPath(context);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CALayer *maskLayer = [[CALayer alloc] init];
    maskLayer.bounds = self.preView.bounds;
    maskLayer.position = self.preView.center;
    maskLayer.contents = (__bridge id)(image.CGImage);
    //预览层layer的mask
    layer.mask = maskLayer;
    layer.masksToBounds = YES;
    
    
    
    
    
    
    
    
    
    
    
    //开启服务
    [self.session startRunning];
}

//停止二维码服务
-(void)stop{
    [self.session stopRunning];
}
- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - QRCode delegte

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    //显示元数据
    if (metadataObjects.count != 0) {
        AVMetadataMachineReadableCodeObject *code = [metadataObjects objectAtIndex:0];
        NSLog(@"%@", code.stringValue);
        [self performSelectorOnMainThread:@selector(stop) withObject:nil waitUntilDone:NO];
    }
    
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
