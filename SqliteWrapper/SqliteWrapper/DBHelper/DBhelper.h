//
//  DBhelper.h
//  SqliteWrapper
//
//  Created by Cellpointmobile on 11/06/16.
//  Copyright © 2016 Swapnil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DBhelper : NSObject
@property (strong , nonatomic) NSString *databasePath;
@property (nonatomic, strong) dispatch_queue_t databaseQueue;


+(DBhelper*)getSharedInstance;

-(void)createDBwithName:(NSString *)dbName;

-(void)createTableNamed :(NSString *)tableName usingQuery:(NSString *)createTableQuery forDatabaseNamed:(NSString *)dbName;

-(void)performInsertUpdateDeleteOperationInDatabseNamed:(NSString *)dbName insideTableNamed:(NSString *)tableName withQuery:(NSString *)query;



@end
