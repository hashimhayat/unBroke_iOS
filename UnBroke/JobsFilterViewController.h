//
//  JobsFilterViewController.h
//  UnBroke
///Users/Shuaib/Documents/Xcode/UnBroke/UnBroke/JobsFilterViewController.h
//  Created by Shuaib Jewon on 11/29/16.
//  Copyright © 2016 nyu.edu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JobsFilterViewController : UITableViewController <UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITextField *sortByTextField;
@property (strong, nonatomic) IBOutlet UIPickerView *sortByPicker;
@property (strong, nonatomic) IBOutlet UITextField *sortInTextField;
@property (strong, nonatomic) IBOutlet UIPickerView *sortInPicker;
@property (strong, nonatomic) IBOutlet UITextField *categoryTextField;
@property (strong, nonatomic) IBOutlet UIPickerView *categoryPicker;
@property (strong, nonatomic) IBOutlet UITextField *subCategoryTextField;
@property (strong, nonatomic) IBOutlet UIPickerView *subCategoryPicker;
@property (strong, nonatomic) IBOutlet UITextField *minSalaryTextField;
@property (strong, nonatomic) IBOutlet UITextField *maxSalaryTextField;
@property (strong, nonatomic) IBOutlet UITextField *minDistanceTextField;
@property (strong, nonatomic) IBOutlet UITextField *maxDistanceTextField;
@property (strong, nonatomic) IBOutlet UISlider *sliderMinSalary;
@property (strong, nonatomic) IBOutlet UISlider *sliderMaxSalary;
@property (strong, nonatomic) IBOutlet UISlider *sliderMaxDistance;
@property (strong, nonatomic) IBOutlet UISlider *sliderMinDistance;

@property (strong, nonatomic) NSArray *cats, *subCats, *sortBy, *sortIn;
@property (nonatomic) BOOL show1, show3, show5, show7;
@property (nonatomic) NSInteger scrollSize;

@end
