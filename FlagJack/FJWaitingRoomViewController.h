//
//  FJWaitingRoomViewController.h
//  FlagJack
//
//  Created by Ian Guerin on 4/3/13.
//  Copyright (c) 2013 Guerin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FJGlobalData.h"
#import "AFHTTPClient.h"
#import "FJWaitingRoomTableViewCell.h"

//this class allows the admin to assign players to teams
//normal players (non-admins) just get to wait until the game has started
@interface FJWaitingRoomViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *playerTableView;
@property (weak, nonatomic) IBOutlet UILabel *gameCodeOut;
@property BOOL refreshed;
@property (weak, nonatomic) IBOutlet UIButton *startGameButton;
@property (weak, nonatomic) IBOutlet UIButton *endGameButton;
@property (weak, nonatomic) IBOutlet UIButton *leaveGameButton;

- (IBAction)refreshPlayerList:(id)sender;
- (IBAction)startGame:(id)sender;
- (IBAction)endGame:(id)sender;
- (IBAction)leaveGame:(id)sender;


-(void) getPlayerList;

@end
