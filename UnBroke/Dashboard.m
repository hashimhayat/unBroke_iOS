//
//  Dashboard.m
//  UnBroke
//
//  Created by Shuaib Jewon on 12/6/16.
//  Copyright © 2016 nyu.edu. All rights reserved.
//

#import "Dashboard.h"
#import "LatestThreeJobsTableViewCell.h"
#import "LatestJobUpdatesTableViewCell.h"


@import Firebase;

@interface Dashboard ()

@end

@implementation Dashboard

- (void)viewDidLoad {
    [super viewDidLoad];
    _ref = [[FIRDatabase database] reference];
    
    _postingsTbl.layer.cornerRadius = 7;
    _updatesTbl.layer.cornerRadius = 7;
    
    _showPosting = YES;
    _showNotifications = YES;
    
    [self loadPostings];
}

- (void)viewDidLayoutSubviews{
    [self setTableDimensions];
}

//to allow for scrolling
- (void) setTableDimensions{
    CGRect framePostings = _postingsTbl.frame;
    CGRect frameUpdates = _updatesTbl.frame;
    
    framePostings.origin.y = self.navigationController.navigationBar.frame.size.height + 20;
    if(_showPosting)
        framePostings.size.height = 194;
    else
        framePostings.size.height = 40;
    frameUpdates.origin.y = framePostings.origin.y + framePostings.size.height + 20;
    if(_showNotifications)
        if(_updates.count == 0)
            frameUpdates.size.height = 194;
        else
            frameUpdates.size.height = 40 + (_updates.count*44);
    else
        frameUpdates.size.height = 40;
    CGFloat contentSizeY = frameUpdates.origin.y + frameUpdates.size.height + 70;
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         _postingsTbl.frame = framePostings;
                         _updatesTbl.frame = frameUpdates;
                         [_scrollView setContentSize:CGSizeMake(_scrollView.frame.size.width, contentSizeY)];
                     }
     ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) loadPostings{
    FIRUser *user = [FIRAuth auth].currentUser;
    FIRDatabaseReference *jobData = [_ref child:@"jobs"];
    [jobData observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSDictionary *jobs = snapshot.value;
        _jobs = [[NSMutableArray alloc] init];
        
        if(![jobs isEqual:[NSNull null]]){
            for(NSDictionary *entry in jobs){
                NSDictionary *job = [jobs valueForKeyPath:[NSString stringWithFormat:@"%@",entry]];
                if(![user.uid isEqualToString:[job objectForKey:@"owner"]]){
                    [_jobs addObject:job];
                }
            }
            
            NSArray *sortedByDate = [_jobs sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
                NSString *firstStr = [(NSDictionary *)a objectForKey:@"timestamp"];
                NSString *secondStr = [(NSDictionary *)b objectForKey:@"timestamp"];
                NSTimeInterval firstInterval=[firstStr doubleValue];
                NSTimeInterval secondInterval=[secondStr doubleValue];
                NSDate *first = [NSDate dateWithTimeIntervalSince1970:firstInterval];
                NSDate *second = [NSDate dateWithTimeIntervalSince1970:secondInterval];
                
                return [first compare:second];
            }];
            
            _jobs = [sortedByDate mutableCopy];
        }
        
        _postingsTbl.backgroundView = [[UIView alloc] init];
        if(_jobs.count == 0){
            UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
            
            messageLabel.text = @"No data is currently available";
            messageLabel.textColor = [UIColor darkGrayColor];
            messageLabel.numberOfLines = 0;
            messageLabel.textAlignment = NSTextAlignmentCenter;
            [messageLabel sizeToFit];
            
            _postingsTbl.backgroundView = messageLabel;
        }
        [self loadUpdates];
        [_postingsTbl reloadData];
    }];
}

