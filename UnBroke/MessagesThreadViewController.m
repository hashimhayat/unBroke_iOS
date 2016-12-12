//
//  MessagesThreadViewController.m
//  UnBroke
//
//  Created by Shuaib Jewon on 11/29/16.
//  Copyright © 2016 nyu.edu. All rights reserved.
//

#import "MessagesThreadViewController.h"
#import "SenderEntry.h"
#import "ReceiverEntry.h"

@interface MessagesThreadViewController ()

@end

@implementation MessagesThreadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerForKeyboardNotifications];
    
    _identifiers = @[@"Sarah Marcos", @"You", @"Sarah Marcos", @"You"];
    _defaultVal =  @[@"Hey! I'm pretty sure I could fix your laptop. What is the exact problem with it?", @"Some keys aren't working. I need the keyboard replaced", @"I can def do that. Are you free to meet later today?", @"Perfect! Yes I can meet you. How much will you charge btw?"];
    _profilePic = @[@"pp2", @"user", @"pp2", @"user"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _identifiers.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([self.identifiers[indexPath.row] isEqualToString:@"You"]){
        ReceiverEntry *cell = [tableView dequeueReusableCellWithIdentifier:@"receiver"];
        if(cell == nil)
            cell = [[ReceiverEntry alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier: @"receiver"];
        cell.receiver.text = self.identifiers[indexPath.row];
        cell.message.text = self.defaultVal[indexPath.row];
        cell.image.image = [UIImage imageNamed:self.profilePic[indexPath.row]];
        return cell;
    } else {
        SenderEntry *cell = [tableView dequeueReusableCellWithIdentifier:@"sender"];
        if(cell == nil)
            cell = [[SenderEntry alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier: @"sender"];
        cell.sender.text = self.identifiers[indexPath.row];
        cell.message.text = self.defaultVal[indexPath.row];
        cell.image.image = [UIImage imageNamed:self.profilePic[indexPath.row]];
        cell.image.layer.cornerRadius = 7;
        return cell;
    }
}

//sets active text field when user edits it
- (void)textViewDidBeginEditing:(UITextView *)textView{
    _activeField = textView;
}

//removes active text field when user is done editing it
- (void)textViewDidEndEditing:(UITextView *)textView{
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
