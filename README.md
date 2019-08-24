# LFDataMigrater
A small tool in helping you migrate your persistence data base to one version to another with pure objective-C code, all kinds of storage style (sqlite3/coreData) compatible.

# Features

1. Protocol based design
2. When implemented, manage your data base in version control
3. Migrate data base from lower version to higher version.
4. Migrate data base from higher version to lower version. (**Doing this will erase all reamining data, becareful with that**)

# Usage
```objc
// 1.Initalize Migrater
    NSString *dataBaseName = @"MyDataBase";
    NSString *dataBasePath = @"Persistence/MyDataBase.db";
    LFDataMigrater *migrater = [[LFDataMigrater alloc] initWithDataBaseName:dataBaseName Path:dataBasePath];
    
    // You can check your dataBase's info whenever you like, if not exist, Migrater will create one for you.
    LFDataInfo *dbInfo = migrater.dbInfo;
    NSLog(@"Current DB namae: %@, Version: %@", dbInfo.dataBaseName, dbInfo.version);
    
    // 2.Call migrate method
    [migrater lf_migrateDataBaseToHigherVersion:@(latestDBVersion) Completion:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"Data base update failed with error: %@", error.localizedDescription);
        } else {
            NSLog(@"Data base update success, version: %ld", (long)latestDBVersion);
        }
    }];

// This delegate method will called when needed
- (void)lf_initDatabaseWithInfo:(nonnull LFDataInfo *)dataBaseInfo {
    // initialize Your data base here
    NSString *dataBaseName = dataBaseInfo.dataBaseName;
    NSString *path = dataBaseInfo.dataBaseFilePath;
    NSLog(@"Building data base %@ in path %@", dataBaseName, path);
}

// Define each version of your data base
- (void)lf_updateDataBaseWithVersion:(nonnull NSNumber *)version {
    switch (version.integerValue) {
        case 0:
            // Update Data base to version 0
            break;
            
        case 1:
            // Update Data base from verison 0 to version 1
            break;
            
        default:
            // Handle hundefined versions
            break;
    }
}

```

# License and Credits
LFDataMigrater is available under the MIT license. See the LICENSE file for more info.