//
//  ApplicantNameTableViewCell.m
//  UnBroke
//
//  Created by Shuaib Jewon on 12/12/16.
//  Copyright © 2016 nyu.edu. All rights reserved.
//

#import "ApplicantNameTableViewCell.h"

@import Firebase;

@implementation ApplicantNameTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _ref = [[FIRDatabase database] reference];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)accept:(id)sender {
    FIRUser *user = [FIRAuth auth].currentUser;
    FIRDatabaseReference *jobRef = [[_ref child:@"jobs"] child:_jobID];
    FIRDatabaseReference *convoRef = [[_ref child:@"conversations"] childByAutoId];
    
    [jobRef observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        [jobRef updateChildValues:@{@"matched": @"yes"}];
        [jobRef updateChildValues:@{@"matchedUserID": _userID}];
    }];
    
    NSDictionary *convo = @{
                          @"applicant" : _userID,
                          @"creator" : user.uid,
                          @"applicantName" : _applicantName.text,
                          @"creatorName" : _creatorName,
                          @"messages" : @{},
                          @"jobID" : _jobID,
                          @"jobName" : _jobName,
                          };
    
    [convoRef setValue:convo];
}

- (IBAction)reject:(id)sender {
    FIRDatabaseReference *jobRef = [[_ref child:@"jobs"] child:_jobID];
    FIRDatabaseReference *applicantRef = [jobRef child:@"applicants"];
    
    [applicantRef observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSMutableArray *applicants = snapshot.value;
        [applicants removeObject:_userID];
        [jobRef updateChildValues:@{@"applicants": applicants}];
    }];
}

@end
