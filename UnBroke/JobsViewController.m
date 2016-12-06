//
//  JobsViewController.m
//  UnBroke
//
//  Created by Shuaib Jewon on 11/29/16.
//  Copyright © 2016 nyu.edu. All rights reserved.
//

#import "JobEntry.h"
#import "JobsViewController.h"

@interface JobsViewController ()

@end

@implementation JobsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

//set height of cells
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *cellIdentifier = @"jobEntry";
    JobEntry *cell = (JobEntry *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
        cell = [[JobEntry alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    
    switch(indexPath.row){
        case 2:
            cell.jobTitle.text = @"English Tutor";
            cell.salary.text = @"$15/hr";
            cell.distance.text = @"2 miles away";
            cell.image.image = [UIImage imageNamed:@"tutor"];
            break;
        case 0:
            cell.jobTitle.text = @"Plumber";
            cell.salary.text = @"$30/hr";
            cell.distance.text = @"22 miles away";
            cell.image.image = [UIImage imageNamed:@"plumber"];
            break;
        case 1:
            cell.jobTitle.text = @"C# Assistance";
            cell.salary.text = @"$40/hr";
            cell.distance.text = @"1645 miles away";
            cell.image.image = [UIImage imageNamed:@"coder"];
            break;
        default:
            cell.jobTitle.text = @"Dutch Tutor";
            cell.salary.text = @"$15/hr";
            cell.distance.text = @"3 miles away";
            cell.image.image = [UIImage imageNamed:@"background"];
            break;
    }
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 2)
        [self performSegueWithIdentifier:@"showJob" sender:self];
}

-(IBAction)goBackToJobs:(UIStoryboardSegue *)segue {
}

@end
