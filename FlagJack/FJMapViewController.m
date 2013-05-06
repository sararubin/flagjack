//
//  FJMapViewController.m
//  FlagJack
//
//  Created by Ian Guerin on 4/2/13.
//  Copyright (c) 2013 Guerin. All rights reserved.
//

#import "FJMapViewController.h"


@implementation FJMapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    _teammates = [[NSMutableDictionary alloc] init];
    _flags = [[NSMutableDictionary alloc] init];
	_enemies = [[NSMutableDictionary alloc] init];

    _mapView.showsUserLocation = YES;
    
    //set game "field"
    CLLocationCoordinate2D coords[4] = {{40.719909, -74.010451}, {40.715265,-73.995323}, {40.802437, -73.934582}, {40.815889,-73.959345}};
    
    MKPolygon *gameFieldPoly = [MKPolygon polygonWithCoordinates:coords count:4];
    [_mapView addOverlay:gameFieldPoly];
    
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
	for(id key in _teammates) {
		[_mapView addAnnotation:[_teammates objectForKey:key]];
	}
}
- (void)plotEnemies{
    
    //if i'm not frozen, do this stuff..else, do nothing
    
    [self getEnemies];
	for(id key in _enemies) {
		[_mapView addAnnotation:[_enemies objectForKey:key]];
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
                
				FJTeammateAnnotation* player = [[FJTeammateAnnotation alloc] initWithCoordinate:playerCoord andName:playerName andLocation:playerTeamColor andIdentifier:playerId];
				
                [_teammates setObject:player forKey:playerName];
				
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
                
				FJEnemyAnnotation* player = [[FJEnemyAnnotation alloc] initWithCoordinate:playerCoord andName:playerName andLocation: playerTeamColor andIdentifier:playerId];
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
			NSLog(@"failed to get flaglist");
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
	[self plotFlags];
	[self plotEnemies];
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
			
            NSString *flagColor;
			
            if ([annotation.title isEqualToString:@"Blue Flag"]) {
                
                UIImage *flagImage = [UIImage imageNamed:@"blueFlag.png"];
                flagPinView.image = flagImage;
                flagColor = @"blue";
                
            } else if ([annotation.title isEqualToString:@"Orange Flag"]) {
                
                UIImage *flagImage = [UIImage imageNamed:@"orangeFlag.png"];
                flagPinView.image = flagImage;
                flagColor = @"orange";
            }
			
            
            if(![flagColor isEqualToString: [NSString stringWithFormat: @"%@", [[FJGlobalData shared] myTeamColor]]]){
				UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
				flagPinView.rightCalloutAccessoryView = rightButton;
			}//this is the button that will capture the flag, evenutally should become a change in view to bigger capture button
            
            return flagPinView;
        }
        else {
            pinView.annotation = annotation;
        }
        return pinView;
    }else if ([annotation isKindOfClass:[FJTeammateAnnotation class]]) {
        // for teammates
		
		static NSString *teammateAnnotationIdentifier = @"teammateAnnotationIdentifier";
                
        MKPinAnnotationView *pinView =
        (MKPinAnnotationView *) [self.mapView dequeueReusableAnnotationViewWithIdentifier:teammateAnnotationIdentifier];
        if (pinView == nil) {
            // if an existing pin view was not available, create one
            MKPinAnnotationView *teammatePinView = [[MKPinAnnotationView alloc]
                                                initWithAnnotation:annotation reuseIdentifier:teammateAnnotationIdentifier];
            teammatePinView.canShowCallout = YES;
            teammatePinView.animatesDrop = NO;
            
			UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
			teammatePinView.rightCalloutAccessoryView = rightButton;
						
            NSString *teamColor = [[FJGlobalData shared] myTeamColor];
            UIImage *teammateImage;
            
            if ([teamColor isEqualToString:@"blue"]) {
                
                //team color is blue, use blueDot
                teammateImage = [UIImage imageNamed:@"blueDot.png"];
                teammatePinView.image = teammateImage;
                
            } else {
                
                //team color is orange, use orangeDot
                teammateImage = [UIImage imageNamed:@"orangeDot.png"];
                teammatePinView.image = teammateImage;
            }
            
            return teammatePinView;
            
        } else {
            pinView.annotation = annotation;
        }
        return pinView;
            
    } else if ([annotation isKindOfClass:[FJEnemyAnnotation class]]) {
        // for enemies
		
		static NSString *enemyAnnotationIdentifier = @"enemyAnnotationIdentifier";
        
        MKPinAnnotationView *pinView =
        (MKPinAnnotationView *) [self.mapView dequeueReusableAnnotationViewWithIdentifier:enemyAnnotationIdentifier];
        if (pinView == nil) {
            // if an existing pin view was not available, create one
            MKPinAnnotationView *enemyPinView = [[MKPinAnnotationView alloc]
													initWithAnnotation:annotation reuseIdentifier:enemyAnnotationIdentifier];
            enemyPinView.canShowCallout = YES;
            enemyPinView.animatesDrop = NO;
            
            NSString *enemyColor = [[[FJGlobalData shared] myTeamColor] isEqualToString:@"blue"] ? @"orange" : @"blue";
            UIImage *enemyImage;
            
            if ([enemyColor isEqualToString:@"blue"]) {
                
                //team color is blue, use blueDot
                enemyImage = [UIImage imageNamed:@"blueDot.png"];
                enemyPinView.image = enemyImage;
                
            } else {
                
                //team color is orange, use orangeDot
                enemyImage = [UIImage imageNamed:@"orangeDot.png"];
                enemyPinView.image = enemyImage;
            }

            
			UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
			enemyPinView.rightCalloutAccessoryView = rightButton;
			
            return enemyPinView;
            
        } else {
            pinView.annotation = annotation;
        }
        return pinView;
    }

    
    return nil;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view
