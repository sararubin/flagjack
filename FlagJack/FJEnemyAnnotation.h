//
//  FJFJEnemyAnnotation.h
//  FlagJack
//
//  Created by srubin13 on 4/21/13.
//  Copyright (c) 2013 Guerin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface FJEnemyAnnotation : NSObject <MKAnnotation>

@property (nonatomic) Boolean isFrozen;

@property (nonatomic, copy) NSString *name;
@property int ident;
@property (nonatomic, copy) NSString *displayName;
@property (nonatomic, copy) NSString *location;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

- (FJEnemyAnnotation*) initWithCoordinate: (CLLocationCoordinate2D)coordinate andName: (NSString*)name andLocation: (NSString*)location andIdentifier:(int)ident;

- (void)print;


@end
