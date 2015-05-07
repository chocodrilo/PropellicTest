//
//  PendingTodosViewController.m
//  MyTodos
//
//  Created by iOS developer on 5/6/15.
//  Copyright (c) 2015 Chocodrilo INC. All rights reserved.
//

#import "PendingTodosViewController.h"
#import "AnimationHelper.h"
#import <Social/Social.h>

#define TODO_CELL_ID @"TodoCell"

#define FINISH_TODO_BUTTON_INDEX 0
#define DELETE_TODO_BUTTON_INDEX 1

#define SHARE_TODO_BUTTON_INDEX 0
#define EDIT_TODO_BUTTON_INDEX 1

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
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MM/dd/yyyy mm:hh"];
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

-(IBAction)changeImage:(id)sender
{
    [descriptionTextView resignFirstResponder];
    UIAlertController * view=   [UIAlertController
                                 alertControllerWithTitle:NSLocalizedString(@"ACTION_SHEET_SELECT_MEDIA_TYPE_TITLE", nil)
                                 message:NSLocalizedString(@"ACTION_SHEET_SELECT_MEDIA_TYPE_SUBTITLE", nil)
                                 preferredStyle:UIAlertControllerStyleActionSheet];
    [self setupCameraButtonForAlertController:view];
    [self setupLibraryButtonForAlertController:view];
    [self presentViewController:view animated:YES completion:nil];
}

-(IBAction)saveTodo:(id)sender
{
    [descriptionTextView resignFirstResponder];
    if([descriptionTextView.text isEqualToString:@""])
    {
        [self showEmptyFormError];
    }
    else
    {
        if(lastUpdatedTitleLabel.alpha == 0.0)
        {
            [ds insertTodoWithDescription:descriptionTextView.text andStatus:[NSNumber numberWithInt:kTodoPendingStatusValue] andImageData:[self getImageData]];
        }
        else
        {
            [ds updateTodoForId:[currentTodoData objectForKey:kTodoIdKey] withDescription:descriptionTextView.text andImageData:[self getImageData]];
        }
        [self updateData];
        [self hideTodoForm];
    }
}

-(IBAction)hideImageView:(id)sender
{
    [self hideImageForm];
}

#pragma mark
#pragma mark Private methods

-(void)setupView
{
    [todosTableView registerNib:[UINib nibWithNibName:@"TodoTableViewCell" bundle:nil] forCellReuseIdentifier:TODO_CELL_ID];
    todoView.alpha = 0.0;
    todoOverlayView.alpha = 0.0;
    todoFormView.alpha = 0.0;
    [self.view addSubview:todoView];
    
    enlargeImageView.alpha = 0.0;
    enlargeImageOverlayView.alpha = 0.0;
    enlargeImageImageView.alpha = 0.0;
    closeImageButton.alpha = 0.0;
    [self.view addSubview:enlargeImageView];
    
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
    //TODO: Set placeholder image!
}

-(void)showEditForm:(NSDictionary *)todoData
{
    [self setupEditTodoForm:todoData];
    [self showTodoForm];
}

-(void)setupEditTodoForm:(NSDictionary *)data
{
    currentTodoData = data;
    descriptionTextView.text = [currentTodoData objectForKeyedSubscript:kTodoDescritionKey];
    lastUpdatedTitleLabel.alpha =1.0;
    lastUpdatedValueLabel.alpha = 1.0;
    NSString *dateStr = [currentTodoData objectForKey:kTodoLastUpdateKey];
    NSDate *d = [NSDate dateWithTimeIntervalSince1970:dateStr.doubleValue];
    lastUpdatedValueLabel.text = [formatter stringFromDate:d];
    if([currentTodoData objectForKey:kTodoImageKey] && ![[currentTodoData objectForKey:kTodoImageKey] isKindOfClass:[NSNull class]])
    {
        
        NSData *d = (NSData *) [currentTodoData objectForKey:kTodoImageKey];
        UIImage *img = [UIImage imageWithData:d];
        selectedImage.image = img;
    }
    else
    {
        selectedImage.image = nil;
        //TODO: Set placeholder image!
    }
}

