//
//  MyJobsViewController.m
//  UnBroke
//
//  Created by Shuaib Jewon on 11/30/16.
//  Copyright © 2016 nyu.edu. All rights reserved.
//

#import "MyJobsViewController.h"
#import "JobEntryTableViewCell.h"

typedef void (^ IteratorBlock)(id object);

@interface MyJobsViewController ()

@end

@implementation MyJobsViewController

@synthesize tableView = _tableView;

extern NSInteger userID;
extern NSString *apiUrl;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self sendPostRequestWithData:[NSString stringWithFormat:@"user_id=%ld",userID] sendPostRequestTo:@"job_posted_me.php" postCustomCommand:^(id object){
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            _data = [[NSMutableArray alloc] init];
            
            for (id o in object){
                NSDictionary *entry = o;
                if(entry != nil){
                    [_data addObject:entry];
                }
            }
            
            [_tableView beginUpdates];
            [_tableView endUpdates];
        }];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(_data == nil)
        return 0.0f;
    
    if(indexPath.row > _data.count-1)
        return 0.0f;
    
    return 100.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIdentifier = @"jobEntry";
    JobEntryTableViewCell *cell = (JobEntryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
        cell = [[JobEntryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    
    if(_data != nil){
        if(indexPath.row > _data.count-1)
            return cell;
        
        NSDictionary *entry = [[_data objectAtIndex:indexPath.row] objectAtIndex:0];
        
        NSLog(@"%@",entry);
        cell.jobTitle.text = [NSString stringWithFormat:@"%@",[entry objectForKey:@"title"]];
        cell.salary.text = [NSString stringWithFormat:@"%@",[entry objectForKey:@"category"]];
        cell.distance.text = [NSString stringWithFormat:@"$%@/hr",[entry objectForKey:@"salary"]];
        cell.cellImageView.image = [UIImage imageNamed:@"coder"];
    }
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 2)
        [self performSegueWithIdentifier:@"showJob" sender:self];
}

-(IBAction)goBackToMyJobs:(UIStoryboardSegue *)segue {
    
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

@end
