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

//@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
//
//- (void)initializeCoreData;
//
//@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

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
    
    //[self initializeCoreData];
    
    //[self initializeFetchedResultsController];

    // Do any additional setup after loading the view, typically from a nib.
    
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
        marker.title = [[self.places objectAtIndex:0] valueForKey: @"name"];
        marker.snippet = [[self.places objectAtIndex:0] valueForKey: @"address"];
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




//- (id)init
//{
//    self = [super init];
//    if (!self) return nil;
//    
//    [self initializeCoreData];
//    
//    return self;
//}
//
//- (void)initializeCoreData
//{
//    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
//    NSManagedObjectModel *mom = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
//    NSAssert(mom != nil, @"Error initializing Managed Object Model");
//    
//    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
//    NSManagedObjectContext *moc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
//    [moc setPersistentStoreCoordinator:psc];
//    [self setManagedObjectContext:moc];
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    NSURL *documentsURL = [[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
//    NSURL *storeURL = [documentsURL URLByAppendingPathComponent:@"DataModel.sqlite"];
//    
//    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
//        NSError *error = nil;
//        NSPersistentStoreCoordinator *psc = [[self managedObjectContext] persistentStoreCoordinator];
//        NSPersistentStore *store = [psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error];
//        NSAssert(store != nil, @"Error initializing PSC: %@\n%@", [error localizedDescription], [error userInfo]);
//    });
//}
//
//- (void)initializeFetchedResultsController
//{
//    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Places"];
//    
//    NSSortDescriptor *index = [NSSortDescriptor sortDescriptorWithKey:@"index" ascending:YES];
//    
//    [request setSortDescriptors:@[index]];
//    
//    NSManagedObjectContext *moc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
//    //Retrieve the main queue NSManagedObjectContext
//    
//    [self setFetchedResultsController:[[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:moc sectionNameKeyPath:nil cacheName:nil]];
//    self.fetchedResultsController.delegate = (id)self;
//    
//    NSError *error = nil;
//    if (![[self fetchedResultsController] performFetch:&error]) {
//        NSLog(@"Failed to initialize FetchedResultsController: %@\n%@", [error localizedDescription], [error userInfo]);
//        abort();
//    }
//}

@end
