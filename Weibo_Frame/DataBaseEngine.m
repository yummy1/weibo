//
//  DataBaseEngine.m
//  Weibo_Frame
//
//  Created by qingyun on 15/9/2.
//  Copyright (c) 2015年 河南青云信息技术有限公司. All rights reserved.
//

#define kDataBaseName @"status.db"//数据库的名字
#define kStatusTable @"status"//表名

#import "DataBaseEngine.h"
#import "NSObject+Tool.h"
#import "FMDB.h"
#import "Status.h"

@implementation DataBaseEngine

/**
 *  1.运行程序先判断documents下有没有数据库文件.不存在的话从boundlcopy到documents
 */
+(void)initialize{
    if (self == [DataBaseEngine self]) {
        //将数据库copy 到documents下
        [DataBaseEngine copyDB2Documents];
        
    }
}

+(void)copyDB2Documents{
    NSString *sourcePath = [[NSBundle mainBundle] pathForResource:kDataBaseName ofType:nil];
    NSString *toPath = [NSObject filePathForDocuments:kDataBaseName];
    //当documents不存在数据库文件
    NSFileManager *fileManager  = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:toPath]) {
        NSError *error;
        [fileManager copyItemAtPath:sourcePath toPath:toPath error:&error];
    }
    
}

//查询table的所有字段名
+(NSArray *)tableColumn:(NSString *)tableName{
    //creat db
    FMDatabase *db = [FMDatabase databaseWithPath:[NSObject filePathForDocuments:kDataBaseName]];
    //打开数据库
    [db open];
    FMResultSet *resultSet = [db getTableSchema:tableName];
    NSMutableArray *columns = [NSMutableArray array];
    while ([resultSet next]) {
        //查询出字段的名字
        NSString *column = [resultSet objectForColumnName:@"name"];
        //保存到数组中
        [columns addObject:column];
    }
    return columns;
}


+(NSString *)createdSQLWithColumns:(NSArray *)Columns TableName:(NSString *)tableName{
//    @"insert into tableName (columns) values(:key",
//    :key1, :key2, :key3
    //构造字段字符串
    NSString *columnsName = [Columns componentsJoinedByString:@", "];
    //构造key的字符串
    NSString *keyString = [Columns componentsJoinedByString:@", :"];
    keyString = [@":" stringByAppendingString:keyString];
    
    return [NSString stringWithFormat:@"insert into %@ (%@) values(%@)" ,tableName,columnsName,keyString];
}

+(void)saveStatuses2Database:(NSArray *)statuses{
    //1.table coulomn
    NSArray *tableColumns = [DataBaseEngine tableColumn:kStatusTable];
    
    //创建操作队列
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[NSObject filePathForDocuments:kDataBaseName]];
    [queue inDatabase:^(FMDatabase *db) {
        
        for (NSDictionary *statusInfo in statuses) {
            //2.筛选出要插入的字段
            
            //存放相同的key
            NSMutableArray *allkey = [NSMutableArray array];
            
            //存放要保存的键值
            NSMutableDictionary *resultDic = [NSMutableDictionary dictionary];
            
            //网络数据的所有字段
            NSArray *statusKey = [statusInfo allKeys];
            
            
            for (NSString *column in tableColumns) {
                //判断两者有的key
                if ([statusKey containsObject:column]) {
                    //将key保存
                    [allkey addObject:column];
                    
                    //保存到字典中
                    //如果值是字典或者数组
                    id value = statusInfo[column];
                    if ([value isKindOfClass:[NSDictionary class]] || [value isKindOfClass:[NSArray class]]) {
                        //有对象转化为二进制数据
                        value = [NSKeyedArchiver archivedDataWithRootObject:value];
                    }
                    
                    [resultDic setObject:value forKey:column];
                    
                }
            }
            
            //3.构建sql语句
            NSString *sql = [DataBaseEngine createdSQLWithColumns:allkey TableName:kStatusTable];
            
            //执行插入
            BOOL result = [db executeUpdate:sql withParameterDictionary:resultDic];
            NSLog(@"%d", result);
            
            
        }
    }];
    
    //3.构建插入语句
    //4.执行插入
}

+(NSArray *)statusesFromDB{
    //1.创建数据库对象
    FMDatabase *db = [FMDatabase databaseWithPath:[NSObject filePathForDocuments:kDataBaseName]];
    //2.数据库查询语句
    NSString *sql = @"select * from status order by id desc limit 20";
//    3.打开数据库
    [db open];
    FMResultSet *resultSet = [db executeQuery:sql];
    NSMutableArray *resultDic = [NSMutableArray array];
    while ([resultSet next]) {
        //一条记录转化为一个字典
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[resultSet resultDictionary]];
        
        NSArray *allkey = dic.allKeys;
        //将二进制数据转化为对象
        for (int i = 0; i < allkey.count; i ++) {
            id value = dic[allkey[i]];
            if ([value isKindOfClass:[NSData class]]) {
                //value解档
                value = [NSKeyedUnarchiver unarchiveObjectWithData:value];
                [dic setValue:value forKey:allkey[i]];
            }
            
            //删除掉null对象
            if ([value isKindOfClass:[NSNull class]]){
                [dic removeObjectForKey:allkey[i]];
            }
            
        }
        
        
        
        //将字典转化为model
        Status *status = [[Status alloc] initStatusWith:dic];
        
        [resultDic addObject:status];
    }
    
    //返回查询的结果，
    return resultDic;
}


@end
