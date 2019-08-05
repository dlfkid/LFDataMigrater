//
//  LFDataInfo.m
//  LFDataMigraterDemo
//
//  Created by LeonDeng on 2019/8/5.
//  Copyright © 2019 LeonDeng. All rights reserved.
//

#import "LFDataInfo.h"

@interface LFDataInfo() <NSSecureCoding>

@property (nonatomic, copy) NSString *dataBaseName;
@property (nonatomic, copy) NSString *version;
@property (nonatomic, strong) NSDate *lastUpdate;
@property (nonatomic, copy) NSString *lastUpdateString;

@end

@implementation LFDataInfo

#pragma mark - Public

+ (instancetype)infoWithDataBaseNanme:(NSString *)dataBaseName Error:(NSError **)error {
    NSData *encryptData = [NSKeyedUnarchiver unarchiveObjectWithFile:[self archivePathWithDataBaseName:dataBaseName]];
    if (@available(iOS 11.0, *)) {
        LFDataInfo *dataBaseInfo = [NSKeyedUnarchiver unarchivedObjectOfClass:[LFDataInfo class] fromData:encryptData error:error];
        if (error) {
            return nil;
        } else {
            return dataBaseInfo;
        }
    } else {
        // Fallback on earlier versions
        LFDataInfo *dataBaseInfo = [NSKeyedUnarchiver unarchiveObjectWithData:encryptData];
        return dataBaseInfo;
    }
}

#pragma mark - Private

- (NSString *)archivePath {
    return [LFDataInfo archivePathWithDataBaseName:self.dataBaseName];
}

+ (NSString *)archivePathWithDataBaseName:(NSString *)dataBaseName {
    NSString *sandBoxPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSString *filePath = [sandBoxPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.data", dataBaseName]];
    return filePath;
}

#pragma mark - NSSecureCoding

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.dataBaseName forKey:@"dataBaseName"];
    [coder encodeObject:self.version forKey:@"version"];
    [coder encodeObject:self.lastUpdate forKey:@"lastUpdate"];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        self.dataBaseName = [coder decodeObjectForKey:@"dataBaseName"];
        self.version = [coder decodeObjectForKey:@"version"];
        self.lastUpdate = [coder decodeObjectForKey:@"lastUpdate"];
    }
    return self;
}

@end
