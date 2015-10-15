//
//  Account.m
//  Weibo_Frame
//
//  Created by qingyun on 15/8/27.
//  Copyright (c) 2015年 河南青云信息技术有限公司. All rights reserved.
//

#import "Account.h"
#import "Common.h"
#import "NSObject+Tool.h"

#define kAccountFileName @"account"

@interface Account ()<NSCoding>

@property (nonatomic, strong)NSString *accessToken;//访问令牌
@property (nonatomic, strong)NSDate *expires;//有效时间
@property (nonatomic, strong)NSString *uid;//用户的id
@end

@implementation Account

static Account *account;

+(instancetype)sharedAccount{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSString *filePah = [NSObject filePathForDocuments:kAccountFileName];
        //解档对象
        account = [NSKeyedUnarchiver unarchiveObjectWithFile:filePah];
        //如果解档文件不存在，对象为空
        if (!account) {
            account = [[Account alloc] init];
        }
    });
    
    return account;
}

-(NSString *)currentUserUid{
    return self.uid;
}

-(void)saveLoginInfo:(NSDictionary *)info{
    self.accessToken = info[kAccessToken];
    
    //有效时间
    self.expires = [[NSDate date] dateByAddingTimeInterval:[info[kExpiresIn] doubleValue]];
    self.uid = info[kUID];
    
    //保存到物理文件中
    [NSKeyedArchiver archiveRootObject:account toFile:[NSObject filePathForDocuments:kAccountFileName]];
    
}

-(BOOL)isLogin{
    //比较时间，有效的截止时间，更当前时间对比
    NSComparisonResult result = [self.expires compare:[NSDate date]];
    //存在token并在有效时间内
    if (self.accessToken && result == NSOrderedDescending) {
        return YES;
    }
    return NO;
}

-(void)logout{
//    删除内存中的登录信息
    self.accessToken = nil;
    self.expires = nil;
    self.uid = nil;
    
    //删除归档信息
    NSString *filePath = [NSObject filePathForDocuments:kAccountFileName];
    //删除文件
    [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
}

#pragma mark - coding

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        self.accessToken = [aDecoder decodeObjectForKey:kAccessToken];
        self.expires = [aDecoder decodeObjectForKey:kExpiresIn];
        self.uid = [aDecoder decodeObjectForKey:kUID];
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.accessToken forKey:kAccessToken];
    [coder encodeObject:self.expires forKey:kExpiresIn];
    [coder encodeObject:self.uid forKey:kUID];
}

-(NSMutableDictionary *)requestParameters{
    //返回一个包含token的可变字典
    if ([self isLogin]) {
        NSMutableDictionary *para = [NSMutableDictionary dictionary];
        [para setObject:self.accessToken forKey:kAccessToken];
        return para;
    }
    return nil;
}

@end