-(void)showImagePicker:(UIImagePickerControllerSourceType)sourceType
{
    UIImagePickerController *imagePickController=[[UIImagePickerController alloc]init];
    imagePickController.sourceType = sourceType;
    imagePickController.delegate=self;
    imagePickController.allowsEditing=NO;
    [self presentViewController:imagePickController animated:YES completion:nil];
}

-(void)showSendEmailController
{
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    [picker setSubject:NSLocalizedString(@"SHARE_EMAIL_SUBJECT_LABEL", nil)];
    if([currentTodoData objectForKey:kTodoImageKey] && ![[currentTodoData objectForKey:kTodoImageKey] isKindOfClass:[NSNull class]])
    {
        
        NSData *d = (NSData *) [currentTodoData objectForKey:kTodoImageKey];
        UIImage *img = [UIImage imageWithData:d];
        NSData *myData = UIImagePNGRepresentation(img);
        [picker addAttachmentData:myData mimeType:@"image/png" fileName:@"MyTodoImage.png"];
    }
    NSString *emailBody = [NSString stringWithFormat:NSLocalizedString(@"SHARE_EMAIL_BODY_LABEL", nil),[currentTodoData objectForKey:kTodoDescritionKey]];
    [picker setMessageBody:emailBody isHTML:NO];
    [self presentViewController:picker animated:YES completion:nil];
}

-(void)showSocialComposeViewWithType:(NSString *)serviceType
{
    SLComposeViewController *compose = [SLComposeViewController composeViewControllerForServiceType:serviceType];
    [compose setInitialText:[NSString stringWithFormat:NSLocalizedString(@"SHARE_SOCIAL_NETWORK_BODY_LABEL", nil),[currentTodoData objectForKey:kTodoDescritionKey]]];
    if([currentTodoData objectForKey:kTodoImageKey] && ![[currentTodoData objectForKey:kTodoImageKey] isKindOfClass:[NSNull class]])
    {
        NSData *d = (NSData *) [currentTodoData objectForKey:kTodoImageKey];
        UIImage *img = [UIImage imageWithData:d];
        [compose addImage:img];
    }
    [compose setCompletionHandler:^(SLComposeViewControllerResult result)
     {
   
     }];
    [self presentViewController:compose animated:YES completion:nil];
}

-(NSData *)getImageData
{
    NSData *imageData = nil;
    if(selectedImage.image)
    {
        //imageData = UIImageJPEGRepresentation(selectedImage.image, 0.5);
        imageData = UIImagePNGRepresentation(selectedImage.image);
    }
    return imageData;
}

-(void)setupCameraButtonForAlertController:(UIAlertController *)view
{
    if ([UIImagePickerController    isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIAlertAction* cameraButton = [UIAlertAction
                                       actionWithTitle:NSLocalizedString(@"BUTTON_USE_CAMERA_TITLE", nil)
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction * action)
                                       {
                                           [view dismissViewControllerAnimated:YES completion:nil];
                                           [self showImagePicker:UIImagePickerControllerSourceTypeCamera];
                                           
                                       }];
        [view addAction:cameraButton];
    }
}

-(void)setupLibraryButtonForAlertController:(UIAlertController *)view
{
    if ([UIImagePickerController  isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIAlertAction* libraryButton = [UIAlertAction
                                        actionWithTitle:NSLocalizedString(@"BUTTON_USE_LIBRARY_TITLE", nil)
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction * action)
                                        {
                                            [view dismissViewControllerAnimated:YES completion:nil];
                                            [self showImagePicker:UIImagePickerControllerSourceTypePhotoLibrary];
                                            
                                        }];
        
        [view addAction:libraryButton];
    }
}

-(NSArray *)getLeftUtilityButtons
{
    NSMutableArray *utilityButtons = [NSMutableArray new];
    [utilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:47.0/255.0 green:197.0/255.0 blue:250.0/255.0 alpha:1.0]
                                           title:NSLocalizedString(@"BUTTON_SHARE_TITLE", nil)];
    [utilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:20.0/255.0 green:166.0/255.0 blue:238.0/255.0 alpha:1.0]
                                           title:NSLocalizedString(@"BUTTON_EDIT_TITLE", nil)];
    return utilityButtons;
}

