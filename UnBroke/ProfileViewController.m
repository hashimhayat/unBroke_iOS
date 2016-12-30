//
//  ProfileViewController.m
//  UnBroke
//
//  Created by Shuaib Jewon on 11/30/16.
//  Copyright © 2016 nyu.edu. All rights reserved.
//
#import "profilePictureCell.h"
#import "TypicalTableViewCell.h"
#import "ProfileViewController.h"

@import Firebase;

@interface ProfileViewController ()
@end

@implementation ProfileViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    //default values for table entries
    self.identifiers = @[@"First Name", @"Last Name", @"Age", @"Occupation", @"Bio", @"Email", @"Password"];
    self.defaultVal =  @[@"", @"", @"", @"", @"", @"", @""];
    
    self.ref = [[FIRDatabase database] reference];
    _userData = [[NSDictionary alloc] init];
    [self loadDataFromServer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 9;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0)
        return 150.0f;
    
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row == 0){
        profilePictureCell *cell = [tableView dequeueReusableCellWithIdentifier:@"profilepic"];
        if(cell == nil)
            cell = [[profilePictureCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier: @"profilepic"];
        return cell;
        
    } else if (indexPath.row == 8){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"logoff"];
        if(cell == nil)
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier: @"logoff"];
        return cell;
        
    } else {
        TypicalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"normal"];
        if(cell == nil)
            cell = [[TypicalTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier: @"normal"];
        cell.title.text = self.identifiers[indexPath.row-1];
        cell.value.text = self.defaultVal[indexPath.row-1];
        return cell;
    }
}

//grabs profile from Firebase
-(void)loadDataFromServer{
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
    FIRDatabaseReference *userRef = [[_ref child:@"users"] child:user.uid];
    
    [userRef observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        if(snapshot.value != [NSNull null])
            _userData = snapshot.value;
        for (NSInteger i = 0; i < [self.tableView numberOfRowsInSection:0]; i++){
            if(i == 0){
                profilePictureCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                //not yet implemented
            } else if (i == 1){
                TypicalTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                cell.value.text = [_userData objectForKey:@"firstName"];
            } else if (i == 2){
                TypicalTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                cell.value.text = [_userData objectForKey:@"lastName"];
            } else if (i == 3){
                TypicalTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                cell.value.text = [_userData objectForKey:@"age"];
            } else if (i == 4){
                TypicalTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                cell.value.text = [_userData objectForKey:@"occupation"];
            } else if (i == 5){
                TypicalTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                cell.value.text = [_userData objectForKey:@"bio"];
            } else if (i == 6){
                TypicalTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                cell.value.text = user.email;
            } else if (i == 7){
                TypicalTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                cell.value.text = @"******";
            }
        }
    }];
    
    [spinner startAnimating];
    [overlay removeFromSuperview];
}

-(IBAction)goBackToProfile:(UIStoryboardSegue *)segue {

}

@end