-(void) loadUpdates{
    FIRUser *user = [FIRAuth auth].currentUser;
    _updates = [[NSMutableArray alloc] init];
    
    for(NSDictionary *job in _jobs){
        if([job[@"owner"] isEqualToString:user.uid]){
            if([job[@"matched"] isEqualToString:@"yes"]){
                [_updates addObject:@{
                                      @"message": [[NSString alloc] initWithFormat:@"Match found for job %@", job[@"name"]],
                                      @"status":@"good",
                }];
            } else {
                NSArray *applicants = (NSArray *)job[@"applicants"];
                if(applicants.count == 1){
                    [_updates addObject:@{
                                          @"message": [[NSString alloc] initWithFormat:@"No applicants yet for job %@", job[@"name"]],
                                          @"status":@"bad",
                    }];
                } else {
                    [_updates addObject:@{
                                          @"message": [[NSString alloc] initWithFormat:@"%lu possible candidates for job %@", applicants.count, job[@"name"]],
                                          @"status":@"good",
                                          }];
                }
            }
        }
    }
    
    _updatesTbl.backgroundView = [[UIView alloc] init];
    if(_updates.count == 0){
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        
        messageLabel.text = @"No data is currently available";
        messageLabel.textColor = [UIColor darkGrayColor];
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        [messageLabel sizeToFit];
        
        _updatesTbl.backgroundView = messageLabel;
    }
    
    [_updatesTbl reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0)
        //title row
        return 40.0f;
    
    if (tableView.tag == 2 && indexPath.row == 1 && _jobs.count > 0)
        //postings row
        return 150.0f;
    
    return UITableViewAutomaticDimension;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView.tag == 1){
        //notifications
        return 2;
    } else if(tableView.tag == 2){
        //postings
        return 2;
    }else if(tableView.tag == 3){
        //job updates
        return _updates.count+1;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView.tag == 2){
        //postings
        if(indexPath.row == 0){
            NSString *identifier = @"title";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: identifier];
            if(cell == nil)
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier: identifier];
            cell.contentView.layer.cornerRadius = 10;
            return cell;
        } else {
            NSString *identifier = @"entry";
            LatestThreeJobsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if(cell == nil)
                cell = [[LatestThreeJobsTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier: identifier];
            cell.contentView.layer.cornerRadius = 10;
            
            cell.entryOneImageView.alpha = 0;
            cell.entryOneLabel.alpha = 0;
            cell.entryTwoImageView.alpha = 0;
            cell.entryTwoLabel.alpha = 0;
            cell.entryThreeImageView.alpha = 0;
            cell.entryThreeLabel.alpha = 0;
            
            if(_jobs.count > 0){
                cell.entryOneImageView.alpha = 1;
                cell.entryOneLabel.alpha = 1;
                cell.entryOneImageView.image = [UIImage imageNamed:[self getCategoryImageName:_jobs[0][@"category"]]];
                cell.entryOneLabel.text = _jobs[0][@"name"];
            }
            
            if(_jobs.count > 1){
                cell.entryTwoImageView.alpha = 1;
                cell.entryTwoLabel.alpha = 1;
                cell.entryTwoImageView.image = [UIImage imageNamed:[self getCategoryImageName:_jobs[1][@"category"]]];
                cell.entryTwoLabel.text = _jobs[1][@"name"];
            }
            
            if(_jobs.count > 2){
                cell.entryThreeImageView.alpha = 1;
                cell.entryThreeLabel.alpha = 1;
                cell.entryThreeImageView.image = [UIImage imageNamed:[self getCategoryImageName:_jobs[2][@"category"]]];
                cell.entryThreeLabel.text = _jobs[2][@"name"];
            }
            
            return cell;
        }
        
        
    } else if(tableView.tag == 3){
        //job updates
        if(indexPath.row == 0){
            NSString *identifier = @"title";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: identifier];
            if(cell == nil)
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier: identifier];
            cell.contentView.layer.cornerRadius = 10;
            return cell;
        } else {
            NSString *identifier = _updates[indexPath.row-1][@"status"];
            LatestJobUpdatesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if(cell == nil)
                cell = [[LatestJobUpdatesTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier: identifier];
            cell.label.text = _updates[indexPath.row-1][@"message"];
            return cell;
        }
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView.tag == 2){
        //postings
        if(indexPath.row == 0){
            _showPosting = !_showPosting;
            [self setTableDimensions];
        } else {
            [self.tabBarController setSelectedIndex:2];
        }
    } else if(tableView.tag == 3){
        //job updates
        if(indexPath.row == 0){
            _showNotifications = !_showNotifications;
            [self setTableDimensions];
        } else {
            [self.tabBarController setSelectedIndex:1];
        }
    }
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
    
    if([category isEqualToString:@"Service Industry"]){
        retVal = @"service";
    }
    
    if([category isEqualToString:@"Teaching"]){
        retVal = @"teaching";
    }
    
    return retVal;
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
                             [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                             }];
                         }];
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    }];
}



@end