-(NSArray *)getRightUtilityButtons
{
    NSMutableArray *utilityButtons = [NSMutableArray new];
    [utilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:255.0/255.0 green:0.0/255.0 blue:200.0/255.0 alpha:1.0]
                                           title:NSLocalizedString(@"BUTTON_FINISH_TITLE", nil)];
    [utilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:255.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0]
                                           title:NSLocalizedString(@"BUTTON_DELETE_TITLE", nil)];
    return utilityButtons;
}

-(void)deleteTodo:(NSDictionary *)dicc
{
    [ds deleteTodo:[dicc objectForKey:kTodoIdKey]];
    [self updateData];
}

-(void)finishTodo:(NSDictionary *)dicc
{
    [ds updateTodoState:[NSNumber numberWithInt:kTodoCompletedStatusValue] forTodoId:[dicc objectForKey:kTodoIdKey]];
    [self updateData];
}

-(void)showShareSheetForTodoData:(NSDictionary *)dicc
{
    currentTodoData = dicc;
    UIAlertController * view=   [UIAlertController
                                 alertControllerWithTitle:NSLocalizedString(@"ACTION_SHEET_SELECT_SHARE_TYPE_TITLE", nil)
                                 message:NSLocalizedString(@"ACTION_SHEET_SELECT_SHARE_TYPE_SUBTITLE", nil)
                                 preferredStyle:UIAlertControllerStyleActionSheet];
    [self setupEmailButtonForAlertController:view];
    [self setupTwitterButtonForAlertController:view];
    [self setupFacebookButtonForAlertController:view];
    if(view.actions.count > 0)
    {
        [self presentViewController:view animated:YES completion:nil];
    }
    else
    {
        [self showNoShareOptionsError];
    }
}

-(void)setupEmailButtonForAlertController:(UIAlertController *)view
{
    if ([MFMailComposeViewController canSendMail]){
        UIAlertAction* emailButton = [UIAlertAction
                                        actionWithTitle:NSLocalizedString(@"BUTTON_SHARE_EMAIL_TITLE", nil)
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction * action)
                                        {
                                            [view dismissViewControllerAnimated:YES completion:nil];
                                            [self showSendEmailController];
                                        }];
        
        [view addAction:emailButton];
    }
}

-(void)setupTwitterButtonForAlertController:(UIAlertController *)view
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        UIAlertAction* twitterButton = [UIAlertAction
                                      actionWithTitle:NSLocalizedString(@"BUTTON_SHARE_TWITTER_TITLE", nil)
                                      style:UIAlertActionStyleDefault
                                      handler:^(UIAlertAction * action)
                                      {
                                          [view dismissViewControllerAnimated:YES completion:nil];
                                          [self showSocialComposeViewWithType:SLServiceTypeTwitter];
                                      }];
        
        [view addAction:twitterButton];
    }
}

-(void)setupFacebookButtonForAlertController:(UIAlertController *)view
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        UIAlertAction* twitterButton = [UIAlertAction
                                        actionWithTitle:NSLocalizedString(@"BUTTON_SHARE_FACEBOOK_TITLE", nil)
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction * action)
                                        {
                                            [view dismissViewControllerAnimated:YES completion:nil];
                                            [self showSocialComposeViewWithType:SLServiceTypeFacebook];
                                        }];
        
        [view addAction:twitterButton];
    }
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

-(void)showImageForm
{
    enlargeImageView.alpha = 1.0;
    [AnimationHelper fadeInTransparent:enlargeImageOverlayView withAlpha:.6 withDuration:.4 andWait:0.0];
    if(enlargeImageImageView.frame.origin.y < 1000)
    {
        enlargeImageImageView.frame = CGRectMake(enlargeImageImageView.frame.origin.x, enlargeImageImageView.frame.origin.y+1000, enlargeImageImageView.frame.size.width, enlargeImageImageView.frame.size.height);
    }
    [AnimationHelper transitionView:enlargeImageImageView toRect:CGRectMake(enlargeImageImageView.frame.origin.x, enlargeImageImageView.frame.origin.y-1000, enlargeImageImageView.frame.size.width, enlargeImageImageView.frame.size.height) WithSpringWithDamping:.3 andVelocity:0.0 andTransitionTime:.6 andWaitTime:0.0];
    [AnimationHelper fadeIn:closeImageButton withDuration:.6 andWait:0.0];
}

