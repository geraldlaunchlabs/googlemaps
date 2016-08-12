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


@interface ProfileTwitViewController : ViewController<UISearchBarDelegate> {
    IBOutlet UISearchBar *searchThis;
}
@end
