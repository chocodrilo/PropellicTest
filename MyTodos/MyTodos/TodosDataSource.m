//
//  TodosDataSource.m
//  MyTodos
//
//  Created by iOS developer on 5/6/15.
//  Copyright (c) 2015 Chocodrilo INC. All rights reserved.
//

#import "TodosDataSource.h"
//#import "DatabaseConstants.m"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"

@implementation TodosDataSource

#pragma mark
#pragma mark  Public Methods

-(void)insertTodoWithDescription:(NSString *)description andStatus:(NSNumber *)status andImageData:(NSData *)imageData
{
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    [db open];
    NSString *query;
    if(imageData)
    {
        query = [NSString stringWithFormat:@"insert into Todos (%@,%@,%@,%@) values (?,?,?,?)",kTodoDescritionKey,kTodoStatusKey,kTodoImageKey,kTodoLastUpdateKey];
        [db executeUpdate:query,description,status,imageData,[NSDate date]];
    }
    else
    {
        query = [NSString stringWithFormat:@"insert into Todos (%@,%@,%@) values (?,?,?)",kTodoDescritionKey,kTodoStatusKey,kTodoLastUpdateKey];
        [db executeUpdate:query,description,status,[NSDate date]];
    }
    [db close];
}

-(void)updateTodoForId:(NSNumber *)todoId withDescription:(NSString *)description andImageData:(NSData *)imageData
{
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    [db open];
    NSString *query;
    if(imageData)
    {
        query = [NSString stringWithFormat:@"update Todos set %@ = ?, %@ = ?, %@ = ? where %@ = %i",kTodoDescritionKey,kTodoImageKey,kTodoLastUpdateKey,kTodoIdKey,todoId.intValue];
        [db executeUpdate:query,description,imageData,[NSDate date]];
    }
    else
    {
        query = [NSString stringWithFormat:@"update Todos set %@ = ?, %@ = ? where %@ = %i",kTodoDescritionKey,kTodoLastUpdateKey,kTodoIdKey,todoId.intValue];
        [db executeUpdate:query,description,[NSDate date]];
    }
    [db close];
}

-(void)updateTodoState:(NSNumber *)status forTodoId:(NSNumber *)todoId
{
    [self executeUpdateOperation:@"Todos" andData:[NSDictionary dictionaryWithObject:status forKey:kTodoStatusKey] andFilter:[NSDictionary dictionaryWithObject:todoId forKey:kTodoIdKey]];
}

-(void)deleteTodo:(NSNumber *)todoId
{
    [self executeDeleteOperation:@"Todos" andFilter:[NSDictionary dictionaryWithObject:todoId forKey:kTodoIdKey]];
}

-(NSArray *)getPendingTodos
{
    return [self executeQuery:[NSString stringWithFormat:@"select * from Todos where %@ = %i",kTodoStatusKey,(int)kTodoPendingStatusValue]];
}

-(NSArray *)getCompletedTodos
{
    return [self executeQuery:[NSString stringWithFormat:@"select * from Todos where %@ = %i",kTodoStatusKey,(int)kTodoCompletedStatusValue]];
}
@end
