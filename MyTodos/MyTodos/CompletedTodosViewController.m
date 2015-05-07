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
#pragma mark Private method overrides

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

-(NSArray *)getRightUtilityButtons
{
    NSMutableArray *utilityButtons = [NSMutableArray new];
    
    [utilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:255.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0]
                                           title:NSLocalizedString(@"BUTTON_DELETE_TITLE", nil)];
    return utilityButtons;
}

#pragma mark -
#pragma mark SWCellDelegate

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index;
{
    [cell hideUtilityButtonsAnimated:YES];
    TodoTableViewCell *c = (TodoTableViewCell *)cell;
    NSDictionary *data = c.cellData;
    [self deleteTodo:data];
}

@end
