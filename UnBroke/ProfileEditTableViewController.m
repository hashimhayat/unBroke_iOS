//
//  ProfileEditTableViewController.m
//  UnBroke
//
//  Created by Shuaib Jewon on 12/5/16.
//  Copyright © 2016 nyu.edu. All rights reserved.
//

#import "ProfileEditTableViewController.h"
#import "TypicalTableViewCell.h"
#import "profilePictureCell.h"

@import Firebase;

@interface ProfileEditTableViewController ()
@end

@implementation ProfileEditTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //set background for table view
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background"]];
    [tempImageView setFrame:self.tableView.frame];
    self.tableView.backgroundView = tempImageView;
    
    //default values for empty cells
    self.identifiers = @[@"First Name", @"Last Name", @"Age", @"Occupation", @"Bio"];
    self.defaultVal =  @[@"", @"", @"", @"", @""];
    
    self.ref = [[FIRDatabase database] reference];
    _userData = [[NSDictionary alloc] init];

    [self loadDataFromServer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0)
        return 150.0f;
    
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"changepp"];
        if(cell == nil)
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier: @"changepp"];
        return cell;
        
    } else if (indexPath.row == 6){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"loadfb"];
        if(cell == nil)
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier: @"loadfb"];
        return cell;
        
    } else {
        TypicalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"normal"];
        if(cell == nil)
            cell = [[TypicalTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier: @"normal"];
        cell.title.text = self.identifiers[indexPath.row-1];
        cell.value.text = self.defaultVal[indexPath.row-1];
        cell.value.tag = indexPath.row-1;
        return cell;
    }
}

//Save edits to database
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"save"]){
        
        NSString *fname,*lname,*age,*occupation,*bio;

        for (NSInteger i = 0; i < [self.tableView numberOfRowsInSection:0]; i++){
            if(i == 0){
                //not implemented yet
            } else if (i == 1){
                TypicalTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                fname = cell.value.text;
            } else if (i == 2){
                TypicalTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                lname = cell.value.text;
            } else if (i == 3){
                TypicalTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                age = cell.value.text;
            } else if (i == 4){
                TypicalTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                occupation = cell.value.text;
            } else if (i == 5){
                TypicalTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                bio = cell.value.text;
            }
        }
        
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
        
        NSDictionary *newUserData = @{@"firstName":fname,
                                     @"lastName":lname,
                                     @"age":age,
                                      @"occupation":occupation,
                                     @"bio":bio,
        };
        
        FIRUser *user = [FIRAuth auth].currentUser;
        FIRDatabaseReference *profileRef = [[_ref child:@"users"] child:user.uid];
        
        [profileRef setValue:newUserData];
        
        [spinner stopAnimating];
        [overlay removeFromSuperview];
        
    }
}

//grabs profile data from Firebase
-(void)loadDataFromServer{
    //create overlay
    UIView *overlay = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [overlay setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3]];
    
    //create spinner and set its position to center
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    spinner.center = CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0);
    
    //add spinner to overlay and add overlay to view + start animating
    [UIView animateWithDuration:0.5
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
                cell.image.layer.cornerRadius = 10;
                //not implemented yet
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
            }
        }
    }];
    
    
    [spinner stopAnimating];
    [overlay removeFromSuperview];

}

@end

