//
//  PendingTodosViewController.h
//  MyTodos
//
//  Created by iOS developer on 5/6/15.
//  Copyright (c) 2015 Chocodrilo INC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TodosDataSource.h"
#import "TodoTableViewCell.h"
#import <MessageUI/MFMailComposeViewController.h>

@interface PendingTodosViewController : UIViewController <UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate,SWTableViewCellDelegate,MFMailComposeViewControllerDelegate,TodoTableDelegate>
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
    
    IBOutlet UIView *enlargeImageView;
    IBOutlet UIView *enlargeImageOverlayView;
    IBOutlet UIImageView *enlargeImageImageView;
    
    IBOutlet UIButton *closeImageButton;
    
    NSMutableArray *todosArray;
    TodosDataSource *ds;
    
    NSDictionary *currentTodoData;
    
    NSDateFormatter *formatter;
}

-(IBAction)addTodo:(id)sender;
-(IBAction)dismissTodoView:(id)sender;
-(IBAction)dismissTextView:(id)sender;
-(IBAction)changeImage:(id)sender;
-(IBAction)saveTodo:(id)sender;
-(IBAction)hideImageView:(id)sender;

-(void)deleteTodo:(NSDictionary *)dicc;

@end
