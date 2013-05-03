//
//  FJMapViewController.h
//  FlagJack
//
//  Created by Ian Guerin on 4/2/13.
//  Copyright (c) 2013 Guerin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "FJGlobalData.h"
#import <CoreLocation/CoreLocation.h>
#import "AFHTTPClient.h"
#import "FJFlagAnnotation.h"
#import "FJTeammateAnnotation.h"

@interface FJMapViewController : UIViewController

extern int ENEMY_RADIUS;
extern int FLAG_RADIUS;

@property (nonatomic, retain) NSMutableDictionary *teammates;
@property (nonatomic) NSMutableDictionary *enemies;
@property (nonatomic, retain) NSMutableDictionary *flags;


@property (strong, nonatomic) IBOutlet MKMapView *mapView;
//@property (strong, nonatomic) CLLocationManager *locationManager;

- (IBAction)refreshMap:(id)sender;
- (IBAction)whereAmI:(id)sender;

- (void)centerOnMe;

- (void)plotTeammates;
- (void)plotFlags;

- (void)getTeammates;
- (void)getFlags;
- (void)getEnemies;

@end