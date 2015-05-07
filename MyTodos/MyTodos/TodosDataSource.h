//
//  TodosDataSource.h
//  MyTodos
//
//  Created by iOS developer on 5/6/15.
//  Copyright (c) 2015 Chocodrilo INC. All rights reserved.
//

#import "SQLiteDataSource.h"

// Attribute Keys
#define kTodoIdKey @"id"
#define kTodoDescritionKey @"todoDescription"
#define kTodoLastUpdateKey @"todoLastUpdatedDate"
#define kTodoStatusKey @"todoStatus"
#define kTodoImageKey @"todoImage"

// Values
#define kTodoPendingStatusValue 1
#define kTodoCompletedStatusValue 2

@interface TodosDataSource : SQLiteDataSource

-(void)insertTodoWithDescription:(NSString *)description andStatus:(NSNumber *)status andImageData:(NSData *)imageData;
-(void)updateTodoForId:(NSNumber *)todoId withDescription:(NSString *)description andImageData:(NSData *)imageData;
-(void)updateTodoState:(NSNumber *)status forTodoId:(NSNumber *)todoId;
-(void)deleteTodo:(NSNumber *)todoId;
-(NSArray *)getPendingTodos;
-(NSArray *)getCompletedTodos;

@end
