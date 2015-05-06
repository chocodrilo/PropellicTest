//
//  TodosDataSource.m
//  MyTodos
//
//  Created by iOS developer on 5/6/15.
//  Copyright (c) 2015 Chocodrilo INC. All rights reserved.
//

#import "TodosDataSource.h"
//#import "DatabaseConstants.m"

@implementation TodosDataSource

#pragma mark
#pragma mark  Public Methods

-(void)insertTodoWithDescription:(NSString *)description andStatus:(NSNumber *)status andImageData:(NSData *)imageData
{
    
}

-(void)updateTodoForId:(NSNumber *)todoId withDescription:(NSString *)description andStatus:(NSNumber *)status andImageData:(NSData *)imageData
{
    
}

-(NSArray *)getPendingTodos
{
    //return [self executeQuery:[NSString stringWithFormat:@"select * from Todos where %@ = %i",kTodoStatusKey,(int)kTodoPendingStatusValue]];
    return [[NSArray alloc] init];
}

-(NSArray *)getCompletedTodos
{
    //return [self executeQuery:[NSString stringWithFormat:@"select * from Todos where %@ = %i",kTodoStatusKey,(int)kTodoCompletedStatusValue]];
    return [[NSArray alloc] init];
}
@end