-(void)hideImageForm
{
    [AnimationHelper transitionView:enlargeImageImageView toRect:CGRectMake(enlargeImageImageView.frame.origin.x, enlargeImageImageView.frame.origin.y+1000, enlargeImageImageView.frame.size.width, enlargeImageImageView.frame.size.height) WithSpringWithDamping:.3 andVelocity:0.0 andTransitionTime:.4 andWaitTime:0.0];
    [AnimationHelper fadeOut:closeImageButton withDuration:.2 andWait:0];
    [AnimationHelper fadeOut:enlargeImageOverlayView withDuration:.4 andWait:.2];
    [AnimationHelper fadeOut:enlargeImageView withDuration:0 andWait:.6];
}

-(void)showEmptyFormError
{
    UIAlertController * view=   [UIAlertController
                                 alertControllerWithTitle:NSLocalizedString(@"ALERT_ERROR_TITLE", nil)
                                 message:NSLocalizedString(@"ALERT_NO_DESCRIPTION_SUBTITLE", nil)
                                 preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* okButton = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"BUTTON_OK_TITLE", nil)
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action)
                               {
                                   [view dismissViewControllerAnimated:YES completion:nil];
                               }];
    
    [view addAction:okButton];
    [self presentViewController:view animated:YES completion:nil];
}

-(void)showNoShareOptionsError
{
    UIAlertController * view=   [UIAlertController
                                 alertControllerWithTitle:NSLocalizedString(@"ALERT_ERROR_TITLE", nil)
                                 message:NSLocalizedString(@"ALERT_NO_SHARE_OPTIONS_SUBTITLE", nil)
                                 preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* okButton = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"BUTTON_OK_TITLE", nil)
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action)
                               {
                                   [view dismissViewControllerAnimated:YES completion:nil];
                               }];
    
    [view addAction:okButton];
    [self presentViewController:view animated:YES completion:nil];
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

#pragma mark
#pragma mark  UIImagePickerControllerDelegate methods

- (void)imagePickerController:(UIImagePickerController *)imagePicker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    selectedImage.image = [UIImage imageWithData:UIImagePNGRepresentation(image)];
    [imagePicker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark
#pragma mark  TableViewDataSource && TableViewDelegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return todosArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TodoTableViewCell *cell = (TodoTableViewCell *) [tableView dequeueReusableCellWithIdentifier:TODO_CELL_ID forIndexPath:indexPath];
    [cell setupWithCellData:[todosArray objectAtIndex:indexPath.row]];
    cell.delegate = self;
    cell.todoCellDelegate = self;
    cell.rightUtilityButtons = [self getRightUtilityButtons];
    cell.leftUtilityButtons = [self getLeftUtilityButtons];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [todosTableView deselectRowAtIndexPath:indexPath animated:NO];
    NSDictionary *dicc = [todosArray objectAtIndex:indexPath.row];
    [self showEditForm:dicc];
}

#pragma mark -
#pragma mark SWCellDelegate

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index;
{
    [cell hideUtilityButtonsAnimated:YES];
    TodoTableViewCell *c = (TodoTableViewCell *)cell;
    NSDictionary *data = c.cellData;
    switch (index) {
        case SHARE_TODO_BUTTON_INDEX:
            [self showShareSheetForTodoData:data];
            break;
        case EDIT_TODO_BUTTON_INDEX:
            [self showEditForm:data];
            break;
    }
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index;
{
    [cell hideUtilityButtonsAnimated:YES];
    TodoTableViewCell *c = (TodoTableViewCell *)cell;
    NSDictionary *data = c.cellData;
    switch (index) {
        case FINISH_TODO_BUTTON_INDEX:
            [self finishTodo:data];
            break;
        case DELETE_TODO_BUTTON_INDEX:
            [self deleteTodo:data];
            break;
    }
}

#pragma mark -
#pragma mark MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark TodoTableDelegate

-(void)imageTapped:(NSData *)imageData
{
    UIImage *img = [UIImage imageWithData:imageData];
    enlargeImageImageView.image = img;
    [self showImageForm];
}

@end
