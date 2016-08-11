//
//  FBViewController.m
//  gMaps
//
//  Created by LLDM on 05/08/2016.
//  Copyright © 2016 LLDM. All rights reserved.
//

#import "FBViewController.h"
#import "SWRevealViewController.h"

@interface FBViewController ()

@end

@implementation FBViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.fbmenu.target = self.revealViewController;
    self.fbmenu.action = @selector(revealToggle:);
    [self.view addGestureRecognizer:(self.revealViewController.panGestureRecognizer)];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:59.0/255.0 green:89.0/255.0 blue:152.0/255.0 alpha:1.0];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    self.loginButton.center = self.view.center;
    self.loginButton.readPermissions = @[@"public_profile", @"email", @"user_friends",@"user_photos"];
    
    self.profile.contentMode = UIViewContentModeScaleToFill;
    self.profile.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
    self.profile.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
    
    [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];
    
    [self Logged];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)Logged {
    if ([FBSDKAccessToken currentAccessToken]) {
        FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]initWithGraphPath:@"/me"
                                                                      parameters:@{ @"fields": @"picture",}
                                                                      HTTPMethod:@"GET"];
        [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
            // Insert your code here
            NSURL *strUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@",result[@"picture"][@"data"][@"url"]]];
            NSData *data = [NSData dataWithContentsOfURL:strUrl];
            UIImage *img = [UIImage imageWithData:data];
            [self.profile setBackgroundImage:img forState:UIControlStateNormal];
        }];
    } else {
        [self.profile setBackgroundImage:nil forState:UIControlStateNormal];
    }
}

//- (IBAction)btnFacebookPressed:(id)sender {
//    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
//    [login logInWithReadPermissions:@[@"email"] fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error)
//     {
//         if (error)
//         {
//             // Process error
//         }
//         else if (result.isCancelled)
//         {
//             // Handle cancellations
//         }
//         else
//         {
//             if ([result.grantedPermissions containsObject:@"email"])
//             {
//                 NSLog(@"result is:%@",result);
//                 [self fetchUserInfo];
//             }
//         }
//     }];
//}
//
//-(void)fetchUserInfo
//{
//    if ([FBSDKAccessToken currentAccessToken])
//    {
//    
//        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"id, name, link, first_name, last_name, picture.type(large), email, birthday, bio ,location ,friends ,hometown , friendlists"}]
//         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
//             if (!error)
//             {
//                 NSLog(@"resultis:%@",result);
//             }
//             else
//             {
//                 NSLog(@"Error %@",error);
//             }
//         }];
//        
//    }
//    
//}


@end
