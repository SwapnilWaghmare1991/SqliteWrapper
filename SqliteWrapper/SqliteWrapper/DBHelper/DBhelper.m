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


// get shared instance
+(DBhelper*)getSharedInstance{
    if (!sharedInstance) {
        sharedInstance = [[super allocWithZone:NULL]init];
        [sharedInstance initializDatabaseQueue];
    }
    return sharedInstance;
}

// making database threadsafe.. at a  time only one thread can access
-(void)initializDatabaseQueue
{
    self.databaseQueue =  dispatch_queue_create("com.swapnil.app.database", 0);
    NSLog(@"Threadsafe check : %d",sqlite3_threadsafe());
}

// create database...sqlite files in Document directory
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

// create table inside selected database using mentioned query
-(void)createTableNamed :(NSString *)tableName usingQuery:(NSString *)createTableQuery forDatabaseNamed:(NSString *)dbName
{
    // check for db name...remove extension if exist
    NSString *dbNameWithoutExtension = [[dbName lastPathComponent] stringByDeletingPathExtension];
    if(dbNameWithoutExtension == nil)
    {
        dbNameWithoutExtension = dbName;
    }
    // check for db created successfully or not
    BOOL isDBCreatedSuccessfully = [[NSUserDefaults standardUserDefaults] valueForKey:dbNameWithoutExtension];

    // chcek if query is create table or not
  BOOL isTableNamePresentInQuery = [createTableQuery containsString:[NSString stringWithFormat:@"create table"]];
    // if true
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
                 // wrong query of create table
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
        // database not exist
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:tableName];
        NSLog(@"database not created");
    }
    
 }


// perform insert update delete operations indatabase
-(void)performInsertUpdateDeleteOperationInDatabseNamed:(NSString *)dbName insideTableNamed:(NSString *)tableName withQuery:(NSString *)query
{
    // check for db name...remove extension if exist
    
    
    NSString *dbNameWithoutExtension = [[dbName lastPathComponent] stringByDeletingPathExtension];
    if(dbNameWithoutExtension == nil)
    {
        dbNameWithoutExtension = dbName;
    }
    // check for db created successfully or not
    BOOL isDBCreatedSuccessfully = [[NSUserDefaults standardUserDefaults] valueForKey:dbNameWithoutExtension];
    
    // chcek if query is create table or not
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
    {   // db ot table not present
        NSLog(@"Either DB or Table not present");
    }
}


-(NSMutableArray *)getDataFromDatabaseNamed:(NSString *)dbName fromTableNamed:(NSString *)tableName usingQuery:(NSString *)query
{
    NSString *dbNameWithoutExtension = [[dbName lastPathComponent] stringByDeletingPathExtension];
    if(dbNameWithoutExtension == nil)
    {
        dbNameWithoutExtension = dbName;
    }
    // check for db created successfully or not
    BOOL isDBCreatedSuccessfully = [[NSUserDefaults standardUserDefaults] valueForKey:dbNameWithoutExtension];
    
    // chcek if query is create table or not
    BOOL isTablePresent  = [[NSUserDefaults standardUserDefaults] valueForKey:tableName];
    NSMutableArray *finalArray  = nil;
    if (isDBCreatedSuccessfully && isTablePresent) {
        
        const char *dbpath = [self.databasePath UTF8String];
        if (sqlite3_open(dbpath, &database) == SQLITE_OK)
        {
            NSString *querySQL = query;
            const char *query_stmt = [querySQL UTF8String];
            NSMutableArray *keyArray = [self tableInfo:tableName];
            finalArray = [[NSMutableArray alloc] init];
            if (sqlite3_prepare_v2(database,query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
              
                
                while (sqlite3_step(statement) == SQLITE_ROW)
                {
                      NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                    for (int i = 0; i < [keyArray count] ; i++) {
                        id val  = (__bridge id)(sqlite3_column_value(statement, i));
                        [dict setObject:val forKey:[keyArray objectAtIndex:i]];
                    }
                    [finalArray addObject:dict];
                    

                }
                
                sqlite3_reset(statement);
            }
        }
    }
    return finalArray;
  
}

// drop table
-(void)dropTable:(NSString *)tablename
{
    const char *dbpath = [self.databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        const char *dropTable = [[NSString stringWithFormat:@"DROP table %@",tablename] UTF8String];
        sqlite3_prepare_v2(database, dropTable,
                           -1, &statement, NULL);
        dispatch_sync(self.databaseQueue, ^{
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"table dropped");
            }
            
            else
            {
                NSLog(@"table not dropped");
            }
        });
       
    }
    
    else
    {
        NSLog(@"Not opened for dropping");
    }
}
-(NSMutableArray*)tableInfo:(NSString *)table{
    
    sqlite3_stmt *sqlStatement;
    
    NSMutableArray *result = [NSMutableArray array];
    
    const char *sql = [[NSString stringWithFormat:@"PRAGMA table_info('%@')",table] UTF8String];
    
    if(sqlite3_prepare(database, sql, -1, &sqlStatement, NULL) != SQLITE_OK)
        
    {
        NSLog(@"Problem with prepare statement tableInfo %@",
              [NSString stringWithUTF8String:(const char *)sqlite3_errmsg(database)]);
        
    }
    
    while (sqlite3_step(sqlStatement)==SQLITE_ROW)
    {
        [result addObject:
         [NSString stringWithUTF8String:(char*)sqlite3_column_text(sqlStatement, 1)]];
    }
    
    return result;
}


@end
