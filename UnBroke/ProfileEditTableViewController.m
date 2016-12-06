//
//  ProfileEditTableViewController.m
//  UnBroke
//
//  Created by Shuaib Jewon on 12/5/16.
//  Copyright © 2016 nyu.edu. All rights reserved.
//

#import "ProfileEditTableViewController.h"
#import "TypicalTableViewCell.h"

@interface ProfileEditTableViewController ()

@end

@implementation ProfileEditTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //set background for table view
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background"]];
    [tempImageView setFrame:self.tableView.frame];
    self.tableView.backgroundView = tempImageView;
    
    self.identifiers = @[@"First Name", @"Last Name"];
    self.defaultVal =  @[@"Sasha", @"Grey"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0)
        return 215.0f;
    
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"changepp"];
        if(cell == nil)
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier: @"changepp"];
        return cell;
        
    } else if (indexPath.row == 3){
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
        return cell;
    }
}

@end

