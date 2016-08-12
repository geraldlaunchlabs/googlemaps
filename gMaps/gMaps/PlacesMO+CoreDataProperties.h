//
//  PlacesMO+CoreDataProperties.h
//  gMaps
//
//  Created by LLDM on 12/08/2016.
//  Copyright © 2016 LLDM. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "PlacesMO.h"

NS_ASSUME_NONNULL_BEGIN

@interface PlacesMO (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *address;
@property (nullable, nonatomic, retain) NSNumber *index;
@property (nullable, nonatomic, retain) NSNumber *latitude;
@property (nullable, nonatomic, retain) NSNumber *longitude;
@property (nullable, nonatomic, retain) NSString *name;

@end

NS_ASSUME_NONNULL_END
