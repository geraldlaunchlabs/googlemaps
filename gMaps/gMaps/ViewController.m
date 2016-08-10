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

@property (strong) NSManagedObjectContext *managedObjectContext;

- (void)initializeCoreData;

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end

@implementation ViewController {
    GMSPlacesClient *_placesClient;
    GMSPlacePicker *_placePicker;
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
    
    //[self initializeCoreData];
    
    //[self initializeFetchedResultsController];

    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
            GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:place.coordinate.latitude
                                                                    longitude:place.coordinate.longitude
                                                                         zoom:6];
            [self.GMS setCamera:camera];
            
            GMSMarker *marker = [[GMSMarker alloc] init];
            //marker.appearAnimation = kGMSMarkerAnimationPop;
            marker.position = CLLocationCoordinate2DMake(place.coordinate.latitude,place.coordinate.longitude);
            marker.title = place.name;
            marker.snippet = [[place.formattedAddress componentsSeparatedByString:@", "]componentsJoinedByString:@"\n"];
            marker.map = self.GMS;
        } else {
            NSLog(@"No Place Selected");
        }
    }];
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




- (id)init
{
    self = [super init];
    if (!self) return nil;
    
    [self initializeCoreData];
    
    return self;
}

- (void)initializeCoreData
{
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
    NSManagedObjectModel *mom = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    NSAssert(mom != nil, @"Error initializing Managed Object Model");
    
    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
    NSManagedObjectContext *moc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [moc setPersistentStoreCoordinator:psc];
    [self setManagedObjectContext:moc];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *documentsURL = [[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL *storeURL = [documentsURL URLByAppendingPathComponent:@"DataModel.sqlite"];
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        NSError *error = nil;
        NSPersistentStoreCoordinator *psc = [[self managedObjectContext] persistentStoreCoordinator];
        NSPersistentStore *store = [psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error];
        NSAssert(store != nil, @"Error initializing PSC: %@\n%@", [error localizedDescription], [error userInfo]);
    });
}

- (void)initializeFetchedResultsController
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Places"];
    
    NSSortDescriptor *index = [NSSortDescriptor sortDescriptorWithKey:@"index" ascending:YES];
    
    [request setSortDescriptors:@[index]];
    
    NSManagedObjectContext *moc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    //Retrieve the main queue NSManagedObjectContext
    
    [self setFetchedResultsController:[[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:moc sectionNameKeyPath:nil cacheName:nil]];
    self.fetchedResultsController.delegate = (id)self;
    
    NSError *error = nil;
    if (![[self fetchedResultsController] performFetch:&error]) {
        NSLog(@"Failed to initialize FetchedResultsController: %@\n%@", [error localizedDescription], [error userInfo]);
        abort();
    }
}

@end
