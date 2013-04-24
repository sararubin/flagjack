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
#import "AFHTTPClient.h"

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
    [self plotFlags];
	[self plotTeammates];
}

- (void)plotFlags {
	
	//afnetworking post data
	NSURL *urlForPost = [NSURL URLWithString:@"http://lolliproject.com/flagjack/get-flags.php"];
	AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:urlForPost];
	
	NSString *authCode = @"&&^#guer16n";
	NSString *gameId = [NSString stringWithFormat:@"%d", [[FJGlobalData shared]gameId]];
	
	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys: authCode, @"authorize", gameId, @"gameId", nil];
	
	[httpClient postPath:@"" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
		NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
		if([responseStr isEqualToString:@"failure"]){
			NSLog(@"failed to get playerlist");
		}else{
			NSArray *tokens = [responseStr componentsSeparatedByString:@"!@!@"];
			NSMutableArray *words = [[NSMutableArray alloc]initWithArray:tokens];
			[words removeObjectAtIndex: [words count]-1];
			
			NSMutableArray *titles = [[NSMutableArray alloc]init];
			NSMutableArray *subs = [[NSMutableArray alloc]init];
			NSMutableArray *lats = [[NSMutableArray alloc]init];
			NSMutableArray *longs = [[NSMutableArray alloc]init];
			
			for(int i = 0; i < [words count]; i+=4){
				[titles addObject: words[i]];
				[subs addObject: words[i+1]];
				[lats addObject: words[i+2]];
				[longs addObject: words[i+3]];
			}
			int index;
			if([titles[0] isEqualToString:@"Orange Flag"]){
				index = 0;
			}else{
				index = 1;
			}
			CLLocationCoordinate2D orangeCoord;
			orangeCoord.latitude = [lats[index] doubleValue];
			orangeCoord.longitude = [longs[index] doubleValue];
			
			FJFlagAnnotation* orangeFlag = [[FJFlagAnnotation alloc] initWithCoordinate:orangeCoord andTitle:titles[index] andSubtitle: subs[index]];
			if(index == 0){
				index = 1;
			}else{
				index = 0;
			}
			
			CLLocationCoordinate2D blueCoord;
			blueCoord.latitude = [lats[index] doubleValue];
			blueCoord.longitude = [longs[index] doubleValue];
			
			FJFlagAnnotation* blueFlag = [[FJFlagAnnotation alloc] initWithCoordinate:blueCoord andTitle:titles[index] andSubtitle: subs[index]];
			
			NSMutableDictionary *flags = [NSMutableDictionary dictionary];
			[flags setObject: blueFlag forKey: blueFlag.title];
			[flags setObject: orangeFlag forKey: orangeFlag.title];
			
			for(id key in flags) {
				[_mapView addAnnotation:[flags objectForKey:key]];
			}
		}
		
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		NSLog(@"[HTTPClient Error]: %@", error.localizedDescription);
	}];
	
	MKUserLocation * newest = [[MKUserLocation alloc] init];
	CLLocationCoordinate2D blueCoord;
	blueCoord.latitude = 40.4230;
	blueCoord.longitude = -98.7372;
	[newest setCoordinate:blueCoord];
	NSLog(@"add newest");
	
	[_mapView addAnnotation:newest];
}

