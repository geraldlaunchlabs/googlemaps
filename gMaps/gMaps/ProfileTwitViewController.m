//
//  ProfileTwitViewController.m
//  gMaps
//
//  Created by LLDM on 11/08/2016.
//  Copyright © 2016 LLDM. All rights reserved.
//

#import "ProfileTwitViewController.h"

@interface ProfileTwitViewController (){
    TWTRTweetView *tweetView,*temp;
    __weak IBOutlet UIScrollView *scroll;
}

@end

@implementation ProfileTwitViewController

int m=0;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.0/255.0 green:172.0/255.0 blue:237.0/255.0 alpha:1.0];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    
    scroll.delegate = self;
    searchBar.delegate = self;
    
//    TWTRAPIClient *client = [[TWTRAPIClient alloc] init];
//    self.dataSource = [[TWTRUserTimelineDataSource alloc] initWithScreenName:@"fabric" APIClient:client];
    
    for(int i; i<30; i++)
        [self tweet:@"631879971628183552"];
    
//    // Add a button to the center of the view to show the timeline
//    UIButton *timeline = [UIButton buttonWithType:UIButtonTypeSystem];
//    [timeline setTitle:@"Show Timeline" forState:UIControlStateNormal];
//    [timeline sizeToFit];
//    [timeline addTarget:self action:@selector(showTimeline) forControlEvents:UIControlEventTouchUpInside];
//   
//    UIBarButtonItem *rightNav = [[UIBarButtonItem alloc] initWithCustomView:timeline];
//    
//    self.navigationItem.rightBarButtonItem = rightNav;
    

    
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tweet :(NSString *)tweetID {
    [[[TWTRAPIClient alloc] init] loadTweetWithID:tweetID completion:^(TWTRTweet *tweet, NSError *error) {
        if (tweet) {
            tweetView = [[TWTRTweetView alloc] initWithTweet:tweet style:TWTRTweetViewStyleRegular];
            tweetView.center = CGPointMake(self.view.center.x,temp.frame.size.height*m + tweetView.frame.size.height/2);
            tweetView.theme = TWTRTweetViewThemeDark;
            [scroll addSubview:tweetView];
            temp = tweetView;
            m++;
            NSLog(@">>>   %f",temp.frame.size.height*m);
            scroll.contentSize = CGSizeMake(self.view.frame.size.width,temp.frame.size.height*m);
        } else {
            NSLog(@"Tweet load error: %@", [error localizedDescription]);
        }
    }];
    
}

- (void)showTimeline {
    // Create an API client and data source to fetch Tweets for the timeline
    
    
    TWTRAPIClient *client = [[TWTRAPIClient alloc] init];
    TWTRUserTimelineDataSource *userTimelineDataSource = [[TWTRUserTimelineDataSource alloc] initWithScreenName:searchBar.text APIClient:client];
    TWTRTimelineViewController *controller = [[TWTRTimelineViewController alloc] initWithDataSource:userTimelineDataSource];
    // Create done button to dismiss the view controller
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissTimeline)];
    controller.navigationItem.leftBarButtonItem = button;
    // Create a navigation controller to hold the
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    [self showDetailViewController:navigationController sender:self];
}

- (void)dismissTimeline {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)search:(id)sender {
    //[self showTimeline];
    //((ViewController *)self.childViewControllers).search = @"olympics";
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"search"]) {
        SearchView *embed = segue.destinationViewController;
        embed.search = self.go;
    } else if ([[segue identifier] isEqualToString:@"go"]) {
        ProfileTwitViewController *vc = [segue destinationViewController];
        vc.go=searchBar.text;
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
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
