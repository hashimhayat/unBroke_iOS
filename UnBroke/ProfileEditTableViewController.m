//
//  ProfileEditTableViewController.m
//  UnBroke
//
//  Created by Shuaib Jewon on 12/5/16.
//  Copyright © 2016 nyu.edu. All rights reserved.
//

#import "ProfileEditTableViewController.h"
#import "TypicalTableViewCell.h"
#import "profilePictureCell.h"

@interface ProfileEditTableViewController ()

@end

extern NSString *apiUrl;
extern NSInteger userID;

@implementation ProfileEditTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //set background for table view
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background"]];
    [tempImageView setFrame:self.tableView.frame];
    self.tableView.backgroundView = tempImageView;
    
    self.identifiers = @[@"First Name", @"Last Name", @"Age", @"Occupation", @"Bio"];
    self.defaultVal =  @[@"", @"", @"", @"", @""];
    
    [self loadDataFromServer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0)
        return 150.0f;
    
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"changepp"];
        if(cell == nil)
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier: @"changepp"];
        return cell;
        
    } else if (indexPath.row == 6){
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
        cell.value.tag = indexPath.row-1;
        return cell;
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 0){
        _picker = [[UIImagePickerController alloc] init];
        _picker.delegate = self;
        _picker.allowsEditing = YES;
        _picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:_picker animated:YES completion:NULL];     }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    //self.imageView.image = chosenImage;
    [_picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [_picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"save"]){
        NSString *fname,*lname,*age,*occupation,*bio;
        NSData *profilePic;
        for (NSInteger i = 0; i < [self.tableView numberOfRowsInSection:0]; i++){
            if(i == 0){
                profilePictureCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                //profilePic = UIImagePNGRepresentation(cell.image);
            } else if (i == 1){
                TypicalTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                fname = cell.value.text;
            } else if (i == 2){
                TypicalTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                lname = cell.value.text;
            } else if (i == 3){
                TypicalTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                age = cell.value.text;
            } else if (i == 4){
                TypicalTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                occupation = cell.value.text;
            } else if (i == 5){
                TypicalTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                bio = cell.value.text;
            }
        }
        
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
            NSString *post = [NSString stringWithFormat:@"user_id=%ld&fname=%@&lname=%@&age=%@&occupation=%@&bio=%@&image=%@",
                              userID,fname,lname,age,occupation,bio, profilePic];
            NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
            NSString *postLength = [NSString stringWithFormat:@"%lu" , (unsigned long)[postData length]];
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/update_user_info.php", apiUrl]];
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
                            [spinner stopAnimating];
                            [overlay removeFromSuperview];
                        }]
             resume];
        });
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
    [UIView animateWithDuration:0.5
                     animations:^{overlay.alpha = 1.0;}
                     completion:^(BOOL finished){ [overlay addSubview:spinner]; }];
    [self.view addSubview:overlay];
    [spinner startAnimating];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^ {
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
                                    //NSLog(@"%@",results);
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
                                                cell.value.text = [seperatedName objectAtIndex:1];
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


@end

