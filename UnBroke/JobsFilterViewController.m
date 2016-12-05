//
//  JobsFilterViewController.m
//  UnBroke
//
//  Created by Shuaib Jewon on 11/29/16.
//  Copyright © 2016 nyu.edu. All rights reserved.
//

#import "JobsFilterViewController.h"

@interface JobsFilterViewController ()

@end

@implementation JobsFilterViewController

@synthesize defaultVal = _defaultVal;
@synthesize identifiers = _identifiers;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _identifiers = @[@"Sort By", @"Sort In", @"Category", @"Salary", @"Distance"];
    _defaultVal = [NSMutableArray arrayWithObjects:@"Name", @"Ascending Order", @"All", @"All", @"All", nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_identifiers count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier = @"default";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if(cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier: identifier];
    
    cell.textLabel.text = _identifiers[indexPath.row];
    cell.detailTextLabel.text = _defaultVal[indexPath.row];
    
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
    
    //credits http://stackoverflow.com/questions/33996443/how-to-add-text-input-in-alertview-of-ios-8
    
    NSString *alertTitle = [NSString stringWithFormat:@"%@%@%@", @"New ", self.identifiers[indexPath.row], @" Value"];
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: alertTitle
                                                                              message: @""
                                                                       preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.placeholder = NSLocalizedString(_identifiers[indexPath.row], _identifiers[indexPath.row]);
    }];
    
    
    [alertController addAction:[UIAlertAction
                                actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel action")
                                style:UIAlertActionStyleCancel
                                handler:^(UIAlertAction *action){}
                                ]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [_defaultVal replaceObjectAtIndex:indexPath.row withObject:alertController.textFields.firstObject.text];
        [self.tableView reloadData];
    }]];
    
    
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
