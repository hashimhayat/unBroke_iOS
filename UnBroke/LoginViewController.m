//
//  LoginViewController.m
//  UnBroke
//
//  Created by Shuaib Jewon on 12/5/16.
//  Copyright © 2016 nyu.edu. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()
@end

@import Firebase;

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerForKeyboardNotifications];
    [self configureLayout];
    [self autoLogin];
    
    NSString *path = [NSString stringWithFormat:@"%@/slide-paper.aif", [[NSBundle mainBundle] resourcePath]];
    NSURL *soundUrl = [NSURL fileURLWithPath:path];
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark Program Functions

//Adds rounded corners to text fields and buttons
- (void) configureLayout{
    NSInteger cornerRadius = 7;
    _emailTextField.layer.cornerRadius = cornerRadius;
    _pwdTextField.layer.cornerRadius = cornerRadius;
    _loginBtn.layer.cornerRadius = cornerRadius;
    _signUpBtn.layer.cornerRadius = cornerRadius;
    _fbConnectBtn.layer.cornerRadius = cornerRadius;
}

//if option selected then autologin user
- (void) autoLogin{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if([[prefs objectForKey:@"autologin"] isEqualToString:@"yes"]){
        _emailTextField.text = [prefs objectForKey:@"user"];
        _pwdTextField.text = [prefs objectForKey:@"pass"];
        [self logInBtnClick:self];
    }
}

#pragma mark IBAction Functions

- (IBAction)logInBtnClick:(id)sender {
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
    
    
    if(_emailTextField.text.length < 1 || _pwdTextField.text.length < 1)
        [self showAlertWithMessage:@"Both fields need to be filled in"];
    else
        [[FIRAuth auth] signInWithEmail:_emailTextField.text
                               password:_pwdTextField.text
                             completion:^(FIRUser *user, NSError *error) {
                                 if(error)
                                     [self showAlertWithMessage:@"Invalid credidentials"];
                                 else {
                                     if(_autoSignInSwitch.on == YES){
                                         NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                                         [prefs setObject:_emailTextField.text forKey:@"user"];
                                         [prefs setObject:_pwdTextField.text forKey:@"pass"];
                                         [prefs setObject:@"yes" forKey:@"autologin"];
                                     }
                                     [self performSegueWithIdentifier:@"loggedIn" sender:self];
                                 }
                                 [_audioPlayer play];
                                 [spinner stopAnimating];
                                 [overlay removeFromSuperview];
                             }
         ];
}

- (IBAction)connectFbBtnClick:(id)sender {
    
}

-(IBAction)goBackToLogin:(UIStoryboardSegue *)segue {
    NSError *signOutError;
    BOOL status = [[FIRAuth auth] signOut:&signOutError];
    [self.navigationController popToRootViewControllerAnimated:NO];
}

#pragma mark Helper Functions

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
