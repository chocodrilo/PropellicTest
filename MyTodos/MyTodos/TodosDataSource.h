//
//  TodosDataSource.h
//  MyTodos
//
//  Created by iOS developer on 5/6/15.
//  Copyright (c) 2015 Chocodrilo INC. All rights reserved.
//

#import "SQLiteDataSource.h"

@interface TodosDataSource : SQLiteDataSource

-(void)insertTodoWithDescription:(NSString *)description andStatus:(NSNumber *)status andImageData:(NSData *)imageData;
-(void)updateTodoForId:(NSNumber *)todoId withDescription:(NSString *)description andStatus:(NSNumber *)status andImageData:(NSData *)imageData;
-(NSArray *)getPendingTodos;
-(NSArray *)getCompletedTodos;

@end
