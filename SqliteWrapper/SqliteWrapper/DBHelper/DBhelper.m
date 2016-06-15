//
//  DBhelper.m
//  SqliteWrapper
//
//  Created by Cellpointmobile on 11/06/16.
//  Copyright © 2016 Swapnil. All rights reserved.
//

#import "DBhelper.h"


static DBhelper *sharedInstance = nil;
static sqlite3 *database = nil;
static sqlite3_stmt *statement = nil;


@implementation DBhelper



+(DBhelper*)getSharedInstance{
    if (!sharedInstance) {
        sharedInstance = [[super allocWithZone:NULL]init];
        [sharedInstance initializDatabaseQueue];
    }
    return sharedInstance;
}


-(void)initializDatabaseQueue
{
    self.databaseQueue =  dispatch_queue_create("com.swapnil.app.database", 0);
    NSLog(@"Threadsafe check : %d",sqlite3_threadsafe());
}
-(void)createDBwithName:(NSString *)dbName{
    
    dispatch_sync(self.databaseQueue, ^{
        // do your database activity here
        
        NSString *docsDir;
        NSArray *dirPaths;
        NSString *dbNameWithoutExtension = [[dbName lastPathComponent] stringByDeletingPathExtension];
        if(dbNameWithoutExtension == nil)
        {
            dbNameWithoutExtension = dbName;
        }
        // Get the documents directory
        dirPaths = NSSearchPathForDirectoriesInDomains
        (NSDocumentDirectory, NSUserDomainMask, YES);
        docsDir = dirPaths[0];
        NSLog(@"docs dirpath : %@",docsDir);
        // Build the path to the database file
        self.databasePath = [[NSString alloc] initWithString:
                             [docsDir stringByAppendingPathComponent: [NSString stringWithFormat:@"%@.sqlite",dbNameWithoutExtension]]];
        BOOL isSuccess = YES;
        NSFileManager *filemgr = [NSFileManager defaultManager];
        if ([filemgr fileExistsAtPath: self.databasePath ] == NO)
        {
            const char *dbpath = [self.databasePath UTF8String];
            
            if (sqlite3_open(dbpath, &database) == SQLITE_OK)
            {
                
                sqlite3_close(database);
                 NSLog(@"Success in to open/create database");
               
            }
            else {
                isSuccess = NO;
                NSLog(@"Failed to open/create database");
            }
        }
        ;
        if (isSuccess) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:dbNameWithoutExtension];
        }
        else
        {
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:dbNameWithoutExtension];
        }

        
    });
   
   
}


-(void)createTableNamed :(NSString *)tableName usingQuery:(NSString *)createTableQuery forDatabaseNamed:(NSString *)dbName
{
    NSString *dbNameWithoutExtension = [[dbName lastPathComponent] stringByDeletingPathExtension];
    if(dbNameWithoutExtension == nil)
    {
        dbNameWithoutExtension = dbName;
    }
    
    BOOL isDBCreatedSuccessfully = [[NSUserDefaults standardUserDefaults] valueForKey:dbNameWithoutExtension];
    
  BOOL isTableNamePresentInQuery = [createTableQuery containsString:[NSString stringWithFormat:@"create table"]];
    if (isDBCreatedSuccessfully && isTableNamePresentInQuery) {
        BOOL istableCreated  = YES;
        const char *dbpath = [self.databasePath UTF8String];
        if (sqlite3_open(dbpath, &database) == SQLITE_OK)
        {
            char *errMsg;
            const char *sql_stmt = [createTableQuery UTF8String];
            if (sqlite3_exec(database, sql_stmt, NULL, NULL, &errMsg)
                != SQLITE_OK)
            {
                istableCreated = NO;
                NSLog(@"Failed to create table");
            }
            else
            {
                NSLog(@"Success fully created table");
            }
            [[NSUserDefaults standardUserDefaults] setBool:istableCreated forKey:tableName];
            sqlite3_close(database);
        }

    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:tableName];
        NSLog(@"database not created");
    }
    
 }

-(void)performInsertUpdateDeleteOperationInDatabseNamed:(NSString *)dbName insideTableNamed:(NSString *)tableName withQuery:(NSString *)query
{
    NSString *dbNameWithoutExtension = [[dbName lastPathComponent] stringByDeletingPathExtension];
    if(dbNameWithoutExtension == nil)
    {
        dbNameWithoutExtension = dbName;
    }
    
    BOOL isDBCreatedSuccessfully = [[NSUserDefaults standardUserDefaults] valueForKey:dbNameWithoutExtension];
    BOOL isTablePresent  = [[NSUserDefaults standardUserDefaults] valueForKey:tableName];
    
    if (isDBCreatedSuccessfully && isTablePresent) {
        // execute query
        
        const char *dbpath = [self.databasePath UTF8String];
        if (sqlite3_open(dbpath, &database) == SQLITE_OK)
        {
            
            dispatch_sync(self.databaseQueue, ^{
                // do your database activity here
                
                NSString *querySQL = query;
                const char *insert_stmt = [querySQL UTF8String];
                sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
                if (sqlite3_step(statement) == SQLITE_DONE)
                {
                    NSLog(@"DB Operation successful");
                }
                else {
                    NSLog(@"DB Operation failed");
                }
                sqlite3_reset(statement);
            });

        }
        
    }
    else
    {
        NSLog(@"Either DB or Table not present");
    }
}




@end
