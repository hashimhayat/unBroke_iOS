//
//  MyJobsSingleViewController.m
//  UnBroke
//
//  Created by Shuaib Jewon on 12/10/16.
//  Copyright © 2016 nyu.edu. All rights reserved.
//

#import "MyJobsSingleViewController.h"
#import "JobEntryTableViewCell.h"
#import "JobDetailsTableViewCell.h"
#import "ApplicantNameTableViewCell.h"
#import "matchedApplicantNameTableViewCell.h"
#import "MessagesThreadViewController.h"
#import "Dashboard.h"

@import Firebase;

@interface MyJobsSingleViewController ()
@end

@implementation MyJobsSingleViewController

@synthesize tableView = _tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.ref = [[FIRDatabase database] reference];
    _matchFound = NO;
    _matchedUserID = @"nil";
    _jobApplicants = [[NSMutableArray alloc] init];
    
    FIRDatabaseReference *applicantRef = [[[_ref child:@"jobs"] child:_job[@"key"]] child:@"applicants"];
    
    //retrieve list of applicants for that job
    [applicantRef observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSArray *applicants = snapshot.value;
        _jobApplicants = [applicants mutableCopy];
        [_tableView reloadData];
    }];
    
    FIRDatabaseReference *matchedRef = [[[_ref child:@"jobs"] child:_job[@"key"]] child:@"matched"];
    FIRDatabaseReference *matchedUserRef = [[[_ref child:@"jobs"] child:_job[@"key"]] child:@"matchedUserID"];
    
    //checks if job search/match is over
    [matchedRef observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        if([(NSString *)snapshot.value isEqualToString:@"yes"]){
            _matchFound = YES;
            [matchedUserRef observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                _matchedUserID = snapshot.value;
                [_tableView reloadData];
            }];
        }
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
    if(_matchFound == NO)
        return 3 + [_jobApplicants count];
    else
        return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0 || indexPath.row == 1)
        return 100.0f;
    
    if (indexPath.row == 3)
        return 0.0f;
    
    return 44.0f;
}

-(NSInteger)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.0f;
}

