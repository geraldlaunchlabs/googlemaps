//
//  ProfileTwitViewController.m
//  gMaps
//
//  Created by LLDM on 11/08/2016.
//  Copyright © 2016 LLDM. All rights reserved.
//

#import "ProfileTwitViewController.h"

@interface ProfileTwitViewController (){
    SearchView *sv;
}

@end

@implementation ProfileTwitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.0/255.0 green:172.0/255.0 blue:237.0/255.0 alpha:1.0];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    searchThis.delegate = self;
    sv = self.childViewControllers[0];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)search:(id)sender {
    [sv searchTweets:searchThis.text];
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if(searchThis.text.length != 0 && ![[searchThis.text substringWithRange:NSMakeRange(0,1)] isEqual:@"#"]){
        searchThis.text = [NSString stringWithFormat:@"#%@",searchThis.text];
    }
    [sv searchTweets:searchThis.text];
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