- (void)plotTeammates {

	//afnetworking post data
	NSURL *urlForPost = [NSURL URLWithString:@"http://lolliproject.com/flagjack/get-player-list-with-location.php"];
	AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:urlForPost];
	
	NSString *authCode = @"&&^#guer16n";
	NSString *gameId = [NSString stringWithFormat:@"%d", [[FJGlobalData shared]gameId]];
	
	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys: authCode, @"authorize", gameId, @"gameId", nil];
	
	[httpClient postPath:@"" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
		NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
		if([responseStr isEqualToString:@"failure"]){
			NSLog(@"failed to get playerlist");
		}else{
			NSArray *tokens = [responseStr componentsSeparatedByString:@"!@!@"];
			NSMutableArray *words = [[NSMutableArray alloc]initWithArray:tokens];
			[words removeObjectAtIndex: [words count]-1];
			
			NSMutableArray *titles = [[NSMutableArray alloc]init];
			NSMutableArray *subs = [[NSMutableArray alloc]init];
			NSMutableArray *lats = [[NSMutableArray alloc]init];
			NSMutableArray *longs = [[NSMutableArray alloc]init];
			NSMutableArray *ids = [[NSMutableArray alloc]init];
			NSMutableDictionary *teammates = [NSMutableDictionary dictionary];
			
			for(int i = 0; i < [words count]; i+=5){
				[titles addObject: words[i]];//the person's name
				[subs addObject: words[i+1]];//the person's team color
				[lats addObject: words[i+2]];//the persons latitude
				[longs addObject: words[i+3]];//the person's longitude
				[ids addObject: words[i+4]];//the person's id
			}
			
			for(int i = 0; i < [titles count]; i++){
				CLLocationCoordinate2D playerCoord;
				playerCoord.latitude = [lats[i] doubleValue];
				playerCoord.longitude = [longs[i] doubleValue];
				NSString* playerName = [NSString stringWithFormat:@"%@", titles[i]];
				NSString* playerTeamColor = [NSString stringWithFormat:@"%@", subs[i]];
				int playerId = [ids[i] intValue];
				
				if(![playerTeamColor isEqualToString:[[FJGlobalData shared] myTeamColor]] || (playerId == [[FJGlobalData shared] myId])){//if you're not a teammate, I don't get to see you on my map, and I'm not my teammate
					continue;
				}
				
				FJTeammateAnnotation* player = [[FJTeammateAnnotation alloc] initWithCoordinate:playerCoord andName:playerName andLocation: playerTeamColor];
				[teammates setObject: player forKey: player.name];
				
				for (id key in teammates) {
					[_mapView addAnnotation:[teammates objectForKey:key]];
				}
			}
			
		}
		
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		NSLog(@"[HTTPClient Error]: %@", error.localizedDescription);
	}];
	
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
	//this is changing the color of pins of the flags for some reason on re-adding
    for (id<MKAnnotation> annotation in _mapView.annotations) {
        if(![annotation.title isEqualToString:@"Blue Flag"] && ![annotation.title isEqualToString:@"Orange Flag"]){
			[_mapView removeAnnotation:annotation];
		}

    }

    [self centerOnMe];
    //[self plotFlags]; don't need to re-add because I don't remove
    [self plotTeammates];
}

- (IBAction)whereAmI:(id)sender {
	CLLocation* current = _mapView.userLocation.location;
	NSLog(@"%g and %g", current.coordinate.latitude, current.coordinate.longitude);
    [self centerOnMe];
}

//pragma whatever?

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
	//afnetworking post data
	NSURL *urlForPost = [NSURL URLWithString:@"http://lolliproject.com/flagjack/set-player-location.php"];
	AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:urlForPost];
	
	NSString *authCode = @"&&^#guer16n";
	NSString *gameId = [NSString stringWithFormat:@"%d", [[FJGlobalData shared]gameId]];
	CLLocation* current = _mapView.userLocation.location;
	NSString* latitude = [NSString stringWithFormat:@"%f", current.coordinate.latitude];
	NSString* longitude = [NSString stringWithFormat:@"%f", current.coordinate.longitude];
	NSString *idString = [NSString stringWithFormat:@"%d",[[FJGlobalData shared] myId]];

	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys: authCode, @"authorize", gameId, @"gameId", latitude, @"latitude", longitude, @"longitude", idString, @"myId", nil];
	
	[httpClient postPath:@"" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
		NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
		if([responseStr isEqualToString:@"failure"]){
			NSLog(@"failed to get playerlist");
		}else{
			//what to do on success?
		}
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		NSLog(@"[HTTPClient Error]: %@", error.localizedDescription);
	}];

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
            }else{
				flagPinView.pinColor = MKPinAnnotationColorRed;
			}
            
            return flagPinView;
        }
        else {
            pinView.annotation = annotation;
        }
        return pinView;
    }
    else if ([annotation isKindOfClass:[FJTeammateAnnotation class]]) { // for teammates
        //I FEEL LIKE THIS SHOULD BE A BLINKING DOT LIKE MY LOCATION IS
		
		
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