//Generates table cells depending on row position
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0){
        NSString *cellIdentifier = @"jobEntry";
        JobEntryTableViewCell *cell = (JobEntryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil)
            cell = [[JobEntryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
        cell.name.text = [NSString stringWithFormat:@"%@",[_job objectForKey:@"name"]];
        cell.category.text = [_job objectForKey:@"category"];
        cell.salary.text = [NSString stringWithFormat:@"$%@/hr", [_job objectForKey:@"salary"]];
        cell.cellImageView.image = [UIImage imageNamed:[self getCategoryImageName:[_job objectForKey:@"category"]]];
        cell.cellImageView.layer.cornerRadius = 7;
        
        return cell;
    } else if (indexPath.row == 1) {
        NSString *cellIdentifier = @"jobDetails";
        JobDetailsTableViewCell *cell = (JobDetailsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil)
            cell = [[JobDetailsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
        if ([[_job objectForKey:@"details"] isEqualToString:@""])
            cell.details.text = @"No description provided";
        else
            cell.details.text = [NSString stringWithFormat:@"%@",[_job objectForKey:@"details"]];
        
        return cell;
        
    } else if (indexPath.row == 2) {
        if(_matchFound == NO){
            NSString *cellIdentifier = @"applicantList";
            UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            
            if (cell == nil)
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            
            return cell;
        } else {
            NSString *cellIdentifier = @"matchFound";
            UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            
            if (cell == nil)
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            
            return cell;
        }
    } else {
        if(_matchFound == NO){
            NSString *cellIdentifier = @"applicantName";
            ApplicantNameTableViewCell *cell = (ApplicantNameTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            
            if (cell == nil)
                cell = [[ApplicantNameTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            
            cell.acceptBtn.layer.cornerRadius = 7;
            cell.rejectBtn.layer.cornerRadius = 7;
            
            FIRDatabaseReference *userRef = [[_ref child:@"users"] child:[_jobApplicants objectAtIndex:(indexPath.row - 3)]] /*child:@"firstName"*/;
    
            [userRef observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                NSString *name = [[NSString alloc] init];
                NSString *fname = [[NSString alloc] init];
                NSString *lname = [[NSString alloc] init];
        
                for (FIRDataSnapshot *child in snapshot.children) {
                    if(child.value != [NSNull null] && [child.key isEqualToString:@"firstName"])
                        fname = child.value;
                    if(child.value != [NSNull null] && [child.key isEqualToString:@"lastName"])
                        lname = child.value;
                }
                if(![fname isEqualToString:@""])
                    if(![lname isEqualToString:@""])
                        name = [[NSString alloc] initWithFormat:@"%@ %@", fname, lname];
                    else
                        name = [[NSString alloc] initWithFormat:@"%@", fname];
                else if (![lname isEqualToString:@""])
                    name = [[NSString alloc] initWithFormat:@"%@", lname];
                
                if(![name isEqualToString:@""]){
                    cell.applicantName.text = name;
                } else {
                    cell.applicantName.text = [_jobApplicants objectAtIndex:(indexPath.row - 3)];
                }
                cell.jobID = _job[@"key"];
                cell.userID = [_jobApplicants objectAtIndex:(indexPath.row - 3)];
                cell.jobName = _job[@"name"];
                
                FIRUser *user = [FIRAuth auth].currentUser;
                [[[_ref child:@"users"] child:user.uid] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                    NSString *name = [[NSString alloc] init];
                    NSString *fname = [[NSString alloc] init];
                    NSString *lname = [[NSString alloc] init];
                    
                    for (FIRDataSnapshot *child in snapshot.children) {
                        if(child.value != [NSNull null] && [child.key isEqualToString:@"firstName"])
                            fname = child.value;
                        if(child.value != [NSNull null] && [child.key isEqualToString:@"lastName"])
                            lname = child.value;
                    }
                    if(![fname isEqualToString:@""])
                        if(![lname isEqualToString:@""])
                            name = [[NSString alloc] initWithFormat:@"%@ %@", fname, lname];
                        else
                            name = [[NSString alloc] initWithFormat:@"%@", fname];
                        else if (![lname isEqualToString:@""])
                            name = [[NSString alloc] initWithFormat:@"%@", lname];
                    
                    if(![name isEqualToString:@""]){
                        cell.creatorName = name;
                    } else {
                        cell.creatorName = [_jobApplicants objectAtIndex:(indexPath.row - 3)];
                    }
                }];
                
             }];
            
            return cell;
        } else {
            NSString *cellIdentifier = @"matchedApplicantName";
            matchedApplicantNameTableViewCell *cell = (matchedApplicantNameTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            
            if (cell == nil)
                cell = [[matchedApplicantNameTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            
            cell.contactBtn.layer.cornerRadius = 7;
            
            FIRDatabaseReference *userRef = [[_ref child:@"users"] child:[_jobApplicants objectAtIndex:(indexPath.row - 3)]] /*child:@"firstName"*/;
            
            [userRef observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                NSString *name = [[NSString alloc] init];
                NSString *fname = [[NSString alloc] init];
                NSString *lname = [[NSString alloc] init];
                
                for (FIRDataSnapshot *child in snapshot.children) {
                    if(child.value != [NSNull null] && [child.key isEqualToString:@"firstName"])
                        fname = child.value;
                    if(child.value != [NSNull null] && [child.key isEqualToString:@"lastName"])
                        lname = child.value;
                }
                if(![fname isEqualToString:@""])
                    if(![lname isEqualToString:@""])
                        name = [[NSString alloc] initWithFormat:@"%@ %@", fname, lname];
                    else
                        name = [[NSString alloc] initWithFormat:@"%@", fname];
                    else if (![lname isEqualToString:@""])
                        name = [[NSString alloc] initWithFormat:@"%@", lname];
                
                if(![name isEqualToString:@""]){
                    cell.applicantName.text = name;
                } else {
                    cell.applicantName.text = [_jobApplicants objectAtIndex:(indexPath.row - 3)];
                }
                cell.userID = [_jobApplicants objectAtIndex:(indexPath.row - 3)];
            }];
            
            return cell;
        }
    }
}

//programatic segue because we're not moving directly to messages tab but to nav controller first
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"message"]){
        UINavigationController *destViewController = segue.destinationViewController;
        Dashboard *targetController = [destViewController viewControllers][0];
        [targetController.tabBarController setSelectedIndex:3];
    }
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
                            [alert dismissViewControllerAnimated:YES completion:nil];
                         }];
    
    
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

//returns name of image associate with category
-(NSString *) getCategoryImageName:(NSString *)category {
    NSString *retVal = @"other";
    
    if([category isEqualToString:@"Airline"]){
        retVal = @"airline";
    }
    
    if([category isEqualToString:@"Arts"]){
        retVal = @"art";
    }
    
    if([category isEqualToString:@"Business"]){
        retVal = @"business";
    }
    
    if([category isEqualToString:@"Law Enforcement"]){
        retVal = @"legal";
    }
    
    if([category isEqualToString:@"Media"]){
        retVal = @"media";
    }
    
    if([category isEqualToString:@"Medical"]){
        retVal = @"medical";
    }
    
    if([category isEqualToString:@"Technology"]){
        retVal = @"tech";
    }
    
    if([category isEqualToString:@"Service"]){
        retVal = @"service";
    }
    
    if([category isEqualToString:@"Teaching"]){
        retVal = @"teaching";
    }
    return retVal;
}
@end
