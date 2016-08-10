//
//  ProfileFBViewController.h
//  gMaps
//
//  Created by LLDM on 09/08/2016.
//  Copyright © 2016 LLDM. All rights reserved.
//

#import "ViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface ProfileFBViewController : ViewController

@property (weak, nonatomic) IBOutlet FBSDKProfilePictureView *profPic;
@property (strong, nonatomic) IBOutlet UIImageView *coverPhoto;
@property (weak, nonatomic) IBOutlet UILabel *profName;

@end
