//
//  JobsPostViewController.h
//  UnBroke
//
//  Created by Shuaib Jewon on 11/29/16.
//  Copyright © 2016 nyu.edu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JobsPostViewController : UITableViewController <UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITableView *jobNameTextField;
@property (strong, nonatomic) IBOutlet UISlider *sliderMinDistance;
@property (strong, nonatomic) IBOutlet UITextField *sliderMinDistanceField;
@property (strong, nonatomic) IBOutlet UISlider *sliderMaxDistance;
@property (strong, nonatomic) IBOutlet UITextField *sliderMaxDistanceField;
@property (strong, nonatomic) IBOutlet UITextField *descriptionField;
@property (strong, nonatomic) IBOutlet UITextView *descriptionFieldEdit;
@property (strong, nonatomic) IBOutlet UITextField *subCategoryPickerText;
@property (strong, nonatomic) IBOutlet UIPickerView *subCategoryPicker;
@property (strong, nonatomic) IBOutlet UIPickerView *categoryPicker;
@property (strong, nonatomic) IBOutlet UITextField *categoryPickerText;
@property (strong, nonatomic) IBOutlet UITextField *salaryTypeText;
@property (strong, nonatomic) IBOutlet UIPickerView *salaryTypePicker;
@property (strong, nonatomic) IBOutlet UITextField *salaryText;

@property (strong, nonatomic) UITextField *activeField;

@end
