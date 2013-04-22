//
//  FJSecondViewController.m
//  FlagJack
//
//  Created by Ian Guerin on 4/2/13.
//  Copyright (c) 2013 Guerin. All rights reserved.
//

#import "FJMapViewController.h"
#import "FJFlagAnnotation.h"
#import "FJTeammateAnnotation.h"

@interface FJMapViewController ()

@property (nonatomic, strong) NSMutableArray *mapTeammateAnnotations;


@end

@implementation FJMapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    _mapView.showsUserLocation = YES;
    [self centerOnMe];
    
}

- (void)plotFlags {
    
    //flags
	CLLocationCoordinate2D blueCoord;
    blueCoord.latitude = 48.8789;
    blueCoord.longitude = -113.4598;
	NSString* blueTitle = @"Blue Flag";
	NSString* blueSubtitle = @"flag is hidden here";
	
	FJFlagAnnotation* blueFlag = [[FJFlagAnnotation alloc] initWithCoordinate:blueCoord andTitle:blueTitle andSubtitle: blueSubtitle];
	//[_mapView addAnnotation: blueFlag];
	
	CLLocationCoordinate2D orangeCoord;
    orangeCoord.latitude = 43.8789;
    orangeCoord.longitude = -103.4598;
	NSString* orangeTitle = @"Orange Flag";
	NSString* orangeSubtitle = @"flag is hidden here";
	
	FJFlagAnnotation* orangeFlag = [[FJFlagAnnotation alloc] initWithCoordinate:orangeCoord andTitle:orangeTitle andSubtitle: orangeSubtitle];
	//[_mapView addAnnotation: orangeFlag];
    
    //TODO: get flag info from db into ;
    NSMutableDictionary *flags = [NSMutableDictionary dictionary];
    [flags setObject: blueFlag forKey: blueFlag.title];
    [flags setObject: orangeFlag forKey: orangeFlag.title];
    
    for(id key in flags) {
        [_mapView addAnnotation:[flags objectForKey:key]];
    }
        
}

- (void)plotTeammates {

    CLLocationCoordinate2D teammate1;
    teammate1.latitude = 42.8789;
    teammate1.longitude = -113.4598;
	NSString* name1 = @"Ian";
	NSString* location1 = @"Ian is here";
	
	FJTeammateAnnotation* person1 = [[FJTeammateAnnotation alloc] initWithCoordinate:teammate1 andName:name1 andLocation: location1];
	//[_mapView addAnnotation: person1];
	
	CLLocationCoordinate2D teammate2;
    teammate2.latitude = 48.8789;
    teammate2.longitude = -103.4598;
	NSString* name2 = @"Sara";
	NSString* location2 = @"Sara is here";
	
	FJTeammateAnnotation* person2 = [[FJTeammateAnnotation alloc] initWithCoordinate:teammate2 andName:name2 andLocation: location2];
	//[_mapView addAnnotation: person2];

    //TODO: get teammate info from db into nsarray
    NSMutableDictionary *teammates = [NSMutableDictionary dictionary];
    [teammates setObject: person1 forKey: person1.name];
    [teammates setObject: person2 forKey: person2.name];
     
    //TODO: enumerate through teammate array and add to map
    for (id key in teammates) {
        [_mapView addAnnotation:[teammates objectForKey:key]];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) centerOnMe{
	[_mapView setCenterCoordinate:[[[_mapView userLocation]location] coordinate]];
}

- (IBAction)refreshMap:(id)sender {
    
    //remove any existing annotations
    for (id<MKAnnotation> annotation in _mapView.annotations) {
        [_mapView removeAnnotation:annotation];
    }

    [self centerOnMe];
    [self plotFlags];
    [self plotTeammates];
}

- (IBAction)whereAmI:(id)sender {
	CLLocation* current = _mapView.userLocation.location;
	NSLog(@"%g and %g", current.coordinate.latitude, current.coordinate.longitude);
    [self centerOnMe];
}

//pragma whatever?

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
	NSLog(@"fuck yes");
	[self centerOnMe];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {    
    
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    if ([annotation isKindOfClass:[FJFlagAnnotation class]]) // for flags
    {
        // try to dequeue any existing pin view first
        static NSString *flagAnnotationIdentifier = @"flagAnnotationIdentifier";
        
        MKPinAnnotationView *pinView =
        (MKPinAnnotationView *) [self.mapView dequeueReusableAnnotationViewWithIdentifier:flagAnnotationIdentifier];
        if (pinView == nil) {
            // if an existing pin view was not available, create one
            MKPinAnnotationView *flagPinView = [[MKPinAnnotationView alloc]
                                                  initWithAnnotation:annotation reuseIdentifier:flagAnnotationIdentifier];
            flagPinView.canShowCallout = YES;
            
            if ([annotation.title isEqualToString:@"Blue Flag"]) {
                flagPinView.pinColor = MKPinAnnotationColorPurple;
            } else if ([annotation.title isEqualToString:@"Orange Flag"]){
                flagPinView.pinColor = MKPinAnnotationColorGreen;
            }
            
            return flagPinView;
        }
        else {
            pinView.annotation = annotation;
        }
        return pinView;
    }
    else if ([annotation isKindOfClass:[FJTeammateAnnotation class]]) { // for teammates
        
        static NSString *teammateAnnotationIdentifier = @"teammateAnnotationIdentifier";
        
        MKPinAnnotationView *pinView =
        (MKPinAnnotationView *) [self.mapView dequeueReusableAnnotationViewWithIdentifier:teammateAnnotationIdentifier];
        if (pinView == nil) {
            // if an existing pin view was not available, create one
            MKPinAnnotationView *teammatePinView = [[MKPinAnnotationView alloc]
                                                initWithAnnotation:annotation reuseIdentifier:teammateAnnotationIdentifier];
            teammatePinView.canShowCallout = YES;
            teammatePinView.animatesDrop = YES;
            teammatePinView.pinColor = MKPinAnnotationColorRed;
                
            return teammatePinView;
            
        } else {
            pinView.annotation = annotation;
        }
        return pinView;
    }
    
    return nil;
}

@end