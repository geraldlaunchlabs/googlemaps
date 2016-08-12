//
//  TwitViewController.m
//  gMaps
//
//  Created by LLDM on 10/08/2016.
//  Copyright © 2016 LLDM. All rights reserved.
//

#import "TwitViewController.h"
#import "SWRevealViewController.h"

@interface TwitViewController (){
    NSString *user;
    TWTRTweetView *tweetView,*temp;
}

@end

@implementation TwitViewController

int m=0;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.0/255.0 green:172.0/255.0 blue:237.0/255.0 alpha:1.0];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    self.twitmenu.target = self.revealViewController;
    self.twitmenu.action = @selector(revealToggle:);
    [self.view addGestureRecognizer:(self.revealViewController.panGestureRecognizer)];
    
    self.scroll.delegate = self;
    
    [[Twitter sharedInstance] logInWithCompletion:^(TWTRSession *session, NSError *error) {
        if (session) {
            NSLog(@"signed in as %@", [session userName]);
            for(int i; i<30; i++)
                [self tweet:@"631879971628183552"];
            
            user = [session userID];
            
            [[[Twitter sharedInstance] sessionStore] logOutUserID:user];
            
        } else {
            NSLog(@"Not Signed in");
            TWTRLogInButton *logInButton = [TWTRLogInButton buttonWithLogInCompletion:^(TWTRSession *session, NSError *error) {
                if (session) {
                    // Callback for login success or failure. The TWTRSession
                    // is also available on the [Twitter sharedInstance]
                    // singleton.
                    //
                    // Here we pop an alert just to give an example of how
                    // to read Twitter user info out of a TWTRSession.
                    //
                    // TODO: Remove alert and use the TWTRSession's userID
                    // with your app's user model
                    NSString *message = [NSString stringWithFormat:@"@%@ logged in! (%@)",
                                         [session userName], [session userID]];
                    
                    UIAlertController * alert = [UIAlertController
                                                 alertControllerWithTitle:@"Logged in!"
                                                 message:message
                                                 preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction* okButton = [UIAlertAction actionWithTitle:@"Ok"
                                                                       style:UIAlertActionStyleDefault
                                                                     handler:^(UIAlertAction * action) {
                                                                         //Handle your yes please button action here
                                                                     }];
                    
                    [alert addAction:okButton];
                    [self presentViewController:alert animated:YES completion:nil];
                    
                    
                } else {
                    NSLog(@"Login error: %@", [error localizedDescription]);
                }
            }];
            
            // TODO: Change where the log in button is positioned in your view
            logInButton.center = self.view.center;
            [self.view addSubview:logInButton];
            
        }
    }];
    
    TWTRSessionStore *store = [[Twitter sharedInstance] sessionStore];
    NSString *userID = store.session.userID;
    
    [store logOutUserID:userID];
    
    
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
            [self.scroll addSubview:tweetView];
            temp = tweetView;
            m++;
            self.scroll.contentSize = CGSizeMake(self.view.frame.size.width,temp.frame.size.height*m);
        } else {
            NSLog(@"Tweet load error: %@", [error localizedDescription]);
        }
    }];
    
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
