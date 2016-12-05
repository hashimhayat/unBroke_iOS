//
//  MessagesViewController.m
//  UnBroke
//
//  Created by Shuaib Jewon on 11/29/16.
//  Copyright © 2016 nyu.edu. All rights reserved.
//

#import "MessagesViewController.h"

#define FONT_SIZE 14.0f
#define CELL_CONTENT_WIDTH 320.0f
#define CELL_CONTENT_MARGIN 10.0f

@interface MessagesViewController ()

@end

@implementation MessagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.identifiers = @[@"Alex Baines", @"Sarah Marcos", @"Clovis Tyrell"];
    self.defaultVal =  @[@"Hey :)", @"Perfect! Yes I can meet you. How much will you charge btw?", @"Do you have any experience with tutoring kids?"];
    self.profilePic = @[@"pp1", @"pp2", @"pp3"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//credits to http://stackoverflow.com/questions/7189523/how-to-give-space-between-two-cells-in-tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.identifiers count];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}


- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier = @"default";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if(cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier: identifier];
    
    cell.textLabel.text = self.identifiers[indexPath.section];
    cell.detailTextLabel.text = self.defaultVal[indexPath.section];
    cell.imageView.image = [UIImage imageNamed:self.profilePic[indexPath.section]];
    
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 1)
        [self performSegueWithIdentifier:@"showMessageThread" sender:self];
}

-(IBAction)goBackToMessages:(UIStoryboardSegue *)segue {
}

@end
