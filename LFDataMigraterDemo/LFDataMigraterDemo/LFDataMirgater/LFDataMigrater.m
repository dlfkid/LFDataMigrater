//
//  LFDataMigrater.m
//  LFDataMigraterDemo
//
//  Created by LeonDeng on 2019/8/5.
//  Copyright © 2019 LeonDeng. All rights reserved.
//

#import "LFDataMigrater.h"
// Models
#import "LFDataInfo.h"
#import "NSError+LFDataMigrater.h"

@interface LFDataMigrater()

@property (nonatomic, strong) LFDataInfo *dbInfo;
@property (nonatomic, strong) NSNumber *latestVersion;

@end

@implementation LFDataMigrater

- (instancetype)initWithDataBaseInfo:(LFDataInfo *)dataBaseInfo LatestVersion:(NSNumber *)latestVersion {
    if ([super init]) {
        _dbInfo = dataBaseInfo;
        _latestVersion = latestVersion;
    }
    return self;
}

- (void)lf_migrateDataBaseToVersion:(NSNumber *)dataBaseVersion Completion:(void (^)(NSError * _Nullable))completion {
    if (dataBaseVersion.integerValue > self.latestVersion.integerValue) { // 比已定义的最高版本还要高
        completion([NSError migraterErrorWithCode:LFDataMigraterErrorCodeVersionInvalid Description:@"Target version is higher than the latest version defined when the migrater was initialized"]);
        return;
    }
    
    if (dataBaseVersion.integerValue == self.dbInfo.version.integerValue) { // 目标版本就是当前版本
        completion(nil);
        return;
    }
    
    if (dataBaseVersion.integerValue > self.dbInfo.version.integerValue) { // 目标版本高于当前版本，执行升级
        for (int i = self.dbInfo.version.intValue; i < dataBaseVersion.intValue; i ++) {
            if ([self.delegate respondsToSelector:@selector(lf_updateDataBaseWithVersion:)]) {
                [self.delegate lf_updateDataBaseWithVersion:@(i)];
            } else {
                completion([NSError migraterErrorWithCode:LFDataMigraterErrorCodeMethodNotImplement Description:@"Protocol method not implemented"]);
                return;
            }
        }
    }
    
    if(dataBaseVersion.integerValue < self.dbInfo.version.integerValue) { // 目标版本低于当前版本，执行降级
        // 首先判断数据库是否存在
        if ([[NSFileManager defaultManager] fileExistsAtPath:self.dbInfo.dataBaseFilePath]) { // 数据库存在需要删除
            NSError *fileManageError = nil;
            [[NSFileManager defaultManager] removeItemAtPath:self.dbInfo.dataBaseFilePath error:&fileManageError];
            if (fileManageError) { // 删除失败，直接返回
                completion(fileManageError);
                return;
            }
        }
        
        // 重新创建数据库
        if([self.delegate respondsToSelector:@selector(lf_initDatabaseWithInfo:)]) {
            [self.delegate lf_initDatabaseWithInfo:self.dbInfo];
            // 创建数据库成功，重置版本号, 执行数据库升级
            self.dbInfo.version = @(0);
            for (int i = self.dbInfo.version.intValue; i < dataBaseVersion.intValue; i ++) {
                if ([self.delegate respondsToSelector:@selector(lf_updateDataBaseWithVersion:)]) {
                    [self.delegate lf_updateDataBaseWithVersion:@(i)];
                } else {
                    completion([NSError migraterErrorWithCode:LFDataMigraterErrorCodeMethodNotImplement Description:@"Protocol method not implemented"]);
                    return;
                }
            }
        } else {
            completion([NSError migraterErrorWithCode:LFDataMigraterErrorCodeMethodNotImplement Description:@"Protocol method not implemented"]);
            return;
        }
    }
}




@end
