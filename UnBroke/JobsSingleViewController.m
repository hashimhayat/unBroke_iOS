//
//  JobsSingleViewController.m
//  UnBroke
//
//  Created by Shuaib Jewon on 12/10/16.
//  Copyright © 2016 nyu.edu. All rights reserved.
//

#import "JobsSingleViewController.h"
#import "JobEntryTableViewCell.h"
#import "JobDetailsTableViewCell.h"
#import "JobResponseTableViewCell.h"
#import "Dashboard.h"

@import Firebase;

@interface JobsSingleViewController ()
@end

@implementation JobsSingleViewController

@synthesize tableView = _tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    _accepted = false;
    self.ref = [[FIRDatabase database] reference];
    
    FIRUser *user = [FIRAuth auth].currentUser;
    FIRDatabaseReference *applicantRef = [[[_ref child:@"jobs"] child:_job[@"key"]] child:@"applicants"];
    
    //check if user has already applied to this job
    [applicantRef observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        _applied = NO;
        NSArray *applicants = snapshot.value;
        for(int i=0; i<applicants.count; i++){
            NSString *userID = applicants[i];
            if([user.uid isEqualToString:userID]){
                _applied = YES;
                [_tableView reloadData];
            }
        }
    }];
    
    FIRDatabaseReference *matchedRef = [[[_ref child:@"jobs"] child:_job[@"key"]] child:@"matched"];
    FIRDatabaseReference *matchedUserRef = [[[_ref child:@"jobs"] child:_job[@"key"]] child:@"matchedUserID"];
    
    //check if user has applied to job plus got accepted to it
    [matchedRef observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        if([(NSString *)snapshot.value isEqualToString:@"yes"]){
            [matchedUserRef observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                if([(NSString *)snapshot.value isEqualToString:user.uid]){
                    _accepted = YES;
                    [_tableView reloadData];
                }
            }];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//Applies to a job
- (IBAction)apply:(id)sender {
    if(_accepted == NO){
        FIRUser *user = [FIRAuth auth].currentUser;
        FIRDatabaseReference *jobRef = [[_ref child:@"jobs"] child:_job[@"key"]];
        FIRDatabaseReference *applicantRef = [jobRef child:@"applicants"];
        
        [applicantRef observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            NSMutableArray *applicants = snapshot.value;
            [applicants addObject:user.uid];
            [jobRef updateChildValues:@{@"applicants": applicants}];
        }];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"message"]){
        UINavigationController *destViewController = segue.destinationViewController;
        Dashboard *targetController = [destViewController viewControllers][0];
        [targetController.tabBarController setSelectedIndex:3];
    }
}

/*
 *
 * Below methods to generate table
 *
 */

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 2)
        return 44.0f;
    
    return 100.0f;
}

//Loads content into cells
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0){
        NSString *cellIdentifier = @"jobEntry";
        JobEntryTableViewCell *cell = (JobEntryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil)
            cell = [[JobEntryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
        cell.name.text = [_job objectForKey:@"name"];
        cell.category.text = [_job objectForKey:@"category"];
        cell.salary.text = [_job objectForKey:@"salary"];
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
            cell.details.text = [_job objectForKey:@"details"];
        
        return cell;
        
    } else {
        if(_accepted == NO){
            if(_applied){
                NSString *cellIdentifier = @"applied";
                JobResponseTableViewCell *cell = (JobResponseTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                
                if (cell == nil)
                    cell = [[JobResponseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                
                cell.btn.enabled = NO;
                
                return cell;
            } else {
                NSString *cellIdentifier = @"apply";
                JobResponseTableViewCell *cell = (JobResponseTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                
                if (cell == nil)
                    cell = [[JobResponseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                
                cell.btn.enabled = YES;
                
                return cell;
            }
        } else {
            NSString *cellIdentifier = @"accepted";
            JobResponseTableViewCell *cell = (JobResponseTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            
            if (cell == nil)
                cell = [[JobResponseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            
            cell.btn.enabled = YES;
            
            return cell;
        }
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

//outputs name of image needed for a certain category
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
