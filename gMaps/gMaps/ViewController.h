//
//  ViewController.h
//  gMaps
//
//  Created by LLDM on 04/08/2016.
//  Copyright © 2016 LLDM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
@import GooglePlaces;
@import GooglePlacePicker;

@interface ViewController : UIViewController<GMSMapViewDelegate,UIScrollViewDelegate>{
    IBOutlet UIImageView *image;
}

@property (strong, nonatomic) IBOutlet GMSMapView *GMS;
@property (weak,nonatomic) IBOutlet UIBarButtonItem * menu;
@property (nonatomic, assign) BOOL search;

@end

