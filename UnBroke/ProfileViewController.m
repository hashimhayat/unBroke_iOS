//
//  ProfileViewController.m
//  UnBroke
//
//  Created by Shuaib Jewon on 11/30/16.
//  Copyright © 2016 nyu.edu. All rights reserved.
//
#import "profilePictureCell.h"
#import "TypicalTableViewCell.h"
#import "ProfileViewController.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

extern NSString *apiUrl;
extern NSInteger userID;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.identifiers = @[@"First Name", @"Last Name", @"Age", @"Occupation", @"Bio", @"Email", @"Password"];
    self.defaultVal =  @[@"", @"", @"", @"", @"", @"", @""];
    [self loadDataFromServer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 9;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0)
        return 150.0f;
    
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row == 0){
        profilePictureCell *cell = [tableView dequeueReusableCellWithIdentifier:@"profilepic"];
        if(cell == nil)
            cell = [[profilePictureCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier: @"profilepic"];
        //cell.image.image = set image here
        return cell;
        
    } else if (indexPath.row == 8){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"logoff"];
        if(cell == nil)
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier: @"logoff"];
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

-(void)loadDataFromServer{
    //create overlay
    UIView *overlay = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [overlay setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3]];
    
    //create spinner and set its position to center
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    spinner.center = CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0);
    
    //add spinner to overlay and add overlay to view + start animating
    [UIView animateWithDuration:0.2
                     animations:^{overlay.alpha = 1.0;}
                     completion:^(BOOL finished){ [overlay addSubview:spinner]; }];
    [self.view addSubview:overlay];
    [spinner startAnimating];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^ {
        //adapted from http://codewithchris.com/tutorial-how-to-use-ios-nsurlconnection-by-example/
        NSString *post = [NSString stringWithFormat:@"user_id=%ld",userID];
        NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%lu" , (unsigned long)[postData length]];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/get_info.php", apiUrl]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:url];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        [request setTimeoutInterval:10.0];
        NSURLSession *session = [NSURLSession sharedSession];
        
        [[session dataTaskWithRequest:request
                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                        if(!error){
                            NSError *JSONerror = nil;
                            id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:&JSONerror];
                            
                            if(!JSONerror){
                                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                    NSDictionary *results = object;
                                    NSLog(@"%@",results);
                                    for (NSInteger i = 0; i < [self.tableView numberOfRowsInSection:0]; i++){
                                        if(i == 0){
                                            profilePictureCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                                            //cell.image.image;
                                        } else if (i == 1){
                                            TypicalTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                                            NSString *name = [results valueForKey:@"fullname"];
                                            NSArray *seperatedName = [name componentsSeparatedByString:@" "];
                                            if(seperatedName.count > 1)
                                                cell.value.text = [seperatedName objectAtIndex:0];
                                            else
                                                cell.value.text = [results valueForKey:@"fullname"];
                                        } else if (i == 2){
                                            TypicalTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                                            NSString *name = [results valueForKey:@"fullname"];
                                            NSArray *seperatedName = [name componentsSeparatedByString:@" "];
                                            if(seperatedName.count > 1)
                                                cell.value.text = [seperatedName objectAtIndex:seperatedName.count-1];
                                            else
                                                cell.value.text = @"";
                                        } else if (i == 3){
                                            TypicalTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                                            cell.value.text = [results valueForKey:@"age"];
                                        } else if (i == 4){
                                            TypicalTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                                            cell.value.text = [results valueForKey:@"occupation"];
                                        } else if (i == 5){
                                            TypicalTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                                            cell.value.text = [results valueForKey:@"bio"];
                                        } else if (i == 6){
                                            TypicalTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                                            cell.value.text = [results valueForKey:@"email"];
                                        } else if (i == 7){
                                            TypicalTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                                            cell.value.text = @"******";
                                        }
                                    }
                                    
                                    [spinner stopAnimating];
                                    [overlay removeFromSuperview];
                                }];
                            }
                        }
                    }]
         resume];
    });

}

-(IBAction)goBackToProfile:(UIStoryboardSegue *)segue {
    
}

-(IBAction)saveAndGoBackToProfile:(UIStoryboardSegue *)segue {
    [self loadDataFromServer];
}

- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInfo{
    // Dismiss the image selection, hide the picker and
    
    //show the image view with the picked image
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    //UIImage *newImage = image;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}

@end
