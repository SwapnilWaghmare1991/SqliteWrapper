//
//  ViewController.m
//  SqliteWrapper
//
//  Created by Cellpointmobile on 11/06/16.
//  Copyright © 2016 Swapnil. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "DBhelper.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    DBhelper *dbinst1 = [DBhelper getSharedInstance];
   
    // create database person
    [dbinst1 createDBwithName:DBPerson];
    // create table in database employee
    NSString *createTableQuery1 = [NSString stringWithFormat:@"create table if not exists %@ (empID integer primary key, name text , department text)",TableEmployeeInDBEmployee];
    [dbinst1 createTableNamed:TableEmployeeInDBEmployee usingQuery:createTableQuery1 forDatabaseNamed:DBPerson];
    // create table in database person
    NSString *createTableQuery2 = [NSString stringWithFormat:@"create table if not exists %@ (regno integer primary key, name text, birthyear text)",TablePersonInDBPerson];
    [dbinst1 createTableNamed:TablePersonInDBPerson usingQuery:createTableQuery2 forDatabaseNamed:DBPerson];
    // insert data into employee database
    NSString *insertSQL1 = [NSString stringWithFormat:@"insert into %@ (empID,name, department) values(\"%d\",\"%@\", \"%@\")",TableEmployeeInDBEmployee,1, @"Swapnil", @"Mobile"];
    [dbinst1 performInsertUpdateDeleteOperationInDatabseNamed:DBPerson insideTableNamed:TableEmployeeInDBEmployee withQuery:insertSQL1];
    // insert data into person database
    NSString *insertSQL2 = [NSString stringWithFormat:@"insert into %@ (regno,name,birthyear) values(\"%d\",\"%@\",\"%@\")",TablePersonInDBPerson,1, @"Swapnil", @"1991"];
    [dbinst1 performInsertUpdateDeleteOperationInDatabseNamed:DBPerson insideTableNamed:TablePersonInDBPerson withQuery:insertSQL2];
    NSString *insertSQL3 = [NSString stringWithFormat:@"insert into %@ (regno,name,birthyear) values(\"%d\",\"%@\",\"%@\")",TablePersonInDBPerson,2, @"Amey", @"1991"];
    [dbinst1 performInsertUpdateDeleteOperationInDatabseNamed:DBPerson insideTableNamed:TablePersonInDBPerson withQuery:insertSQL3];
    NSString *insertSQL4 = [NSString stringWithFormat:@"insert into %@ (regno,name,birthyear) values(\"%d\",\"%@\",\"%@\")",TablePersonInDBPerson,3, @"Upendra", @"1991"];
    [dbinst1 performInsertUpdateDeleteOperationInDatabseNamed:DBPerson insideTableNamed:TablePersonInDBPerson withQuery:insertSQL4];
    NSString *insertSQL5 = [NSString stringWithFormat:@"insert into %@ (regno,name,birthyear) values(\"%d\",\"%@\",\"%@\")",TablePersonInDBPerson,4, @"Jayendra", @"1991"];
    [dbinst1 performInsertUpdateDeleteOperationInDatabseNamed:DBPerson insideTableNamed:TablePersonInDBPerson withQuery:insertSQL5];
    NSString *insertSQL6 = [NSString stringWithFormat:@"insert into %@ (regno,name,birthyear) values(\"%d\",\"%@\",\"%@\")",TablePersonInDBPerson,5, @"Akash", @"1991"];
    [dbinst1 performInsertUpdateDeleteOperationInDatabseNamed:DBPerson insideTableNamed:TablePersonInDBPerson withQuery:insertSQL6];
    NSString *insertSQL7 = [NSString stringWithFormat:@"insert into %@ (regno,name,birthyear) values(\"%d\",\"%@\",\"%@\")",TablePersonInDBPerson,6, @"Anuj", @"1991"];
    [dbinst1 performInsertUpdateDeleteOperationInDatabseNamed:DBPerson insideTableNamed:TablePersonInDBPerson withQuery:insertSQL7];
    NSString * fetchDataQuery = [NSString stringWithFormat:@"Select * from %@",TablePersonInDBPerson];
    NSString *insertSQL8 = [NSString stringWithFormat:@"insert into %@ (regno,name,birthyear) values(\"%d\",\"%@\",\"%@\")",TablePersonInDBPerson,7, @"Dipendra", @"1991"];
    [dbinst1 performInsertUpdateDeleteOperationInDatabseNamed:DBPerson insideTableNamed:TablePersonInDBPerson withQuery:insertSQL8];
    NSString *insertSQL9 = [NSString stringWithFormat:@"insert into %@ (regno,name,birthyear) values(\"%d\",\"%@\",\"%@\")",TablePersonInDBPerson,8, @"Rohan", @"1991"];
    [dbinst1 performInsertUpdateDeleteOperationInDatabseNamed:DBPerson insideTableNamed:TablePersonInDBPerson withQuery:insertSQL9];
    NSString *insertSQL10 = [NSString stringWithFormat:@"insert into %@ (regno,name,birthyear) values(\"%d\",\"%@\",\"%@\")",TablePersonInDBPerson,9, @"Ranjit", @"1991"];
    [dbinst1 performInsertUpdateDeleteOperationInDatabseNamed:DBPerson insideTableNamed:TablePersonInDBPerson withQuery:insertSQL10];
    NSString *insertSQL11 = [NSString stringWithFormat:@"insert into %@ (regno,name,birthyear) values(\"%d\",\"%@\",\"%@\")",TablePersonInDBPerson,10, @"Akshay", @"1991"];
    [dbinst1 performInsertUpdateDeleteOperationInDatabseNamed:DBPerson insideTableNamed:TablePersonInDBPerson withQuery:insertSQL11];
    
    NSString *insertSQL12 = [NSString stringWithFormat:@"insert into %@ (regno,name,birthyear) values(\"%d\",\"%@\",\"%@\")",TablePersonInDBPerson,11, @"Aman", @"1991"];
    [dbinst1 performInsertUpdateDeleteOperationInDatabseNamed:DBPerson insideTableNamed:TablePersonInDBPerson withQuery:insertSQL12];

    NSMutableArray *marrPersonInfo = [dbinst1 getDataFromDatabaseNamed:DBPerson fromTableNamed:TablePersonInDBPerson usingQuery:fetchDataQuery];
    NSLog(@"%@",marrPersonInfo);
    
    [dbinst1 dropTable:TableEmployeeInDBEmployee];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
