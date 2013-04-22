//
//  FJSecondViewController.h
//  FlagJack
//
//  Created by Ian Guerin on 4/2/13.
//  Copyright (c) 2013 Guerin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "FJGlobalData.h"
#import <CoreLocation/CoreLocation.h>

@interface FJMapViewController : UIViewController

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
//@property (strong, nonatomic) CLLocationManager *locationManager;

- (IBAction)refreshMap:(id)sender;
- (IBAction)whereAmI:(id)sender;

- (void) centerOnMe;

@end