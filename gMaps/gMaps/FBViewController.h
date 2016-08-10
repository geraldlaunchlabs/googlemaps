//
//  FBViewController.h
//  gMaps
//
//  Created by LLDM on 05/08/2016.
//  Copyright © 2016 LLDM. All rights reserved.
//

#import "ViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface FBViewController : ViewController

@property (weak,nonatomic) IBOutlet UIBarButtonItem * fbmenu;
@property (weak, nonatomic) IBOutlet FBSDKLoginButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *profile;

@end
