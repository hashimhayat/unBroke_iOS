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

@import Firebase;

@interface MyJobsSingleViewController ()
@end

@implementation MyJobsSingleViewController

@synthesize tableView = _tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.ref = [[FIRDatabase database] reference];
    
    _jobApplicants = [[NSMutableArray alloc] init];
    
    FIRDatabaseReference *applicantRef = [[[_ref child:@"jobs"] child:_job[@"key"]] child:@"applicants"];
    NSLog(@"it is bs %@", applicantRef);
    [applicantRef observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSArray *applicants = snapshot.value;
        NSLog(@"%@", applicants);
        _jobApplicants = [applicants mutableCopy];
        [_tableView reloadData];
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
    return 3 + [_jobApplicants count];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0){
        NSString *cellIdentifier = @"jobEntry";
        JobEntryTableViewCell *cell = (JobEntryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil)
            cell = [[JobEntryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
        cell.name.text = [NSString stringWithFormat:@"%@",[_job objectForKey:@"name"]];
        cell.category.text = [_job objectForKey:@"category"];
        cell.salary.text = [NSString stringWithFormat:@"$%@/hr", [_job objectForKey:@"salary"]];
        cell.imageView.image = [UIImage imageNamed:[self getCategoryImageName:[_job objectForKey:@"category"]]];
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
        NSString *cellIdentifier = @"applicantList";
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil)
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
        return cell;
    } else {
        NSString *cellIdentifier = @"applicantName";
        ApplicantNameTableViewCell *cell = (ApplicantNameTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil)
            cell = [[ApplicantNameTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
        cell.acceptBtn.layer.cornerRadius = 7;
        cell.rejectBtn.layer.cornerRadius = 7;
        
        FIRDatabaseReference *userRef = [[[_ref child:@"users"] child:[_jobApplicants objectAtIndex:(indexPath.row - 3)]] child:@"firstName"];
        
        [userRef observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            if(snapshot.value != [NSNull null]){
                cell.applicantName.text = snapshot.value;
            } else {
                cell.applicantName.text = [_jobApplicants objectAtIndex:(indexPath.row - 3)];
            }
         }];
        
        return cell;
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
