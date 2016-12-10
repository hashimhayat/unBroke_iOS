//
//  JobsFilterViewController.m
//  UnBroke
//
//  Created by Shuaib Jewon on 11/29/16.
//  Copyright © 2016 nyu.edu. All rights reserved.
//

#import "JobsFilterViewController.h"

typedef void (^ IteratorBlock)(id object);

@interface JobsFilterViewController ()

@end

@implementation JobsFilterViewController

@synthesize tableView = _tableView;

extern NSString *apiUrl;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //set background for table view
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background"]];
    [tempImageView setFrame:self.tableView.frame];
    self.tableView.backgroundView = tempImageView;
    
    //init picker data
    _sortBy = @[@"Name", @"Price", @"Salary"];
    _sortIn = @[@"Ascending Order", @"Descending Order"];
    _cats = @[@"Category 1", @"Category 2", @"Category 3"];
    _subCats = @[@"Item 1", @"Item 2", @"Item 3", @"Item 4", @"Item 5", @"Item 6"];
    _scrollSize = 50000;
    _show1 = false;
    _show3 = false;
    _show5 = false;
    _show7 = false;
    
    [self sendPostRequestWithData:@"" sendPostRequestTo:@"get_job_cat.php" postCustomCommand:^(id object){
        NSDictionary *results = object;
        NSMutableArray *temp = [[NSMutableArray alloc] init];
        for (NSDictionary *entry in results) {
            if([entry objectForKey:@"category"] != nil)
                [temp addObject:[entry objectForKey:@"category"]];
        }
        
        _cats = [temp copy];
        
        //picker infinite scroll starting at first element
        NSInteger start = _scrollSize/2;
        while(start % _sortBy.count!=0)
            start++;
        [_sortByPicker selectRow:start inComponent:0 animated:NO];
        while(start % _sortIn.count!=0)
            start++;
        [_sortInPicker selectRow:start inComponent:0 animated:NO];
        while(start % _cats.count!=0)
            start++;
        [_categoryPicker selectRow:start inComponent:0 animated:NO];
        while(start % _subCats.count!=0)
            start++;
        [_subCategoryPicker selectRow:start inComponent:0 animated:NO];
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


//set height of cells; row 6 is description field, row 2 and 4 are pickers
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 6 || indexPath.row == 7 || indexPath.row == 10 || indexPath.row == 11 || indexPath.row == 12 || indexPath.row == 13)
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
    return _scrollSize;
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

-(void) sendPostRequestWithData:(NSString *)postString sendPostRequestTo:(NSString *)fileName postCustomCommand:(IteratorBlock)iteratorBlock{
    //create translucent overlay
    UIView *overlay = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [overlay setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3]];
    
    //create a moving spinner and add it to the overlay
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [spinner startAnimating];
    [overlay addSubview:spinner];
    
    //position spinner in the center of the overlay and animate the appearance of the overlay
    spinner.center = CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0);
    
    //add spinner to overlay
    [UIView animateWithDuration:0.5
                     animations:^{
                         [self.view addSubview:overlay];
                         overlay.alpha = 1.0;
                     }
     ];
    
    //wait for 0.3 seconds before sending post request for aesthetic reasons - overlay and spinner shown for > 0.3 seconds
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^ {
        //send a post request
        //code adapted from http://codewithchris.com/tutorial-how-to-use-ios-nsurlconnection-by-example/
        
        //create and format post request to be send to api server
        NSData *postData = [postString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%lu" , (unsigned long)[postData length]];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", apiUrl, fileName]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:url];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        [request setTimeoutInterval:5.0];
        
        //Send Post Request
        NSURLSession *session = [NSURLSession sharedSession];
        [[session dataTaskWithRequest:request
                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                        
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            [spinner stopAnimating];
                            [overlay removeFromSuperview];
                        }];
                        
                        if(error){
                            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                [self showAlertWithMessage:@"Server Error"];
                            }];
                            return;
                        }
                        
                        NSError *JSONerror = nil;
                        id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:&JSONerror];
                        
                        if(JSONerror){
                            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                [self showAlertWithMessage:@"Server Error"];
                            }];
                            return;
                        }
                        
                        //run custom commands through block on post results
                        iteratorBlock(object);
                    }]
         resume];
    });
}

@end
