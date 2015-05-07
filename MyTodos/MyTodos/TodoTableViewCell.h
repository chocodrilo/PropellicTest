//
//  TodoTableViewCell.h
//  MyTodos
//
//  Created by iOS developer on 5/6/15.
//  Copyright (c) 2015 Chocodrilo INC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"

@protocol TodoTableDelegate

-(void)imageTapped:(NSData *)imageData;

@end

@interface TodoTableViewCell : SWTableViewCell
{
    NSDictionary *cellData;
    NSDateFormatter *formatter;
    
    IBOutlet UILabel *todoDescriptionLabel;
    IBOutlet UILabel *todoLastUpdatedDateLabel;
        
    IBOutlet UIImageView *imageV;
}

@property (nonatomic,retain,readonly) NSDictionary *cellData;

@property (nonatomic,retain) id<TodoTableDelegate>todoCellDelegate;

-(IBAction)tapImage:(id)sender;

-(void)setupWithCellData:(NSDictionary *)todoData;

@end
