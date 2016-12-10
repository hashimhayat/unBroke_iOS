//
//  JobsPostViewController.m
//  UnBroke
//
//  Created by Shuaib Jewon on 11/29/16.
//  Copyright © 2016 nyu.edu. All rights reserved.
//

#import "JobsPostViewController.h"

typedef void (^ IteratorBlock)(id object);

@interface JobsPostViewController ()

@end

@implementation JobsPostViewController

@synthesize tableView = _tableView;

NSArray *cats, *subCats, *salType;
BOOL show2=false,show4=false,show6 = false, show8 = false;
NSInteger scrollSize = 50000;

extern NSInteger userID;
extern NSString *apiUrl;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerForKeyboardNotifications];
    
    //set background for table view
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background"]];
    [tempImageView setFrame:self.tableView.frame];
    self.tableView.backgroundView = tempImageView;
    
    //init picker data
    cats = @[@"Item 1", @"Item 2", @"Item 3", @"Item 4", @"Item 5", @"Item 6"];
    subCats = @[@"Item 1", @"Item 2", @"Item 3", @"Item 4", @"Item 5", @"Item 6"];
    salType = @[@"Per hour", @"Gross Pay"];

    [self sendPostRequestWithData:@"" sendPostRequestTo:@"get_job_cat.php" postCustomCommand:^(id object){
        NSDictionary *results = object;
        NSMutableArray *temp = [[NSMutableArray alloc] init];
        for (NSDictionary *entry in results) {
            if([entry objectForKey:@"category"] != nil)
                [temp addObject:[entry objectForKey:@"category"]];
        }
        
        cats = [temp copy];

        //picker infinite scroll starting at first element
        NSInteger start = scrollSize/2;
        while(start % cats.count!=0)
            start++;
        [_categoryPicker selectRow:start inComponent:0 animated:NO];
        while(start % subCats.count!=0)
            start++;
        [_subCategoryPicker selectRow:start inComponent:0 animated:NO];
        while(start % salType.count!=0)
            start++;
        [_salaryTypePicker selectRow:start inComponent:0 animated:NO];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
 *
 * Below methods to generate table
 *
 */

//set height of cells; row 6 is description field, row 2 and 4 are pickers
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //hide cells unsupported by server
    if (indexPath.row == 0 || indexPath.row == 8 || indexPath.row == 10 || indexPath.row == 11 || indexPath.row == 12 || indexPath.row == 13)
        return 0.0f;
    
    if (indexPath.row == 2 && show2 == true)
        return 124.0f;
    
    if (indexPath.row == 2 && show2 == false)
        return 0.0f;
    
    if (indexPath.row == 4 && show4 == true)
        return 124.0f;
    
    if (indexPath.row == 4 && show4 == false)
        return 0.0f;
    
    if (indexPath.row == 6 && show6 == true)
        return 120.0f;
    
    if (indexPath.row == 6 && show6 == false)
        return 0.0f;
    
    return UITableViewAutomaticDimension;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 14;
}

//expand on click
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //sets animation and focus
    switch(indexPath.row){
        case 0:
            //job name
            show2 = false;
            show4 = false;
            show6 = false;
            show8 = false;
            [self.view endEditing:NO];
            break;
        case 1:
            //category
            show2 = !show2;
            show4 = false;
            show6 = false;
            show8 = false;
            [self.view endEditing:YES];
            break;
        case 2:
            //category picker
            show2 = true;
            show4 = false;
            show6 = false;
            show8 = false;
            [self.view endEditing:YES];
            break;
        case 3:
            //subcategory
            show2 = false;
            show4 = !show4;
            show6 = false;
            show8 = false;
            [self.view endEditing:YES];
            break;
        case 4:
            //subcategory picker
            show2 = false;
            show4 = true;
            show6 = false;
            show8 = false;
            [self.view endEditing:YES];
            break;
        case 5:
            //description
            show2 = false;
            show4 = false;
            show6 = !show6;
            show8 = false;
            [self.view endEditing:NO];
            break;
        case 6:
            //description field
            show2 = false;
            show4 = false;
            show6 = true;
            show8 = false;
            [self.view endEditing:NO];
            break;
        case 7:
            //salary type
            show2 = false;
            show4 = false;
            show6 = false;
            show8 = !show8;
            [self.view endEditing:YES];
            break;
        case 8:
            //salary type
            show2 = false;
            show4 = false;
            show6 = false;
            show8 = true;
            [self.view endEditing:YES];
            break;
        case 9:
            //salary value
            show2 = false;
            show4 = false;
            show6 = false;
            show8 = false;
            [self.view endEditing:NO];
            if([_salaryText isEqual:@"0.00"])
                _salaryText.text = @"";
            break;
        default:
            show2 = false;
            show4 = false;
            show6 = false;
            show8 = false;
            [self.view endEditing:YES];
    }
    
    [self updateTextFields];
    
    [_tableView beginUpdates];
    [_tableView endUpdates];
    
    if(indexPath.row == 5 || indexPath.row == 6)
        [_descriptionFieldEdit becomeFirstResponder];
}

