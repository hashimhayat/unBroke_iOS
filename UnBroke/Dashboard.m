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

typedef void (^ IteratorBlock)(id object);

extern NSInteger userID;
extern NSString *apiUrl;
extern NSInteger cornerRadius;

@implementation Dashboard

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(deviceOrientationDidChangeNotification:)
     name:UIDeviceOrientationDidChangeNotification
     object:nil];
    
    // Do any additional setup after loading the view.
    _notificationsTbl.layer.cornerRadius = cornerRadius;
    _postingsTbl.layer.cornerRadius = cornerRadius;
    _updatesTbl.layer.cornerRadius = cornerRadius;
    
    //set size of tableview to content size
    dispatch_async(dispatch_get_main_queue(), ^{
        //[self loadNotif];
        //[self loadPostings];
        _updates = [[NSMutableArray alloc] init];
        //[self loadUpdates];
        
        [self setDimensions];
    });
}

- (void)deviceOrientationDidChangeNotification:(NSNotification*)note{
//    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
//    switch (orientation){
//        case UIDeviceOrientationLandscapeLeft:
//            break;
//        case UIDeviceOrientationLandscapeRight:
//            break;
//        default:
//            break;
//    }
    
    [self setDimensions];
    [self.view setNeedsDisplay];
}

//to allow for scrolling
- (void) setDimensions {
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) loadNotif{
    [self sendPostRequestWithData:[NSString stringWithFormat:@"user_id=%ld",userID]
                sendPostRequestTo:@"notifications.php"
                       isAnimated:YES
                postCustomCommand:^(id object){
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        for (id o in object){
                            NSDictionary *entry = o;
                            if(entry != nil){
                                entry = [entry objectForKey:0];
                                NSString *percentage = [entry objectForKey:@"percentage"];
                                if([percentage isEqualToString:@"100"]){
                                    // do stuff here
                                }
                                    
                            }
                        }
                    }];
                }];
}

- (void) loadPostings{
    [self sendPostRequestWithData:[NSString stringWithFormat:@"user_id=%ld",userID]
                sendPostRequestTo:@"recent_jobs_dash.php"
                       isAnimated:YES
                postCustomCommand:^(id object){
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        if([object count] > 0){
                            NSDictionary *entry = [object objectAtIndex:0];
                            if(entry != nil){
                                _entryOneImageCat = [entry objectForKey:@"category"];
                                _entryOneData = [entry objectForKey:@"title"];
                            }
                        }
                        
                        if([object count] > 1){
                            NSDictionary *entry = [object objectAtIndex:1];
                            if(entry != nil){
                                _entryTwoImageCat = [entry objectForKey:@"category"];
                                _entryTwoData = [entry objectForKey:@"title"];
                            }
                        }
                        
                        if([object count] > 2){
                            NSDictionary *entry = [object objectAtIndex:2];
                            if(entry != nil){
                                _entryThreeImageCat = [entry objectForKey:@"category"];
                                _entryThreeData = [entry objectForKey:@"title"];
                            }
                        }
                    }];
                }];
}

-(void) loadUpdates{
    [self sendPostRequestWithData:[NSString stringWithFormat:@"user_id=%ld",userID]
                sendPostRequestTo:@"recent_jobs_dash.php"
                       isAnimated:YES
                postCustomCommand:^(id object){
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        if([object count] > 0){
                            NSDictionary *entry = [object objectAtIndex:0];
                            if(entry != nil){
                                _entryOneImageCat = [entry objectForKey:@"category"];
                                _entryOneData = [entry objectForKey:@"title"];
                            }
                        }
                        
                        if([object count] > 1){
                            NSDictionary *entry = [object objectAtIndex:1];
                            if(entry != nil){
                                _entryTwoImageCat = [entry objectForKey:@"category"];
                                _entryTwoData = [entry objectForKey:@"title"];
                            }
                        }
                        
                        if([object count] > 2){
                            NSDictionary *entry = [object objectAtIndex:2];
                            if(entry != nil){
                                _entryThreeImageCat = [entry objectForKey:@"category"];
                                _entryThreeData = [entry objectForKey:@"title"];
                            }
                        }
                    }];
                }];
}

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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView.tag == 1){
        //notifications
        [self.tabBarController setSelectedIndex:4];
    } else if(tableView.tag == 2){
        //postings
        [self.tabBarController setSelectedIndex:2];
    } else if(tableView.tag == 3){
        //job updates
        [self.tabBarController setSelectedIndex:1];
    }
}

-(NSString *) getCategoryImageName:(NSString *)category {
    NSString *retVal = @"other";
    
    if([category isEqualToString:@"Airline"]){
        retVal = @"airline";
    }
    
    if([category isEqualToString:@"Arts"]){
        retVal = @"art";
    }
    
    if([category isEqualToString:@"Business"]){
        retVal = @"business";
    }
    
    if([category isEqualToString:@"Law Enforcement"]){
        retVal = @"legal";
    }
    
    if([category isEqualToString:@"Media"]){
        retVal = @"media";
    }
    
    if([category isEqualToString:@"Medical"]){
        retVal = @"medical";
    }
    
    if([category isEqualToString:@"Technology"]){
        retVal = @"tech";
    }
    
    if([category isEqualToString:@"Service Industry"]){
        retVal = @"service";
    }
    
    if([category isEqualToString:@"Teaching"]){
        retVal = @"teaching";
    }
    
    return retVal;
}

/*
 *
 * Custom helpers
 *
 */

//Animates and shows a custom alert message
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

//Animates and sends a post request with the options of setting a block of stuff to do after response received
-(void) sendPostRequestWithData:(NSString *)postString sendPostRequestTo:(NSString *)fileName isAnimated:(Boolean)animated postCustomCommand:(IteratorBlock)iteratorBlock{
    
    //create translucent overlay
    UIView *overlay = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [overlay setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3]];
    
    //create a moving spinner and add it to the overlay
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    
    //position spinner in the center of the overlay and animate the appearance of the overlay
    spinner.center = CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0);
    
    if(animated){
        [spinner startAnimating];
        [overlay addSubview:spinner];
        
        //add overlay to view
        [UIView animateWithDuration:0.5
                         animations:^{
                             [self.view addSubview:overlay];
                             overlay.alpha = 1.0;
                         }
         ];
    }
    
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
                            if(animated){
                                [spinner stopAnimating];
                                [overlay removeFromSuperview];
                            }
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
