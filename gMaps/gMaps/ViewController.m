//
//  ViewController.m
//  gMaps
//
//  Created by LLDM on 04/08/2016.
//  Copyright © 2016 LLDM. All rights reserved.
//

#import "ViewController.h"
#import "SWRevealViewController.h"
@import GooglePlaces;
@import GooglePlacePicker;

//#import "UIViewController+JASidePanel.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *scrollHeight;

@end

@implementation ViewController {
    GMSPlacesClient *_placesClient;
    GMSPlacePicker *_placePicker;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _placesClient = [GMSPlacesClient sharedClient];
    
    self.menu.target = self.revealViewController;
    self.menu.action = @selector(revealToggle:);
    [self.view addGestureRecognizer:(self.revealViewController.panGestureRecognizer)];
    
    self.GMS.delegate = self;
    self.GMS.myLocationEnabled = YES;
    self.GMS.mapType = kGMSTypeNormal;
    self.GMS.settings.compassButton = YES;
    self.GMS.settings.myLocationButton = YES;
    
    
    if([_search isEqual: @"YES"]) {
        CLLocationCoordinate2D center = CLLocationCoordinate2DMake(10.353272,123.949814);
        CLLocationCoordinate2D northEast = CLLocationCoordinate2DMake(center.latitude + 0.001,
                                                                      center.longitude + 0.001);
        CLLocationCoordinate2D southWest = CLLocationCoordinate2DMake(center.latitude - 0.001,
                                                                      center.longitude - 0.001);
        GMSCoordinateBounds *viewport = [[GMSCoordinateBounds alloc] initWithCoordinate:northEast
                                                                             coordinate:southWest];
        GMSPlacePickerConfig *config = [[GMSPlacePickerConfig alloc] initWithViewport:viewport];
        _placePicker = [[GMSPlacePicker alloc] initWithConfig:config];
        
        [_placePicker pickPlaceWithCallback:^(GMSPlace *place, NSError *error) {
            if (error != nil) {
                NSLog(@"Pick Place error %@", [error localizedDescription]);
                return;
            }
            if (place != nil) {
                GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:place.coordinate.latitude
                                                                        longitude:place.coordinate.longitude
                                                                             zoom:6];
                [self.GMS setCamera:camera];
                
                GMSMarker *marker = [[GMSMarker alloc] init];
                marker.position = CLLocationCoordinate2DMake(place.coordinate.latitude,place.coordinate.longitude);
                marker.title = @"Cebu";
                marker.snippet = @"Philippines";
                marker.map = self.GMS;
            } else {
                self.nameLabel.text = @"No place selected";
                self.addressLabel.text = @"";
            }
        }];
        
    }

    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
