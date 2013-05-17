//
//  FJGlobalData.h
//  FlagJack
//
//  Created by Ian Guerin on 4/3/13.
//  Copyright (c) 2013 Guerin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "AFHTTPClient.h"


//this is the global data that can be accessed through out the application
@interface FJGlobalData : NSObject


//these variables do not change after being declared once when the game is created.
@property int myId;
@property int gameId;
@property NSString *gameIdStr;
@property NSString *myTeamColor;
@property NSString *myName;
@property NSString *gameCode;
@property NSString *team;
@property BOOL isAdmin;
@property BOOL isCaptain;
@property BOOL isFrozen;
@property BOOL gameHasStarted;
@property BOOL discloseEnemy;
@property NSMutableArray* players;
@property NSMutableArray* playerIds;
@property NSMutableArray* playerTeamColors;
@property int orangeCaptainId;
@property int blueCaptainId;
@property int idToDisclose;


extern NSString *authCode;

//these variables can change
@property CLLocationCoordinate2D myFlagLocation;
@property CLLocationCoordinate2D enemyFlagLocation;

+ (FJGlobalData*)shared;

-(void) unfreeze;

@end