//
//  ViewController.h
//  gMaps
//
//  Created by LLDM on 04/08/2016.
//  Copyright © 2016 LLDM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>

@interface ViewController : UIViewController<GMSMapViewDelegate,UIScrollViewDelegate>{
    
}

@property (strong, nonatomic) IBOutlet GMSMapView *GMS;

@end

