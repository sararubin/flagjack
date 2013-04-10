//
//  FJSecondViewController.m
//  FlagJack
//
//  Created by Ian Guerin on 4/2/13.
//  Copyright (c) 2013 Guerin. All rights reserved.
//

#import "FJMapViewController.h"
#import "FJFlagAnnotation.h"

@interface FJMapViewController ()

@end

@implementation FJMapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

	CLLocationCoordinate2D blueCoord;
    blueCoord.latitude = 48.8789;
    blueCoord.longitude = -113.4598;
	NSString* blueTitle = @"Blue Flag";
	NSString* blueSubtitle = @"flag is hidden here";
	
	FJFlagAnnotation* blueFlag = [[FJFlagAnnotation alloc] initWithCoordinate:blueCoord andTitle:blueTitle andSubtitle: blueSubtitle];
	[_mapView addAnnotation: blueFlag];
	
	CLLocationCoordinate2D orangeCoord;
    orangeCoord.latitude = 43.8789;
    orangeCoord.longitude = -103.4598;
	NSString* orangeTitle = @"Orange Flag";
	NSString* orangeSubtitle = @"flag is hidden here";
	
	FJFlagAnnotation* orangeFlag = [[FJFlagAnnotation alloc] initWithCoordinate:orangeCoord andTitle:orangeTitle andSubtitle: orangeSubtitle];
	[_mapView addAnnotation: orangeFlag];
	
		
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
	[self centerOnMe];
}

- (IBAction)whereAmI:(id)sender {
	CLLocation* current = _mapView.userLocation.location;
	NSLog(@"%g and %g", current.coordinate.latitude, current.coordinate.longitude);
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
	NSLog(@"fuck yes");
	[self centerOnMe];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(FJFlagAnnotation*) annotation {
	
    static NSString *identifier = @"FlagIdentifier";
    MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [_mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
	
	if(![annotation.title isEqualToString:@"Blue Flag"] && ![annotation.title isEqualToString:@"Orange Flag"]){
		return NULL;
	}
	
    if (annotationView == nil) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
		
		annotationView.canShowCallout = YES;
		if([annotation.title isEqualToString:@"Blue Flag"]){
			annotationView.pinColor = MKPinAnnotationColorPurple;
		}else if([annotation.title isEqualToString:@"Orange Flag"]){
			annotationView.pinColor = MKPinAnnotationColorGreen;
		}
    }else {
        annotationView.annotation = annotation;
		annotationView.canShowCallout = YES;
		if([annotation.title isEqualToString:@"Blue Flag"]){
			annotationView.pinColor = MKPinAnnotationColorPurple;
		}else if([annotation.title isEqualToString:@"Orange Flag"]){
			annotationView.pinColor = MKPinAnnotationColorGreen;
		}

    }
	
    return annotationView;
}

@end
