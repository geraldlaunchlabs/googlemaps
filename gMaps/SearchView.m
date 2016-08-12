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
    
    [self searchTweets:@"olympics"];
    [TWTRMoPubNativeAdContainerView appearance].theme = TWTRNativeAdThemeDark;
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)searchTweets:(NSString*) search {
//    TWTRAPIClient *client = [[TWTRAPIClient alloc] init];
//    self.dataSource = [[TWTRUserTimelineDataSource alloc] initWithScreenName:search APIClient:client];
    
    TWTRAPIClient *client = [[TWTRAPIClient alloc] init];
    self.adConfiguration = [[TWTRMoPubAdConfiguration alloc] initWithAdUnitID:TWTRMoPubSampleAdUnitID keywords:nil];
    self.dataSource = [[TWTRSearchTimelineDataSource alloc] initWithSearchQuery:search APIClient:client];
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
