//
//  ProfileTwitViewController.h
//  gMaps
//
//  Created by LLDM on 11/08/2016.
//  Copyright © 2016 LLDM. All rights reserved.
//

#import "ViewController.h"
#import "SearchView.h"
#import <TwitterKit/TwitterKit.h>


@interface ProfileTwitViewController : ViewController {
    IBOutlet UISearchBar *searchBar;
}

@property (strong, nonatomic) IBOutlet UIView *child;

@property (weak,nonatomic) NSString *go;


@end
