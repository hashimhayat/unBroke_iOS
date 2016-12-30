//
//  RegisterViewController.m
//  UnBroke
//
//  Created by Shuaib Jewon on 12/5/16.
//  Copyright © 2016 nyu.edu. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureLayout];
    [self registerForKeyboardNotifications];
    
    NSString *path = [NSString stringWithFormat:@"%@/slide-paper.aif", [[NSBundle mainBundle] resourcePath]];
    NSURL *soundUrl = [NSURL fileURLWithPath:path];
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//Adds rounded corners to text fields and buttons
- (void) configureLayout{
    NSInteger cornerRadius = 7;
    _emailTextField.layer.cornerRadius = cornerRadius;
    _pwdTextField.layer.cornerRadius = cornerRadius;
    _pwdCheckTextField.layer.cornerRadius = cornerRadius;
    _goBackBtn.layer.cornerRadius = cornerRadius;
    _signUpBtn.layer.cornerRadius = cornerRadius;
}

//Sign up function. Validates input data and registers user in Firebase database
- (IBAction)signUpBtnClick:(id)sender {
    //create overlay
    UIView *overlay = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [overlay setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3]];
    
    //create spinner and set its position to center
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    spinner.center = CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0);
    
    //add spinner to overlay and add overlay to view + start animating
    [UIView animateWithDuration:0.2
                     animations:^{overlay.alpha = 1.0;}
                     completion:^(BOOL finished){ [overlay addSubview:spinner]; }];
    [self.view addSubview:overlay];
    [spinner startAnimating];

    NSString *errorMsg = nil;
    
    if(_emailTextField.text.length < 1 || _pwdTextField.text.length < 1 || _pwdCheckTextField.text.length <1){
        errorMsg = @"Please fill in all fields";
    } else if (![_pwdTextField.text isEqualToString:_pwdCheckTextField.text]){
        errorMsg = @"Both password fields have to be the same";
    }
    
    //Firebase will validate email address format
    if(errorMsg){
        [self showAlertWithMessage:errorMsg];
        [spinner stopAnimating];
        [overlay removeFromSuperview];
    } else {
        [[FIRAuth auth] createUserWithEmail: _emailTextField.text
                                   password: _pwdTextField.text
                                 completion:^(FIRUser *_Nullable user, NSError *_Nullable error) {
                                     if(error)
                                         [self showAlertWithMessage:[error localizedDescription]];
                                     else
                                         [self performSegueWithIdentifier:@"signedUp" sender:self];
                                     [_audioPlayer play];
                                     [spinner stopAnimating];
                                     [overlay removeFromSuperview];
                                 }
         ];
    }
}

- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

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
    
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

/*
 *
 * Keyboard helper functions
 * Changes size of view depending on location of keyboard and allows one to switch fields
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
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    _scrollView.contentInset = contentInsets;
    _scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, _activeField.frame.origin) ) {
        [_scrollView scrollRectToVisible:_activeField.frame animated:YES];
    }
}

//when keyboard is hidden, set size of content to same as before
- (void)keyboardWillBeHidden:(NSNotification*)aNotification{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    _scrollView.contentInset = contentInsets;
    _scrollView.scrollIndicatorInsets = contentInsets;
}

@end
