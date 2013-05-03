//
//  FJMapViewController.m
//  FlagJack
//
//  Created by Ian Guerin on 4/2/13.
//  Copyright (c) 2013 Guerin. All rights reserved.
//

#import "FJMapViewController.h"

@implementation FJMapViewController

@synthesize teammates;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    teammates = [[NSMutableDictionary alloc] init];
    _flags = [[NSMutableDictionary alloc] init];

    _mapView.showsUserLocation = YES;
    
    [self centerOnMe];
    [self plotFlags];
	[self plotTeammates];
}

- (void)plotFlags {
    //if i'm not frozen, do this stuff..else, do nothing
    
    [self getFlags];
    for(id key in _flags) {
        [_mapView addAnnotation:[_flags objectForKey:key]];
	}
	
}

- (void)plotTeammates {
    
    //if i'm not frozen, do this stuff..else, do nothing
    
    [self getTeammates];
    for(id key in teammates) {
        [_mapView addAnnotation:[teammates objectForKey:key]];
	}
}

- (void)getTeammates {
    //afnetworking post data
	NSURL *urlForPost = [NSURL URLWithString:@"http://lolliproject.com/flagjack/get-player-list-with-location.php"];
	AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:urlForPost];
    
    //move this to global data
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
                        						
			for(int i = 0; i < [words count]; i+=5) {
				[titles addObject: words[i]];//the person's name
				[subs addObject: words[i+1]];//the person's team color
				[lats addObject: words[i+2]];//the persons latitude
				[longs addObject: words[i+3]];//the person's longitude
				[ids addObject: words[i+4]];//the person's id
			}
			
			for(int i = 0; i < [titles count]; i++) {
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
                [teammates setObject:player forKey:playerName];
            }
		}
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		NSLog(@"[HTTPClient Error]: %@", error.localizedDescription);
	}];
}

- (void)getEnemies {
    //afnetworking post data
	NSURL *urlForPost = [NSURL URLWithString:@"http://lolliproject.com/flagjack/get-player-list-with-location.php"];
	AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:urlForPost];
    
    //move this to global data
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
				
				if([playerTeamColor isEqualToString:[[FJGlobalData shared] myTeamColor]] || (playerId == [[FJGlobalData shared] myId])){//if you're  a teammate, you're not an enemy, and I'm not an enemy
					continue;
				}
                
				FJTeammateAnnotation* player = [[FJTeammateAnnotation alloc] initWithCoordinate:playerCoord andName:playerName andLocation: playerTeamColor];
				[_enemies setObject: player forKey: player.name];
            }
		}
		
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		NSLog(@"[HTTPClient Error]: %@", error.localizedDescription);
	}];
}

- (void)getFlags {
    //afnetworking post data
	NSURL *urlForPost = [NSURL URLWithString:@"http://lolliproject.com/flagjack/get-flags.php"];
	AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:urlForPost];
    
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
			index = ([titles[0] isEqualToString:@"Orange Flag"]) ? 0 : 1;
			
            CLLocationCoordinate2D orangeCoord;
			orangeCoord.latitude = [lats[index] doubleValue];
			orangeCoord.longitude = [longs[index] doubleValue];
			
			FJFlagAnnotation* orangeFlag = [[FJFlagAnnotation alloc] initWithCoordinate:orangeCoord andTitle:titles[index] andSubtitle: subs[index]];
			index = (index == 0) ? 1 : 0;
			
			CLLocationCoordinate2D blueCoord;
			blueCoord.latitude = [lats[index] doubleValue];
			blueCoord.longitude = [longs[index] doubleValue];
			
			FJFlagAnnotation* blueFlag = [[FJFlagAnnotation alloc] initWithCoordinate:blueCoord andTitle:titles[index] andSubtitle: subs[index]];
			
			[_flags setObject: blueFlag forKey: blueFlag.title];
			[_flags setObject: orangeFlag forKey: orangeFlag.title];
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
    for (id<MKAnnotation> annotation in _mapView.annotations) {
        
        if(![annotation.title isEqualToString:@"Blue Flag"] && ![annotation.title isEqualToString:@"Orange Flag"]) {
			[_mapView removeAnnotation:annotation];
		}

    }

    [self centerOnMe];
    [self plotTeammates];
}

- (IBAction)whereAmI:(id)sender {
	CLLocation* current = _mapView.userLocation.location;
	NSLog(@"%g and %g", current.coordinate.latitude, current.coordinate.longitude);
    [self centerOnMe];
}

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
		} else {
            
            //will have to keep track of player's progression through regions, so we don't spam them
            //only updates user if progression index changes (if user leaves current region/gets further away or if user enters a smaller region/gets closer
            
            //if ([ENEMY_FLAG_REGION_1 containsCoordinate: userLocation.coordinate]) {
                //send alert, zoom, whatever
            //}
            
            
			
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
        
        MKPinAnnotationView *pinView = (MKPinAnnotationView *) [self.mapView dequeueReusableAnnotationViewWithIdentifier:flagAnnotationIdentifier];
        if (pinView == nil) {
            // if an existing pin view was not available, create one
            MKPinAnnotationView *flagPinView = [[MKPinAnnotationView alloc]
                                                  initWithAnnotation:annotation reuseIdentifier:flagAnnotationIdentifier];
            flagPinView.canShowCallout = YES;
            if ([annotation.title isEqualToString:@"Blue Flag"]) {
                flagPinView.pinColor = MKPinAnnotationColorPurple;
            } else if ([annotation.title isEqualToString:@"Orange Flag"]){
                flagPinView.pinColor = MKPinAnnotationColorRed;
            } else {
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
        //I FEEL LIKE THIS SHOULD BE A BLINKING DOT LIKE MY LOCATION IS
		
		
		static NSString *teammateAnnotationIdentifier = @"teammateAnnotationIdentifier";
        
        MKPinAnnotationView *pinView =
        (MKPinAnnotationView *) [self.mapView dequeueReusableAnnotationViewWithIdentifier:teammateAnnotationIdentifier];
        if (pinView == nil) {
            // if an existing pin view was not available, create one
            MKPinAnnotationView *teammatePinView = [[MKPinAnnotationView alloc]
                                                initWithAnnotation:annotation reuseIdentifier:teammateAnnotationIdentifier];
            teammatePinView.canShowCallout = YES;
            teammatePinView.animatesDrop = NO;
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