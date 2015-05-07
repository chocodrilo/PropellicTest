//
//  TodoTableViewCell.m
//  MyTodos
//
//  Created by iOS developer on 5/6/15.
//  Copyright (c) 2015 Chocodrilo INC. All rights reserved.
//

#import "TodoTableViewCell.h"
#import "TodosDataSource.h"

@implementation TodoTableViewCell

@synthesize cellData = cellData;
@synthesize todoCellDelegate;

#pragma mark
#pragma mark  User Interaction methods

-(IBAction)tapImage:(id)sender
{
    if([cellData objectForKey:kTodoImageKey] && ![[cellData objectForKey:kTodoImageKey] isKindOfClass:[NSNull class]])
    {
        NSData *d = (NSData *) [cellData objectForKey:kTodoImageKey];
        [self.todoCellDelegate imageTapped:d];
    }
}


#pragma mark
#pragma mark  Public methods

-(void)setupWithCellData:(NSDictionary *)todoData;
{
    [self setupRecognizer];
    cellData = todoData;
    todoDescriptionLabel.text = [cellData objectForKey:kTodoDescritionKey];
    todoLastUpdatedDateLabel.text = [NSString stringWithFormat:NSLocalizedString(@"LABEL_UPDATED_DATE_CELL_TITLE", nil),[self formatDateString:[cellData objectForKey:kTodoLastUpdateKey]]];
    if([todoData objectForKey:kTodoImageKey] && ![[todoData objectForKey:kTodoImageKey] isKindOfClass:[NSNull class]])
    {
        
        NSData *d = (NSData *) [todoData objectForKey:kTodoImageKey];
        UIImage *img = [UIImage imageWithData:d];
        imageV.image = img;
    }
    else
    {
        imageV.image = nil;
        //TODO: Set placeholder image!
    }
}

#pragma mark
#pragma mark  Private methods

-(void)setupRecognizer
{
    if(imageV.gestureRecognizers.count == 0)
    {
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)];
        [imageV addGestureRecognizer:tapRecognizer];
    }
}

-(NSString *)formatDateString:(NSString *)str
{
    if(!formatter)
    {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MM/dd/yyyy mm:hh"];
    }
    NSDate *d = [NSDate dateWithTimeIntervalSince1970:str.doubleValue];
    return [formatter stringFromDate:d];
}



@end
