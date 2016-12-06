//
//  MessagesViewController.m
//  UnBroke
//
//  Created by Shuaib Jewon on 11/29/16.
//  Copyright © 2016 nyu.edu. All rights reserved.
//

#import "ThreadEntry.h"
#import "MessagesViewController.h"

@interface MessagesViewController ()

@end

@implementation MessagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _identifiers = @[@"Alex Baines", @"Sarah Marcos", @"Clovis Tyrell"];
    _defaultVal =  @[@"Hey :)", @"Perfect! Yes I can meet you. How much will you charge btw?", @"Do you have any experience with tutoring kids?"];
    _profilePic = @[@"pp1", @"pp2", @"pp3"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _identifiers.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier = @"thread";
    ThreadEntry *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if(cell == nil)
        cell = [[ThreadEntry alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier: identifier];
    
    cell.name.text = self.identifiers[indexPath.row];
    cell.lastText.text = self.defaultVal[indexPath.row];
    cell.image.image = [UIImage imageNamed:self.profilePic[indexPath.row]];
    
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
    if(indexPath.row == 1)
        [self performSegueWithIdentifier:@"showMessageThread" sender:self];
}

-(IBAction)goBackToMessages:(UIStoryboardSegue *)segue {
}

@end