- (void) updateTextFields{
    //update description field preview
    _descriptionField.text = _descriptionFieldEdit.text;
    
    //update salary
    float salary = [_salaryText.text floatValue];
    if(salary>0)
        _salaryText.text = [NSString stringWithFormat:@"%.02f",salary];
}

/*
 *
 * Below methods for slider interaction
 *
 */

//changes minimum distance slider value
- (IBAction)sliderMinDistanceChanged:(id)sender {
    if(_sliderMinDistance.value>_sliderMinDistance.minimumValue)
        _sliderMinDistanceField.text = [NSString stringWithFormat:@"%.f miles", _sliderMinDistance.value];
    else
        _sliderMinDistanceField.text = [NSString stringWithFormat:@"None"];
}

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
        return scrollSize;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if([pickerView.accessibilityLabel  isEqual: @"subcats"]){
        return subCats[row % subCats.count];
    } else if([pickerView.accessibilityLabel  isEqual: @"cats"]){
        return cats[row % cats.count];
    } else if([pickerView.accessibilityLabel  isEqual: @"salary"]){
        return salType[row % salType.count];
    }
    return 0;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if([pickerView.accessibilityLabel  isEqual: @"cats"]){
        _categoryPickerText.text = cats[row % cats.count];
        [self sendPostRequestWithData:[NSString stringWithFormat:@"category=%@",_categoryPickerText.text] sendPostRequestTo:@"get_jobs_from_cat.php" postCustomCommand:^(id object){
            
            NSDictionary *results = object;
            NSMutableArray *temp = [[NSMutableArray alloc] init];
            
            for (NSDictionary *entry in results) {
                if([entry objectForKey:@"title"] != nil)
                    [temp addObject:[entry objectForKey:@"title"]];
            }
            
            subCats = [temp copy];
            
            //picker infinite scroll starting at first element
            NSInteger start = scrollSize/2;
            while(start % cats.count!=0)
                start++;
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [_subCategoryPicker selectRow:start inComponent:0 animated:NO];
                _subCategoryPickerText.text = subCats[0];
            }];
        }];
    }
    else if ([pickerView.accessibilityLabel  isEqual: @"subcats"])
        _subCategoryPickerText.text = subCats[row % subCats.count];
    else if ([pickerView.accessibilityLabel  isEqual: @"salary"])
        _salaryTypeText.text = salType[row % salType.count];
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

//Animates and sends a post request with the options of setting a block of stuff to do after response received
-(void) sendPostRequestWithData:(NSString *)postString sendPostRequestTo:(NSString *)fileName postCustomCommand:(IteratorBlock)iteratorBlock{
    //create translucent overlay
    UIView *overlay = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [overlay setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3]];
    
    //create a moving spinner and add it to the overlay
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [spinner startAnimating];
    [overlay addSubview:spinner];
    
    //position spinner in the center of the overlay and animate the appearance of the overlay
    spinner.center = CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0);
    
    //add spinner to overlay
    [UIView animateWithDuration:0.5
                     animations:^{
                         [self.view addSubview:overlay];
                         overlay.alpha = 1.0;
                     }
     ];
    
    //wait for 0.3 seconds before sending post request for aesthetic reasons - overlay and spinner shown for > 0.3 seconds
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^ {
        //send a post request
        //code adapted from http://codewithchris.com/tutorial-how-to-use-ios-nsurlconnection-by-example/
        
        //create and format post request to be send to api server
        NSData *postData = [postString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%lu" , (unsigned long)[postData length]];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", apiUrl, fileName]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:url];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        [request setTimeoutInterval:5.0];
        
        //Send Post Request
        NSURLSession *session = [NSURLSession sharedSession];
        [[session dataTaskWithRequest:request
                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                        
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            [spinner stopAnimating];
                            [overlay removeFromSuperview];
                        }];
                        
                        if(error){
                            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                [self showAlertWithMessage:@"Server Error"];
                            }];
                            return;
                        }
                        
                        NSError *JSONerror = nil;
                        id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:&JSONerror];
                        
                        if(JSONerror){
                            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                [self showAlertWithMessage:@"Server Error"];
                            }];
                            return;
                        }
                        
                        //run custom commands through block on post results
                        iteratorBlock(object);
                    }]
         resume];
    });
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

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    if ([identifier isEqualToString:@"save"]){
        NSString *title = _subCategoryPickerText.text;
        NSString *desc = _descriptionFieldEdit.text;
        NSString *salary = _salaryText.text;
        
        BOOL retVal = true;
        
        [self sendPostRequestWithData:[NSString stringWithFormat:@"title=%@&user_id=%ld&comment=%@&salary=%@",title, userID, desc, salary]
                    sendPostRequestTo:@"post_job.php"
                    postCustomCommand:^(id object){
                        //add validation to check for error
                        NSDictionary *results = [object objectAtIndex:0];
                        NSInteger returnVal = [[results valueForKey:@"response"] integerValue];
                    }
         ];
        
        return retVal;
    }
    return true;
}

@end
