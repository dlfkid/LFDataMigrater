//
//  LFDataMigrater.h
//  LFDataMigraterDemo
//
//  Created by LeonDeng on 2019/8/5.
//  Copyright © 2019 LeonDeng. All rights reserved.
//

@class LFDataInfo;

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol LFDataMigraterDelegate <NSObject>

- (void)lf_updateDataBaseWithVersion:(NSNumber *)version;

- (void)lf_initDatabaseWithInfo:(LFDataInfo *)dataBaseInfo;

@end

@interface LFDataMigrater : NSObject

@property (nonatomic, weak) NSObject <LFDataMigraterDelegate> *delegate;

- (instancetype)initWithDataBaseInfo:(LFDataInfo *)dataBaseInfo LatestVersion:(NSNumber *)latestVersion;

- (void)lf_migrateDataBaseToVersion:(NSNumber *)dataBaseVersion Completion:(void (^)(NSError * _Nullable error))completion;

@end

NS_ASSUME_NONNULL_END
