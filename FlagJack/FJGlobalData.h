//
//  FJGlobalData.h
//  FlagJack
//
//  Created by Ian Guerin on 4/3/13.
//  Copyright (c) 2013 Guerin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FJGlobalData : NSObject

@property int myId;
@property int gameId;
@property NSString *myTeamColor;
@property NSString *myName;
@property NSString *gameCode;
@property NSString *team;
@property BOOL isAdmin;
@property BOOL isCaptain;
@property NSMutableArray* players;
@property NSMutableArray* playerIds;
@property NSMutableArray* playerTeamColors;
@property int orangeCaptainId;
@property int blueCaptainId;

+ (FJGlobalData*)shared;

@end
