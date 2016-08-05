//
//  ViewController.m
//  gMaps
//
//  Created by LLDM on 04/08/2016.
//  Copyright © 2016 LLDM. All rights reserved.
//

#import "ViewController.h"
#import "SWRevealViewController.h"

//#import "UIViewController+JASidePanel.h"

@interface ViewController ()

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *scrollHeight;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[self.sidePanelController showCenterPanelAnimated:YES];
    
    
//    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:10.3157
//                                                            longitude:123.8854
//                                                                 zoom:6];
//    
//    GMSMapView *mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
//    mapView.myLocationEnabled = YES;
//    self.view = mapView;
//    
//    // Creates a marker in the center of the map.
//    GMSMarker *marker = [[GMSMarker alloc] init];
//    marker.position = CLLocationCoordinate2DMake(10.3157,123.8854);
//    marker.title = @"Cebu";
//    marker.snippet = @"Philippines";
//    marker.map = mapView;
    
    _menu.target = self.revealViewController;
    _menu.action = @selector(revealToggle:);
    [self.view addGestureRecognizer:(self.revealViewController.panGestureRecognizer)];
    
    self.GMS.delegate = self;
    self.GMS.myLocationEnabled = YES;
    self.GMS.mapType = kGMSTypeNormal;
    self.GMS.settings.compassButton = YES;
    self.GMS.settings.myLocationButton = YES;
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
