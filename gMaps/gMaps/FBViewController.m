//
//  FBViewController.m
//  gMaps
//
//  Created by LLDM on 05/08/2016.
//  Copyright © 2016 LLDM. All rights reserved.
//

#import "FBViewController.h"
#import "SWRevealViewController.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface FBViewController ()

@end

@implementation FBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _fbmenu.target = self.revealViewController;
    _fbmenu.action = @selector(revealToggle:);
    [self.view addGestureRecognizer:(self.revealViewController.panGestureRecognizer)];
    
    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
    loginButton.center = self.view.center;
    [self.view addSubview:loginButton];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
