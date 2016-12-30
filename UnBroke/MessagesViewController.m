//
//  MessagesViewController.m
//  UnBroke
//
//  Created by Shuaib Jewon on 11/29/16.
//  Copyright © 2016 nyu.edu. All rights reserved.
//

#import "ThreadEntry.h"
#import "MessagesViewController.h"
#import "MessagesThreadViewController.h"

@interface MessagesViewController ()
@end

@implementation MessagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _ref = [[FIRDatabase database] reference];
    [self loadData];
}

//grab all existing conversations from server
-(void) loadData{
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
    
    FIRUser *user = [FIRAuth auth].currentUser;
    FIRDatabaseReference *conversations = [_ref child:@"conversations"];
    
    //load existing conversations if existing
    [conversations observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        _data = [[NSMutableArray alloc] init];
        for (FIRDataSnapshot *childSnap in snapshot.children) {
            NSDictionary *child = childSnap.value;
            [child setValue:childSnap.key forKey:@"key"];
            if([child[@"applicant"] isEqualToString:user.uid] ||
                [child[@"creator"] isEqualToString:user.uid]){
                    [_data addObject:child];
            }
        }
        
        
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        if(_data.count == 0)
            messageLabel.text = @"Conversations for jobs for which you have been accepted for will appear here.";
        messageLabel.textColor = [UIColor darkGrayColor];
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        [messageLabel sizeToFit];
        _tableView.backgroundView = messageLabel;

        [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
        
        [spinner stopAnimating];
        [overlay removeFromSuperview];
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
    return _data.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier = @"thread";
    ThreadEntry *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if(cell == nil)
        cell = [[ThreadEntry alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier: identifier];
    
    FIRUser *user = [FIRAuth auth].currentUser;
    if(![user.uid isEqualToString:_data[indexPath.row][@"applicant"]])
        cell.name.text = _data[indexPath.row][@"applicantName"];
    else
        cell.name.text = _data[indexPath.row][@"creatorName"];
    
    cell.lastText.text = _data[indexPath.row][@"jobName"];
    cell.image.image = [UIImage imageNamed:@"user"];
    cell.image.layer.cornerRadius = 7;
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FIRUser *user = [FIRAuth auth].currentUser;
    if([user.uid isEqualToString:_data[indexPath.row][@"applicant"]])
        _toUser = _data[indexPath.row][@"applicantName"];
    else if ([user.uid isEqualToString:_data[indexPath.row][@"creator"]])
        _toUser = _data[indexPath.row][@"creatorName"];
    _convoID = _data[indexPath.row][@"key"];
    _jobName = _data[indexPath.row][@"jobName"];
    [self performSegueWithIdentifier:@"showMessageThread" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"showMessageThread"]){
        MessagesThreadViewController *destViewController = segue.destinationViewController;
        destViewController.toUser = _toUser;
        destViewController.convoID = _convoID;
        destViewController.jobName = _jobName;
    }
}


-(IBAction)goBackToMessages:(UIStoryboardSegue *)segue {
    
}

@end
