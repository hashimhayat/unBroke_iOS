//
//  Dashboard.m
//  UnBroke
//
//  Created by Shuaib Jewon on 12/6/16.
//  Copyright © 2016 nyu.edu. All rights reserved.
//

#import "Dashboard.h"

@interface Dashboard ()

@end

extern NSInteger cornerRadius;

@implementation Dashboard

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _notificationsTbl.layer.cornerRadius = cornerRadius;
    _postingsTbl.layer.cornerRadius = cornerRadius;
    _updatesTbl.layer.cornerRadius = cornerRadius;
    
    //set size of tableview to content size
    dispatch_async(dispatch_get_main_queue(), ^{
        CGRect frameNotifications = _notificationsTbl.frame;
        CGRect framePostings = _postingsTbl.frame;
        CGRect frameUpdates = _updatesTbl.frame;
        
        frameNotifications.size.height = _notificationsTbl.contentSize.height;
        framePostings.size.height = _postingsTbl.contentSize.height;
        frameUpdates.size.height = _updatesTbl.contentSize.height;
        framePostings.origin.y = _notificationsTbl.frame.origin.y + frameNotifications.size.height + 20;
        frameUpdates.origin.y = framePostings.origin.y + framePostings.size.height + 20;
        
        _notificationsTbl.frame = frameNotifications;
        _postingsTbl.frame = framePostings;
        _updatesTbl.frame = frameUpdates;
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0)
        //title row
        return 40.0f;
    
    if (tableView.tag == 2 && indexPath.row == 1)
        //title row
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
        return 3;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView.tag == 1){
        //notifications
        if(indexPath.row == 0){
            NSString *identifier = @"title";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: identifier];
            if(cell == nil)
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier: identifier];
            cell.contentView.layer.cornerRadius = 10;
            return cell;
        } else {
            NSString *identifier = @"entry";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if(cell == nil)
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier: identifier];
            cell.contentView.layer.cornerRadius = 10;
            return cell;
        }
        
        
    } else if(tableView.tag == 2){
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
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if(cell == nil)
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier: identifier];
            cell.contentView.layer.cornerRadius = 10;
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
        } else if(indexPath.row == 1){
            NSString *identifier = @"good";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if(cell == nil)
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier: identifier];
            
            return cell;
        } else if(indexPath.row == 2){
            NSString *identifier = @"good2";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if(cell == nil)
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier: identifier];
            
            return cell;
        }
    }
    return 0;
}

@end
