//
//  PendingTodosViewController.h
//  MyTodos
//
//  Created by iOS developer on 5/6/15.
//  Copyright (c) 2015 Chocodrilo INC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TodosDataSource.h"

@interface PendingTodosViewController : UIViewController <UITextViewDelegate>
{
    IBOutlet UITableView *todosTableView;
    IBOutlet UILabel *titleLabel;
    IBOutlet UIButton *addButton;
    
    IBOutlet UIView *todoView;
    IBOutlet UIView *todoOverlayView;
    IBOutlet UIView *todoFormView;
    
    IBOutlet UIButton *closeTodoFormButton;
    
    IBOutlet UILabel *descriptionTitleLabel;
    IBOutlet UITextView *descriptionTextView;
    
    IBOutlet UILabel *lastUpdatedTitleLabel;
    IBOutlet UILabel *lastUpdatedValueLabel;
    
    IBOutlet UILabel *selectImageTitleLabel;
    IBOutlet UIImageView *selectedImage;
    
    IBOutlet UIButton *saveButton;
    
    NSMutableArray *todosArray;
    TodosDataSource *ds;
}

-(IBAction)addTodo:(id)sender;
-(IBAction)dismissTodoView:(id)sender;
-(IBAction)dismissTextView:(id)sender;

@end
