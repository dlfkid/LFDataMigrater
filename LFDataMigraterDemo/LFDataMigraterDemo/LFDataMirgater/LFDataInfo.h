//
//  LFDataInfo.h
//  LFDataMigraterDemo
//
//  Created by LeonDeng on 2019/8/5.
//  Copyright © 2019 LeonDeng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LFDataInfo : NSObject

@property (nonatomic, copy, readonly) NSString *dataBaseName;
@property (nonatomic, copy, readonly) NSString *version;
@property (nonatomic, strong, readonly) NSDate *lastUpdate;
@property (nonatomic, copy, readonly) NSString *lastUpdateString;


@end

NS_ASSUME_NONNULL_END
