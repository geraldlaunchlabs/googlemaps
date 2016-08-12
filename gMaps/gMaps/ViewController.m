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
#import <CoreData/CoreData.h>

//#import "UIViewController+JASidePanel.h"

@interface ViewController ()
@property (strong) NSMutableArray *places;
@end


@implementation ViewController {
    GMSPlacesClient *_placesClient;
    GMSPlacePicker *_placePicker;
}


- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:72.0/255.0 green:133.0/255.0 blue:237.0/255.0 alpha:1.0];
    self.navigationController.navigationBar.translucent = NO;
    
    _placesClient = [GMSPlacesClient sharedClient];
    
    self.menu.target = self.revealViewController;
    self.menu.action = @selector(revealToggle:);
    [self.view addGestureRecognizer:(self.revealViewController.panGestureRecognizer)];
    
    self.GMS.delegate = self;
    self.GMS.myLocationEnabled = YES;
    self.GMS.mapType = kGMSTypeNormal;
    self.GMS.settings.compassButton = YES;
    self.GMS.settings.myLocationButton = YES;
    
    if(self.search)[self searchPlace];
    
    [self placeMarkers];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)placeMarkers {
    int i;
    double lat,lon;
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Places"];
    self.places= [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    NSLog(@"count places: %d",(int)self.places.count);
    for(i=0;i<(int)self.places.count;i++){
        lat = [[[self.places objectAtIndex:i] valueForKey: @"latitude"] doubleValue];
        lon = [[[self.places objectAtIndex:i] valueForKey: @"longitude"] doubleValue];
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:lat
                                                                longitude:lon
                                                                     zoom:6];
        [self.GMS setCamera:camera];
        
        GMSMarker *marker = [[GMSMarker alloc] init];
        //marker.appearAnimation = kGMSMarkerAnimationPop;
        marker.position = CLLocationCoordinate2DMake(lat,lon);
        marker.title = [[self.places objectAtIndex:i] valueForKey: @"name"];
        marker.snippet = [[self.places objectAtIndex:i] valueForKey: @"address"];
        marker.map = self.GMS;
    }
}


- (void)searchPlace {
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
            [self addPlace:place];
            [self placeMarkers];
        } else {
            NSLog(@"No Place Selected");
        }
    }];
}

- (IBAction)add:(id)sender {
    [self searchPlace];
}


- (void)addPlace:(GMSPlace*) place {
    NSManagedObjectContext *context = [self managedObjectContext];
    
    // Create a new managed object
    NSManagedObject *newPlace = [NSEntityDescription insertNewObjectForEntityForName:@"Places" inManagedObjectContext:context];
    
    [newPlace setValue:place.name forKey:@"name"];
    [newPlace setValue:[[place.formattedAddress componentsSeparatedByString:@", "]componentsJoinedByString:@"\n"] forKey:@"address"];
    [newPlace setValue:[NSNumber numberWithDouble:place.coordinate.latitude] forKey:@"latitude"];
    [newPlace setValue:[NSNumber numberWithDouble:place.coordinate.longitude] forKey:@"longitude"];
    
    NSError *error = nil;
    
    // Save the object to persistent store
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"refresh"]) {
        NSManagedObjectContext *context = [self managedObjectContext];
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Places"];
        [fetchRequest setIncludesPropertyValues:NO];
        
        NSError *error;
        NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
        
        for (NSManagedObject *object in fetchedObjects)
        {
            [context deleteObject:object];
        }
        
        error = nil;
        [context save:&error];
    }
}

@end
