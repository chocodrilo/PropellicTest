//
//  SQLiteDataSource.h
//  MyTodos
//
//  Created by iOS developer on 5/6/15.
//  Copyright (c) 2015 Chocodrilo INC. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface SQLiteDataSource : NSObject
{
    NSString *dbPath;
    NSDateFormatter *insertDateTimeFormatter;
}

-(id)executeQuery:(NSString *)query;
-(id)executeSingleSelect:(NSString *)tableName andColumnNames:(NSArray *)columnNames andFilter:(NSDictionary *)filterData andLimit:(int)limit;
-(BOOL)executeInsertOperation:(NSString *)tableName andData:(NSDictionary *)insertData;
-(NSString *)executeUpdateOperation:(NSString *)tableName andData:(NSDictionary *)updateData andFilter:(NSDictionary *)filterData;
-(BOOL)executeDeleteOperation:(NSString *)tableName andFilter:(NSDictionary *)filter;


@end