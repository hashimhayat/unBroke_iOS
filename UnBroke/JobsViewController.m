//
//  JobsViewController.m
//  UnBroke
//
//  Created by Shuaib Jewon on 11/29/16.
//  Copyright © 2016 nyu.edu. All rights reserved.
//

#import "JobsViewController.h"
#import "JobEntryTableViewCell.h"
#import "JobsSingleViewController.h"

@interface JobsViewController ()
@end

@implementation JobsViewController

@synthesize tableView = _tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDataFirebase];
    _filterCategory = @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
 *
 * Below methods to generate table
 *
 */

- (void) loadDataFirebase {
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
    
    _ref = [[FIRDatabase database] reference];
    
    _data = [[NSMutableArray alloc] init];
    _originalData = [[NSMutableArray alloc] init];
    
    FIRUser *user = [FIRAuth auth].currentUser;
    FIRDatabaseReference *jobData = [_ref child:@"jobs"];
    [jobData observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSDictionary *jobs = snapshot.value;
        _data = [[NSMutableArray alloc] init];
        _originalData = [[NSMutableArray alloc] init];
        
        if(![jobs isEqual:[NSNull null]]){
            for(NSDictionary *entry in jobs){
                NSDictionary *job = [jobs valueForKeyPath:[NSString stringWithFormat:@"%@",entry]];
                if(![user.uid isEqualToString:[job objectForKey:@"owner"]]){
                    if([_filterCategory isEqualToString:@""]){
                        [_originalData addObject:job];
                    } else {
                        if([[job objectForKey:@"category"] isEqualToString:_filterCategory]){
                            [_originalData addObject:job];
                        }
                    }
                }
            }
            
            NSArray *sortedByDate = [_originalData sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
                NSString *firstStr = [(NSDictionary *)a objectForKey:@"timestamp"];
                NSString *secondStr = [(NSDictionary *)b objectForKey:@"timestamp"];
                NSTimeInterval firstInterval=[firstStr doubleValue];
                NSTimeInterval secondInterval=[secondStr doubleValue];
                NSDate *first = [NSDate dateWithTimeIntervalSince1970:firstInterval];
                NSDate *second = [NSDate dateWithTimeIntervalSince1970:secondInterval];
                
                return [second compare:first];
            }];
            
            _originalData = [sortedByDate mutableCopy];
            _data = [sortedByDate mutableCopy];
        }
        
        if([jobs isEqual:[NSNull null]] || _data.count == 0){
            UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        
            messageLabel.text = @"No data is currently available";
            messageLabel.textColor = [UIColor darkGrayColor];
            messageLabel.numberOfLines = 0;
            messageLabel.textAlignment = NSTextAlignmentCenter;
            [messageLabel sizeToFit];
        
            _tableView.backgroundView = messageLabel;
        }

        [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
        
        [spinner stopAnimating];
        [overlay removeFromSuperview];
    }];
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _data.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIdentifier = @"jobEntry";
    JobEntryTableViewCell *cell = (JobEntryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
        cell = [[JobEntryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    
    if(_data.count > 0){
        //load data into table if data is present
        self.tableView.backgroundView = nil;
        
        NSDictionary *job = [_data objectAtIndex:indexPath.row];
        
        cell.name.text = [NSString stringWithFormat:@"%@",[job objectForKey:@"name"]];
        cell.category.text = [NSString stringWithFormat:@"%@",[job objectForKey:@"category"]];
        cell.salary.text = [NSString stringWithFormat:@"$%@/hr",[job objectForKey:@"salary"]];
        cell.cellImageView.image = [UIImage imageNamed:[self getCategoryImageName:[job objectForKey:@"category"]]];
        cell.cellImageView.layer.cornerRadius = 7;
    }
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"showJob" sender:self];
}

-(IBAction)goBackToJobs:(UIStoryboardSegue *)segue {
    _filterCategory = @"";
    [self loadDataFirebase];
}

-(IBAction)filterAndGoBackToJobs:(UIStoryboardSegue *)segue {
    [self loadDataFirebase];
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

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [_data removeAllObjects];
    if (searchText.length == 0) {
        _data = [_originalData mutableCopy];
    } else {
        _data = [[NSMutableArray alloc] init];
        for (NSDictionary *job in _originalData) {
            if ([[[job objectForKey:@"name"] lowercaseString] containsString:[searchText lowercaseString]] ||
                [[[job objectForKey:@"category"] lowercaseString] containsString:[searchText lowercaseString]] ||
                [[[job objectForKey:@"salary"] lowercaseString] containsString:[searchText lowercaseString]]) {
                
                [_data addObject:job];
            }
        }
    }
    
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
}


-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [_data removeAllObjects];
    _data = [_originalData mutableCopy];
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
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


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"showJob"]){
        NSIndexPath *indexPath = [_tableView indexPathForSelectedRow];
        JobsSingleViewController *destViewController = segue.destinationViewController;
        destViewController.job = [_data objectAtIndex:indexPath.row];
    }
}

@end