calloutAccessoryControlTapped:(UIControl *)control {
	
	if([view.annotation isKindOfClass:[FJFlagAnnotation class]]) { // for flags
		NSLog(@"you captured the flag");
		//afnetworking post data
		NSURL *urlForPost = [NSURL URLWithString:@"http://lolliproject.com/flagjack/change-flag-status.php"];
		AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:urlForPost];
		
		NSString *authCode = @"&&^#guer16n";
		NSString *gameId = [NSString stringWithFormat:@"%d", [[FJGlobalData shared]gameId]];
		NSString *myId = [NSString stringWithFormat:@"%d", [[FJGlobalData shared]myId]];
		NSString *flagStatus = [NSString stringWithFormat:@"%d", 2];
		NSString * flagColor;
		if([[[FJGlobalData shared] myTeamColor] isEqualToString:@"blue"]){
			 flagColor = @"Orange Flag";
		}else{
			 flagColor = @"Blue Flag";
		}
		
		NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys: authCode, @"authorize", gameId, @"gameId", flagColor, @"flagColor", flagStatus, @"flagStatus", myId, @"myId", nil];
		
		[httpClient postPath:@"" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
			NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
			if([responseStr isEqualToString:@"failure"]){
				NSLog(@"failed to save name");
			}else{
				//alert them that they have frozen themselves
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Flag Stolen!" message:@"You are visible now visible to all players!" delegate:self cancelButtonTitle:@"RUN!" otherButtonTitles:nil];
				[alert show];
				
			}
			
		} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
			NSLog(@"[HTTPClient Error]: %@", error.localizedDescription);
		}];
	}else{
		int idToDisclose = -1;
		if([view.annotation.title isEqualToString:@"Enemy"]){
			FJEnemyAnnotation *enemyAnn = view.annotation;
			idToDisclose = enemyAnn.ident;
			[[FJGlobalData shared] setDiscloseEnemy:YES];
		}else{
			FJTeammateAnnotation *teammateAnn = view.annotation;
			idToDisclose = teammateAnn.ident;
			[[FJGlobalData shared] setDiscloseEnemy:NO];
		}
		[[FJGlobalData shared] setIdToDisclose:idToDisclose];
		
		UIViewController* controller = [self.storyboard instantiateViewControllerWithIdentifier:@"Disclosure"];
		controller.view.frame = CGRectMake(0, 0, controller.view.frame.size.width, controller.view.frame.size.height);
		[self addChildViewController:controller];
		[self.view addSubview:controller.view];
	}
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    MKPolygonView *polygonView = [[MKPolygonView alloc] initWithPolygon:overlay];
    polygonView.lineWidth = 1.0;
    polygonView.strokeColor = [UIColor redColor];
    return polygonView;
}

@end