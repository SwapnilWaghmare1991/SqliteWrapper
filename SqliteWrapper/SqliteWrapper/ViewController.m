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
    // create database employee
    //[dbinst1 createDBwithName:DBEmployee];
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
    
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
