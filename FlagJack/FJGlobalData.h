//
//  FJGlobalData.h
//  FlagJack
//
//  Created by Ian Guerin on 4/3/13.
//  Copyright (c) 2013 Guerin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

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
@property BOOL gameHasStarted;
@property NSMutableArray* players;
@property NSMutableArray* playerIds;
@property NSMutableArray* playerTeamColors;
@property int orangeCaptainId;
@property int blueCaptainId;

//should this also be a property?
extern NSString *authCode;

//these variables can change
@property CLLocationCoordinate2D myFlagLocation;
@property CLLocationCoordinate2D enemyFlagLocation;

+ (FJGlobalData*)shared;

@end
