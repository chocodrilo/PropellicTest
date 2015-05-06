//
//  CompletedTodosViewController.m
//  MyTodos
//
//  Created by iOS developer on 5/6/15.
//  Copyright (c) 2015 Chocodrilo INC. All rights reserved.
//

#import "CompletedTodosViewController.h"

@interface CompletedTodosViewController ()

@end

@implementation CompletedTodosViewController

#pragma mark
#pragma mark Private method overrid

-(void)setupTodosArray
{
    [todosArray removeAllObjects];
    [todosArray addObjectsFromArray:[ds getCompletedTodos]];
}

-(void)updateData
{
    [self setupTodosArray];
    if(todosArray.count > 0)
    {
        titleLabel.text = [NSString stringWithFormat:NSLocalizedString(@"LABEL_COMPLETED_TODOS_TITLE", nil),todosArray.count];
        titleLabel.textColor = [UIColor blueColor];
    }
    else
    {
        titleLabel.text = NSLocalizedString(@"LABEL_NO_COMPLETED_TODOS_TITLE", nil);
        titleLabel.textColor = [UIColor redColor];
    }
    [todosTableView reloadData];
}

@end
