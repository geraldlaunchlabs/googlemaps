//
//  ProfileFBViewController.m
//  gMaps
//
//  Created by LLDM on 09/08/2016.
//  Copyright © 2016 LLDM. All rights reserved.
//

#import "ProfileFBViewController.h"

@interface ProfileFBViewController (){
    
}

@end

@implementation ProfileFBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:59.0/255.0 green:89.0/255.0 blue:152.0/255.0 alpha:1.0];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    self.profName.adjustsFontSizeToFitWidth = YES;
    self.profPic.profileID=@"me";
    
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]initWithGraphPath:@"/me"
                                                                  parameters:@{ @"fields": @"name,cover",}
                                                                  HTTPMethod:@"GET"];
    
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        // Insert your code here
        NSDictionary *pictureData  = result[@"cover"];
        NSURL *strUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[pictureData valueForKey:@"source"]]];
        NSData *data = [NSData dataWithContentsOfURL:strUrl];
        UIImage *img = [UIImage imageWithData:data];
        self.coverPhoto.image = img;
        [self.scroll setContentOffset:CGPointMake(0,self.view.frame.size.width/10) animated:YES];
        self.profName.text = result[@"name"];
    }];
    
    
//    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
//                                  initWithGraphPath:[NSString stringWithFormat:@"/me?fields=cover"]
//                                  parameters:nil
//                                  HTTPMethod:@"GET"];
//    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,id result,NSError *error){
//         NSDictionary *pictureData  = result[@"picture"];
//         
//         NSDictionary *redata = pictureData[@"data"];
//         
//         NSURL *strUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@",redata[@"url"]]];
//         
//         NSData *data = [NSData dataWithContentsOfURL:strUrl];
//         UIImage *img = [[UIImage alloc] initWithData:data];
//         self.coverPhoto = [[UIImageView alloc] initWithImage:img];
//         
//     }];
    
    
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [self.scroll setContentOffset:CGPointMake(0,self.view.frame.size.width/10) animated:YES];
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
