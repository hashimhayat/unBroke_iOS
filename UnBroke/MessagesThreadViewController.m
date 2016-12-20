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

@import Firebase;

@interface MessagesThreadViewController ()

@end

@implementation MessagesThreadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerForKeyboardNotifications];
    _ref = [[FIRDatabase database] reference];
    _navItem.title = _jobName;
    [self loadData];
    _tableView.transform = CGAffineTransformMakeRotation(-M_PI);
}

-(void) loadData{
    FIRDatabaseReference *messages = [[[_ref child:@"conversations"] child:_convoID] child:@"messages"];
    
    [messages observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        _data = [[NSMutableArray alloc] init];
        for (FIRDataSnapshot *childSnap in snapshot.children) {
            NSDictionary *child = childSnap.value;
            [_data addObject:child];
        }
        
        _sortedData = [_data sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSString *firstStr = [(NSDictionary *)obj1 objectForKey:@"timestamp"];
            NSString *secondStr = [(NSDictionary *)obj2 objectForKey:@"timestamp"];
            NSTimeInterval firstInterval=[firstStr doubleValue];
            NSTimeInterval secondInterval=[secondStr doubleValue];
            NSDate *first = [NSDate dateWithTimeIntervalSince1970:firstInterval];
            NSDate *second = [NSDate dateWithTimeIntervalSince1970:secondInterval];
            
            return [second compare:first];

        }];
        
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        if(_data.count == 0)
            messageLabel.text = @"Conversations for jobs for which you have been accepted for will appear here.";
        messageLabel.textColor = [UIColor darkGrayColor];
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.transform = CGAffineTransformMakeRotation(M_PI);
        [messageLabel sizeToFit];
        _tableView.backgroundView = messageLabel;
        
        [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _sortedData.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FIRUser *user = [FIRAuth auth].currentUser;
    if([_sortedData[indexPath.row][@"sender"] isEqualToString:user.uid]){
        ReceiverEntry *cell = [tableView dequeueReusableCellWithIdentifier:@"receiver"];
        if(cell == nil)
            cell = [[ReceiverEntry alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier: @"receiver"];
        cell.receiver.text = @"You";
        cell.message.text = _sortedData[indexPath.row][@"message"];
        cell.image.image = [UIImage imageNamed:@"user"];
        cell.image.layer.cornerRadius = 7;
        cell.transform = CGAffineTransformMakeRotation(M_PI);
        return cell;
    } else {
        SenderEntry *cell = [tableView dequeueReusableCellWithIdentifier:@"sender"];
        if(cell == nil)
            cell = [[SenderEntry alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier: @"sender"];
        cell.sender.text = _toUser;
        cell.message.text = _sortedData[indexPath.row][@"message"];
        cell.image.image = [UIImage imageNamed:@"user"];
        cell.image.layer.cornerRadius = 7;
        cell.transform = CGAffineTransformMakeRotation(M_PI);
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

- (IBAction)sendMessage:(id)sender {
    NSString *messageText = _message.text;
    if([messageText length] > 0){
        FIRDatabaseReference *convoRef = [[[[_ref child:@"conversations"] child:_convoID] child:@"messages"] childByAutoId];
        FIRUser *user = [FIRAuth auth].currentUser;
        NSDictionary *message = @{
                                @"message" : messageText,
                                @"sender" : user.uid,
                                @"timestamp" : [FIRServerValue timestamp],
                                };
        
        [convoRef setValue:message];
        [self.view endEditing:YES];
    }
    _message.text = @"";
}

@end
