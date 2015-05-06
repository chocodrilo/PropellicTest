//
//  PendingTodosViewController.m
//  MyTodos
//
//  Created by iOS developer on 5/6/15.
//  Copyright (c) 2015 Chocodrilo INC. All rights reserved.
//

#import "PendingTodosViewController.h"
#import "AnimationHelper.h"

@implementation PendingTodosViewController

#pragma mark
#pragma mark  Initalization override methods

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
        todosArray = [[NSMutableArray alloc] init];
        ds = [[TodosDataSource alloc] init];
    }
    return self;
}

#pragma mark
#pragma mark  UIViewController override methods

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self setupView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateData];
}


#pragma mark
#pragma mark  User interaction methods

-(IBAction)addTodo:(id)sender
{
    [self setupNewTodoForm];
    [self showTodoForm];

}

-(IBAction)dismissTodoView:(id)sender
{
    [self hideTodoForm];
}

-(IBAction)dismissTextView:(id)sender
{
    [descriptionTextView resignFirstResponder];
}

#pragma mark
#pragma mark Private methods

-(void)setupView
{
    todoView.alpha = 0.0;
    todoOverlayView.alpha = 0.0;
    todoFormView.alpha = 0.0;
    [self.view addSubview:todoView];
    
    descriptionTitleLabel.text = NSLocalizedString(@"LABEL_TODO_DESCRIPTION_TITLE", nil);
    lastUpdatedTitleLabel.text = NSLocalizedString(@"LABEL_LAST_UPDATE_TITLE", nil);
    selectImageTitleLabel.text = NSLocalizedString(@"LABEL_SELECT_IMAGE_TITLE", nil);
    
    [saveButton setTitle:NSLocalizedString(@"BUTTON_SAVE_TODO_TITLE", nil) forState:UIControlStateNormal];
}

-(void)setupTodosArray
{
    [todosArray removeAllObjects];
    [todosArray addObjectsFromArray:[ds getPendingTodos]];
}

-(void)updateData
{
    [self setupTodosArray];
    if(todosArray.count > 0)
    {
        titleLabel.text = [NSString stringWithFormat:NSLocalizedString(@"LABEL_PENDING_TODOS_TITLE", nil),todosArray.count];
        titleLabel.textColor = [UIColor blueColor];
    }
    else
    {
        titleLabel.text = NSLocalizedString(@"LABEL_NO_PENDING_TODOS_TITLE", nil);
        titleLabel.textColor = [UIColor redColor];
    }
    [todosTableView reloadData];
}

-(void)setupNewTodoForm
{
    descriptionTextView.text = @"";
    selectedImage.image = nil;
    lastUpdatedTitleLabel.alpha =0.0;
    lastUpdatedValueLabel.alpha = 0.0;
}

#pragma mark
#pragma mark Private UI methods

-(void)showTodoForm
{
    todoView.alpha = 1.0;
    [AnimationHelper fadeInTransparent:todoOverlayView withAlpha:.6 withDuration:.4 andWait:0.0];
    if(todoFormView.frame.origin.y < 1000)
    {
        todoFormView.frame = CGRectMake(todoFormView.frame.origin.x, todoFormView.frame.origin.y+1000, todoFormView.frame.size.width, todoFormView.frame.size.height);
    }
    [AnimationHelper transitionView:todoFormView toRect:CGRectMake(todoFormView.frame.origin.x, todoFormView.frame.origin.y-1000, todoFormView.frame.size.width, todoFormView.frame.size.height) WithSpringWithDamping:.3 andVelocity:0.0 andTransitionTime:.6 andWaitTime:0.0];
}

-(void)hideTodoForm
{
    [AnimationHelper transitionView:todoFormView toRect:CGRectMake(todoFormView.frame.origin.x, todoFormView.frame.origin.y+1000, todoFormView.frame.size.width, todoFormView.frame.size.height) WithSpringWithDamping:.3 andVelocity:0.0 andTransitionTime:.4 andWaitTime:0.0];
    [AnimationHelper fadeOut:todoOverlayView withDuration:.4 andWait:.2];
    [AnimationHelper fadeOut:todoView withDuration:0 andWait:.6];
}

#pragma mark
#pragma mark UITextViewDelegate methods

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"])
    {
        [descriptionTextView resignFirstResponder];
    }
    return YES;
}

@end
