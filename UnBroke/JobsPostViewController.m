//
//  JobsPostViewController.m
//  UnBroke
//
//  Created by Shuaib Jewon on 11/29/16.
//  Copyright © 2016 nyu.edu. All rights reserved.
//

#import "JobsPostViewController.h"

@import Firebase;

@interface JobsPostViewController ()
@end

@implementation JobsPostViewController

@synthesize tableView = _tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerForKeyboardNotifications];
    
    self.ref = [[FIRDatabase database] reference];

    //set background for table view
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background"]];
    [tempImageView setFrame:self.tableView.frame];
    self.tableView.backgroundView = tempImageView;
    
    //init picker data and fake infinite scrolling
    _categories = @[@"Airline", @"Arts", @"Business", @"Media", @"Medical", @"Service", @"Teaching", @"Technology"];
    [_categoryPicker selectRow:12504 inComponent:0 animated:NO];
    
    //hide picker and description at first
    _showDescriptionField = NO;
    _showPicker = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//Please run app to see how everything is animated using change in height and boolean values
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 2 && _showPicker == YES)
        return 124.0f;
    
    if (indexPath.row == 2 && _showPicker == NO)
        return 0.0f;
    
    if (indexPath.row == 4 && _showDescriptionField == YES)
        return 120.0f;
    
    if (indexPath.row == 4 && _showDescriptionField == NO)
        return 0.0f;
    
    //hide unsupported fields
    if(indexPath.row == 7 || indexPath.row == 8)
        return 0.0f;
    
    return UITableViewAutomaticDimension;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 9;
}

//Update table allowing for expand on click and update previews
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch(indexPath.row){
        case 1:
            //category
            _showPicker = !_showPicker;
            _showDescriptionField = NO;
            break;
        case 2:
            //category picker
            _showPicker = YES;
            _showDescriptionField = NO;
            break;
        case 3:
            //description
            _showPicker = NO;
            _showDescriptionField = !_showDescriptionField;
            [_descriptionFieldEdit becomeFirstResponder];
            break;
        case 4:
            //description field
            _showPicker = NO;
            _showDescriptionField = YES;
            [_descriptionFieldEdit becomeFirstResponder];
            break;
        default:
            _showPicker = NO;
            _showDescriptionField = NO;
            break;
    }
    [_tableView beginUpdates];
    [_tableView endUpdates];
}

/*
 *
 * Below methods for slider interaction
 *
 */
//changes maximum distance slider 2 value
- (IBAction)sliderMaxDistanceChanged:(id)sender {
    if(_sliderMaxDistance.value<_sliderMaxDistance.maximumValue)
        _sliderMaxDistanceField.text = [NSString stringWithFormat:@"%.f miles", _sliderMaxDistance.value];
    else
        _sliderMaxDistanceField.text = [NSString stringWithFormat:@"None"];
}

/*
 *
 * Below methods to set up pickers
 *
 */

// The number of columns of data in picker
- (long)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

// The number of rows of data in picker
- (long)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
        return 50000;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return _categories[row % _categories.count];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    _categoryPickerText.text = _categories[row % _categories.count];
}

//saves data. if success, goes back to all user's job screen or cancel segue if validation fails
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    if ([identifier isEqualToString:@"save"]){
        if(_jobNameTextField.text.length < 1 || _descriptionFieldEdit.text.length < 1 || _salaryText.text.length < 1){
            [self showAlertWithMessage:@"All fields need to be filled in"];
            return false;
        }
        
        
        FIRUser *user = [FIRAuth auth].currentUser;
        FIRDatabaseReference *newEntry = [[_ref child:@"jobs"] childByAutoId];
        NSMutableArray *applicants = [[NSMutableArray alloc] init];
        [applicants addObject: @"null"];
        NSDictionary *job = @{
                              @"name" : _jobNameTextField.text,
                              @"category" : _categoryPickerText.text,
                              @"details" : _descriptionFieldEdit.text,
                              @"salary" : _salaryText.text,
                              @"owner" : user.uid,
                              @"timestamp" : [FIRServerValue timestamp],
                              @"key" : newEntry.key,
                              @"applicants" : applicants,
                              @"matched" : @"no",
                              @"matchedUserID" : @"nil",
                              };
        [newEntry setValue:job];
    }
    return true;
}

/*
 *
 * Custom helpers
 *
 */

//Animates and shows a custom alert message
-(void) showAlertWithMessage:(NSString *)msg {
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:nil
                                  message: msg
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                             }];
                         }];
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    }];
}



/*
 *
 * Keyboard helper functions
 * Credits: https://developer.apple.com/library/content/documentation/StringsTextFonts/Conceptual/TextAndWebiPhoneOS/KeyboardManagement/KeyboardManagement.html
 * Credits: http://stackoverflow.com/questions/1347779/how-to-navigate-through-textfields-next-done-buttons
 *
 */

//configures return button on keyboard
-(BOOL)textFieldShouldReturn:(UITextField*)textField{
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        // Not found, so remove keyboard.
        [textField resignFirstResponder];
    }
    return NO; // We do not want UITextField to insert line-breaks.
}

//sets active text field when user edits it
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    _activeField = textField;
}

//removes active text field when user is done editing it
- (void)textFieldDidEndEditing:(UITextField *)textField{
    _activeField = nil;
}

//register self to receive notifications when keyboard is shown and hidden
- (void)registerForKeyboardNotifications{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

//when keyboard is shown ensure active text field can be seen
- (void)keyboardWasShown:(NSNotification*)aNotification{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(64.0, 0.0, kbSize.height, 0.0);
    _tableView.contentInset = contentInsets;
    _tableView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, _activeField.frame.origin) ) {
        [_tableView scrollRectToVisible:_activeField.frame animated:YES];
    }
}

//when keyboard is hidden, set size of content to same as before
- (void)keyboardWillBeHidden:(NSNotification*)aNotification{
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(64.0, 0.0, 0.0, 0.0);
    _tableView.contentInset = contentInsets;
    _tableView.scrollIndicatorInsets = contentInsets;
}

@end
