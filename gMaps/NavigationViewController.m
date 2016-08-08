//
//  NavigationViewController.m
//  gMaps
//
//  Created by LLDM on 05/08/2016.
//  Copyright © 2016 LLDM. All rights reserved.
//

#import "NavigationViewController.h"
#import "SWRevealViewController.h"
#import "FBViewController.h"
#import "ViewController.h"

@interface NavigationViewController ()

@end

@implementation NavigationViewController {
    NSArray *menu;
    NSString *cellIdentifier;
}

- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender
{
    // configure the destination view controller:
    if ( [sender isKindOfClass:[UITableViewCell class]] )
    {
        UINavigationController *navController = segue.destinationViewController;
        ViewController* vc = [navController childViewControllers].firstObject;
        if ( [vc isKindOfClass:[ViewController class]] )
        {
            vc.search = @"YES";
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    _placesClient = [GMSPlacesClient sharedClient];
    
    menu = @[@"r1",@"r2",@"r3"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [menu count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    cellIdentifier = [menu objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}

#pragma mark state preservation / restoration
- (void)encodeRestorableStateWithCoder:(NSCoder *)coder {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // TODO save what you need here
    
    [super encodeRestorableStateWithCoder:coder];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // TODO restore what you need here
    
    [super decodeRestorableStateWithCoder:coder];
}

- (void)applicationFinishedRestoringState {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // TODO call whatever function you need to visually restore
}

//- (IBAction)getCurrentPlace:(UIButton *)sender {
//    [_placesClient currentPlaceWithCallback:^(GMSPlaceLikelihoodList *placeLikelihoodList, NSError *error){
//        if (error != nil) {
//            NSLog(@"Pick Place error %@", [error localizedDescription]);
//            return;
//        }
//        
//        NSString *nameLabel =  @"No current place";
//        NSString *addressLabel = @"";
//        
//        if (placeLikelihoodList != nil) {
//            place = [[[placeLikelihoodList likelihoods] firstObject] place];
//            if (place != nil) {
//                nameLabel = place.name;
//                addressLabel = [[place.formattedAddress componentsSeparatedByString:@", "]
//                                          componentsJoinedByString:@"\n"];
//            }
//        }
//    }];
//}


@end
