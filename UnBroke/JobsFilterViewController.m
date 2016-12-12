//
//  JobsFilterViewController.m
//  UnBroke
//
//  Created by Shuaib Jewon on 11/29/16.
//  Copyright © 2016 nyu.edu. All rights reserved.
//

#import "JobsFilterViewController.h"
#import "JobsViewController.h"

@interface JobsFilterViewController ()
@end

@implementation JobsFilterViewController

@synthesize tableView = _tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //set background for table view
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background"]];
    [tempImageView setFrame:self.tableView.frame];
    self.tableView.backgroundView = tempImageView;
    
    //init picker data
    _sortBy = @[@"Name", @"Price", @"Salary"];
    _sortIn = @[@"Ascending Order", @"Descending Order"];
    _cats = @[@"Airline", @"Arts", @"Business", @"Media", @"Medical", @"Service", @"Teaching", @"Technology"];
    _subCats = @[@"Item 1", @"Item 2", @"Item 3", @"Item 4", @"Item 5", @"Item 6"];
    _show1 = false;
    _show3 = false;
    _show5 = false;
    _show7 = false;
    
    _categoryTextField.text = @"Airline";
    [_categoryPicker selectRow:12504 inComponent:0 animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
 *
 * Below methods to generate table
 *
 */

//set height of cells; row 6 is description field, row 2 and 4 are pickers
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 6 || indexPath.row == 7 || indexPath.row == 10 || indexPath.row == 11 ||
       indexPath.row == 12 || indexPath.row == 13 || indexPath.row == 14 || indexPath.row == 15 ||
       indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3 ||
       indexPath.row == 8 || indexPath.row == 9)
        return 0.0f;
    
    if(indexPath.row == 1 && _show1 == true)
        return 124.0f;
    
    if(indexPath.row == 3 && _show3 == true)
        return 124.0f;
    
    if(indexPath.row == 5 && _show5 == true)
        return 124.0f;
    
    if(indexPath.row == 7 && _show7 == true)
        return 124.0f;
    
    if(indexPath.row == 1 && _show1 == false)
        return 0.0f;
    
    if(indexPath.row == 3 && _show3 == false)
        return 0.0f;
    
    if(indexPath.row == 5 && _show5 == false)
        return 0.0f;
    
    if(indexPath.row == 7 && _show7 == false)
        return 0.0f;

    return UITableViewAutomaticDimension;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch(indexPath.row){
        case 0:
            _show1 = !_show1;
            _show3 = false;
            _show5 = false;
            _show7 = false;
            break;
        case 1:
            _show1 = true;
            _show3 = false;
            _show5 = false;
            _show7 = false;
            break;
        case 2:
            _show1 = false;
            _show3 = !_show3;
            _show5 = false;
            _show7 = false;
            break;
        case 3:
            _show1 = false;
            _show3 = true;
            _show5 = false;
            _show7 = false;
            break;
        case 4:
            _show1 = false;
            _show3 = false;
            _show5 = !_show5;
            _show7 = false;
            break;
        case 5:
            _show1 = false;
            _show3 = false;
            _show5 = true;
            _show7 = false;
            break;
        case 6:
            _show1 = false;
            _show3 = false;
            _show5 = false;
            _show7 = !_show7;
            break;
        case 7:
            _show1 = false;
            _show3 = false;
            _show5 = false;
            _show7 = true;
            break;
        default:
            _show1 = false;
            _show3 = false;
            _show5 = false;
            _show7 = false;
            break;
    }
    
    [_tableView beginUpdates];
    [_tableView endUpdates];
}

/*
 *
 * Below methods to set up pickers
 *
 */

// The number of columns of data in picker
- (long)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

// The number of rows of data in picker
- (long)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 50000;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if([pickerView.accessibilityLabel  isEqual: @"subcats"]){
        return _subCats[row % _subCats.count];
    } else if([pickerView.accessibilityLabel  isEqual: @"cats"]){
        return _cats[row % _cats.count];
    } else if([pickerView.accessibilityLabel  isEqual: @"sortin"]){
        return _sortIn[row % _sortIn.count];
    } else if([pickerView.accessibilityLabel  isEqual: @"sortby"]){
        return _sortBy[row % _sortBy.count];
    }
    return 0;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if([pickerView.accessibilityLabel  isEqual: @"cats"])
        _categoryTextField.text = _cats[row % _cats.count];
    else if ([pickerView.accessibilityLabel  isEqual: @"subcats"])
        _subCategoryTextField.text = _subCats[row % _subCats.count];
    else if ([pickerView.accessibilityLabel  isEqual: @"sortin"])
        _sortInTextField.text = _sortIn[row % _sortIn.count];
    else if ([pickerView.accessibilityLabel  isEqual: @"sortby"])
        _sortByTextField.text = _sortBy[row % _sortBy.count];
}

/*
 *
 * Below methods for slider interaction
 *
 */

- (IBAction)minSalaryChanged:(id)sender {
    if(_sliderMinSalary.value>_sliderMinSalary.minimumValue)
        _minSalaryTextField.text = [NSString stringWithFormat:@"$%.02f", _sliderMinSalary.value];
    else
        _minSalaryTextField.text = [NSString stringWithFormat:@"None"];
}

- (IBAction)maxSalaryChanged:(id)sender {
    if(_sliderMaxSalary.value<_sliderMaxSalary.maximumValue)
        _maxSalaryTextField.text = [NSString stringWithFormat:@"$%.02f", _sliderMaxSalary.value];
    else
        _maxSalaryTextField.text = [NSString stringWithFormat:@"None"];
}

- (IBAction)minDistanceChanged:(id)sender {
    if(_sliderMinDistance.value>_sliderMinDistance.minimumValue)
        _minDistanceTextField.text = [NSString stringWithFormat:@"%.f miles", _sliderMinDistance.value];
    else
        _minDistanceTextField.text = [NSString stringWithFormat:@"None"];
}

- (IBAction)maxDistanceChanged:(id)sender {
    if(_sliderMaxDistance.value<_sliderMaxDistance.maximumValue)
        _maxDistanceTextField.text = [NSString stringWithFormat:@"%.f miles", _sliderMaxDistance.value];
    else
        _maxDistanceTextField.text = [NSString stringWithFormat:@"None"];
}

-(void) showAlertWithMessage:(NSString *)msg {
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:nil
                                  message: msg
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action){
                             [alert dismissViewControllerAnimated:YES completion:nil];
                         }];
    
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"filter"]){
        JobsViewController *destViewController = segue.destinationViewController;
        destViewController.filterCategory = _categoryTextField.text;
    }
}

@end
