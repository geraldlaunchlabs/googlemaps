//
//  SearchView.m
//  gMaps
//
//  Created by LLDM on 11/08/2016.
//  Copyright © 2016 LLDM. All rights reserved.
//

#import "SearchView.h"

@interface SearchView ()

@end

@implementation SearchView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    TWTRAPIClient *client = [[TWTRAPIClient alloc] init];
    self.dataSource = [[TWTRUserTimelineDataSource alloc] initWithScreenName:self.search APIClient:client];
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
