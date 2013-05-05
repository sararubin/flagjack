//
//  FJWaitingRoomViewController.m
//  FlagJack
//
//  Created by Ian Guerin on 4/3/13.
//  Copyright (c) 2013 Guerin. All rights reserved.
//

#import "FJWaitingRoomViewController.h"

@interface FJWaitingRoomViewController ()

@end

@implementation FJWaitingRoomViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
		
	/*if([[FJGlobalData shared]isAdmin]){
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Final Setup!" message:@"Assign each player to a team, and chose team captains!" delegate:self cancelButtonTitle:@"okay, will do" otherButtonTitles:nil];
		[alert show];
	}else{
		//you must be a normal player
	}*/
	_gameCodeOut.text = [NSString stringWithFormat:@"gc: %@",[[FJGlobalData shared] gameCode]];
	[self getPlayerList];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return [[[FJGlobalData shared] players] count];
	
}

- (void)viewDidAppear:(BOOL)animated{
	if([[FJGlobalData shared] gameHasStarted]){
		[_playerTableView reloadData];
	}else{
		//game hasn't started yet
	}
}

- (IBAction)startGame:(id)sender {
	
	[self getPlayerList];
	[[FJGlobalData shared] setGameHasStarted:YES];
	
	//gotta save my color
	int indexOfMe = [[[FJGlobalData shared] playerIds] indexOfObject:[NSString stringWithFormat:@"%d",[[FJGlobalData shared] myId]]];
	[[FJGlobalData shared] setMyTeamColor:[[[FJGlobalData shared] playerTeamColors]objectAtIndex:indexOfMe]];
	
	if([[FJGlobalData shared] isAdmin]){
		if([[FJGlobalData shared] orangeCaptainId] == 0 || [[FJGlobalData shared] blueCaptainId] == 0  || [[[FJGlobalData shared] playerTeamColors] containsObject:@"none"] ){
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Setup Problems!" message:@"Is everyone on a team? Do both teams have a captain?" delegate:self cancelButtonTitle:@"oops, I'll check" otherButtonTitles:nil];
			[alert show];
		} else{
			//put teams into database- colors and captains!
			//afnetworking post data
			NSURL *urlForPost = [NSURL URLWithString:@"http://lolliproject.com/flagjack/set-teams-start-game.php"];
			AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:urlForPost];
			
			NSString *authCode = @"&&^#guer16n";
			NSString *gameId = [NSString stringWithFormat:@"%d", [[FJGlobalData shared]gameId]];
			//this variable should be set also by the admin
			NSString* minutesToHide = @"2";
			NSString* blueCaptainId = [NSString stringWithFormat:@"%d", [[FJGlobalData shared] blueCaptainId]];
			NSString* orangeCaptainId = [NSString stringWithFormat:@"%d", [[FJGlobalData shared] orangeCaptainId]];
			NSArray* ids = [[FJGlobalData shared] playerIds];
			NSArray* tColors = [[FJGlobalData shared] playerTeamColors];
			
			
			NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys: authCode, @"authorize", gameId, @"gameId",minutesToHide, @"minutesToHide", ids, @"playerIds", tColors, @"playerTeamColors", orangeCaptainId, @"orangeCaptainId", blueCaptainId, @"blueCaptainId", nil];
			
			[httpClient postPath:@"" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
				NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
				if([responseStr isEqualToString:@"failure"]){
					NSLog(@"failed to get playerlist");
				}else{
					//game has started!-> take me to my map pagee
					NSArray* tokens = [responseStr componentsSeparatedByString:@"bid:"];
					NSArray* tokens2 = [tokens[1] componentsSeparatedByString:@"oid:"];
					NSString* blueCaptainId = tokens2[0];
					NSString* orangeCaptainId = tokens2[1];
					[[FJGlobalData shared] setBlueCaptainId:[blueCaptainId integerValue]];
					[[FJGlobalData shared] setOrangeCaptainId:[orangeCaptainId integerValue]];
					if([blueCaptainId integerValue] == [[FJGlobalData shared] myId] || [orangeCaptainId integerValue] == [[FJGlobalData shared] myId]){
						[[FJGlobalData shared] setIsCaptain:YES];
					}
					
					_endGameButton.hidden = NO;
					_startGameButton.hidden = YES;
					self.tabBarController.selectedIndex = 1;
					
				}
				
			} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
				NSLog(@"[HTTPClient Error]: %@", error.localizedDescription);
			}];
		}
	} else{
		
		//check to see if the admin has started the game!!!!
		//afnetworking post data
		NSURL *urlForPost = [NSURL URLWithString:@"http://lolliproject.com/flagjack/has-game-started.php"];
		AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:urlForPost];
		
		NSString *authCode = @"&&^#guer16n";
		NSString *gameId = [NSString stringWithFormat:@"%d", [[FJGlobalData shared]gameId]];

		NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys: authCode, @"authorize", gameId, @"gameId", nil];
		
		[httpClient postPath:@"" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
			NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
			if([responseStr isEqualToString:@"failure"]){
				NSLog(@"failed to get playerlist");
			}else{
				NSLog(@"%@",responseStr);
				if([responseStr isEqualToString:@"not started"]){
					UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Chill, chill!" message:@"We gotta wait for the admin to start the game!" delegate:self cancelButtonTitle:@"okay, I'll wait" otherButtonTitles:nil];
					[alert show];
				} else{
					//game has started!-> take me to my map pagee
					NSArray* tokens = [responseStr componentsSeparatedByString:@"bid:"];
					NSArray* tokens2 = [tokens[1] componentsSeparatedByString:@"oid:"];
					NSString* blueCaptainId = tokens2[0];
					NSString* orangeCaptainId = tokens2[1];
					[[FJGlobalData shared] setBlueCaptainId:[blueCaptainId integerValue]];
					[[FJGlobalData shared] setOrangeCaptainId:[orangeCaptainId integerValue]];
					if([blueCaptainId integerValue] == [[FJGlobalData shared] myId] || [orangeCaptainId integerValue] == [[FJGlobalData shared] myId]){
						[[FJGlobalData shared] setIsCaptain:YES];
					}
					
					_leaveGameButton.hidden = NO;
					_startGameButton.hidden = YES;
					self.tabBarController.selectedIndex = 1;
					
				}
			}
			
		} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
			NSLog(@"[HTTPClient Error]: %@", error.localizedDescription);
		}];
		
	}
}

- (IBAction)endGame:(id)sender {
}

- (IBAction)leaveGame:(id)sender {
}

- (IBAction)refreshPlayerList:(id)sender {
	[self getPlayerList];
}

-(void) getPlayerList{
	
	if([[FJGlobalData shared] isAdmin] && ![_startGameButton isHidden]){
		//time to populate the list of players in this game!
		//afnetworking post data
		NSURL *urlForPost = [NSURL URLWithString:@"http://lolliproject.com/flagjack/get-and-update-player-list.php"];
		AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:urlForPost];
		
		NSString *authCode = @"&&^#guer16n";
		NSString *gameId = [NSString stringWithFormat:@"%d", [[FJGlobalData shared]gameId]];
		NSString* blueCaptainId = [NSString stringWithFormat:@"%d", [[FJGlobalData shared] blueCaptainId]];
		NSString* orangeCaptainId = [NSString stringWithFormat:@"%d", [[FJGlobalData shared] orangeCaptainId]];
		NSArray* ids = [[FJGlobalData shared] playerIds];
		NSArray* tColors = [[FJGlobalData shared] playerTeamColors];
		
		NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys: authCode, @"authorize", gameId, @"gameId", ids, @"playerIds", tColors, @"playerTeamColors", orangeCaptainId, @"orangeCaptainId", blueCaptainId, @"blueCaptainId", nil];
		
		[httpClient postPath:@"" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
			NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
			if([responseStr isEqualToString:@"failure"]){
				NSLog(@"failed to get playerlist");
			}else{
				NSArray *tokens = [responseStr componentsSeparatedByString:@"!@!@"];
				NSMutableArray *words = [[NSMutableArray alloc]initWithArray:tokens];
				[words removeObjectAtIndex: [words count]-1];
				
				NSMutableArray *players = [[NSMutableArray alloc]init];
				NSMutableArray *playerIds = [[NSMutableArray alloc]init];
				NSMutableArray *playerTeamColors = [[NSMutableArray alloc]init];
				
				//problematic- must change this so that if a user leaves the lobby (quits the game) then they will be taken out of the list
				for(int i = 0; i < [words count]; i+=3){
					[playerIds addObject: words[i]];
					[players addObject: words[i+1]];
					[playerTeamColors addObject: words[i+2]];
				}
				
				[[FJGlobalData shared] setPlayerIds:playerIds];
				[[FJGlobalData shared] setPlayers:players];
				[[FJGlobalData shared] setPlayerTeamColors:playerTeamColors];
				
				NSString* oId = [NSString stringWithFormat:@"%d",[[FJGlobalData shared] orangeCaptainId]];
				NSString* bId = [NSString stringWithFormat:@"%d",[[FJGlobalData shared] blueCaptainId]];
				
				if(![[[FJGlobalData shared] playerIds] containsObject: oId]){
					[[FJGlobalData shared] setOrangeCaptainId: 0];
				}
				if(![[[FJGlobalData shared] playerIds] containsObject: bId]){
					[[FJGlobalData shared] setBlueCaptainId: 0];
				}
				
				[_playerTableView reloadData];
			}
			
		} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
			NSLog(@"[HTTPClient Error]: %@", error.localizedDescription);
		}];
	} else{
		//must not overwrite data on the server because I'm not the admin
		//afnetworking post data
		NSURL *urlForPost = [NSURL URLWithString:@"http://lolliproject.com/flagjack/get-player-list.php"];
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
				
				NSMutableArray *players = [[NSMutableArray alloc]init];
				NSMutableArray *playerIds = [[NSMutableArray alloc]init];
				NSMutableArray *playerTeamColors = [[NSMutableArray alloc]init];
				
				for(int i = 0; i < [words count]; i+=3){
					[playerIds addObject: words[i]];
					[players addObject: words[i+1]];
					[playerTeamColors addObject: words[i+2]];
				}
				
				[[FJGlobalData shared] setPlayerIds:playerIds];
				[[FJGlobalData shared] setPlayers:players];
				[[FJGlobalData shared] setPlayerTeamColors:playerTeamColors];
				
				[_playerTableView reloadData];
			}
			
		} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
			NSLog(@"[HTTPClient Error]: %@", error.localizedDescription);
		}];
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{	
    static NSString *PlayerCellIdentifier = @"playerCell";
	
    FJWaitingRoomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PlayerCellIdentifier forIndexPath:indexPath];
	if (cell == nil) {
        cell = [[FJWaitingRoomTableViewCell alloc]
				initWithStyle:UITableViewCellStyleDefault
				reuseIdentifier:PlayerCellIdentifier];
    }
	
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

	cell.playerName.text = [[[FJGlobalData shared] players] objectAtIndex: indexPath.row];
	
	cell.textLabel.backgroundColor = [UIColor clearColor];
	
	if([_startGameButton isHidden]){
		cell.playerType.hidden = YES;
	}
	
	NSInteger thisPlayersId = [[[[FJGlobalData shared] playerIds] objectAtIndex: indexPath.row] integerValue];
	
	if(thisPlayersId != [[FJGlobalData shared] orangeCaptainId] && thisPlayersId != [[FJGlobalData shared] blueCaptainId]   ){
		cell.playerType.selectedSegmentIndex = 0;
	} else {
		cell.playerType.selectedSegmentIndex = 1;
	}
	
	if([[[[FJGlobalData shared] playerTeamColors] objectAtIndex:indexPath.row] isEqualToString: @"none"]){
		cell.contentView.backgroundColor = [UIColor whiteColor];
		[cell.playerName setTextColor:[UIColor blackColor]];
		cell.playerType.hidden = YES;
	}else if([[[[FJGlobalData shared] playerTeamColors] objectAtIndex:indexPath.row] isEqualToString: @"blue"]){
		cell.contentView.backgroundColor = [UIColor blueColor];
		[cell.playerName setTextColor:[UIColor whiteColor]];
		if([[FJGlobalData shared] isAdmin] && ![_startGameButton isHidden]){
			cell.playerType.hidden = NO;
		}
	}else if([[[[FJGlobalData shared] playerTeamColors] objectAtIndex:indexPath.row] isEqualToString: @"orange"]){
		cell.contentView.backgroundColor = [UIColor orangeColor];
		[cell.playerName setTextColor:[UIColor whiteColor]];
		if([[FJGlobalData shared] isAdmin] && ![_startGameButton isHidden]){
			cell.playerType.hidden = NO;
		}
	}
	
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	if([[FJGlobalData shared] isAdmin] && ![_startGameButton isHidden]){
		FJWaitingRoomTableViewCell *cell = (FJWaitingRoomTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
		
		if([[[[FJGlobalData shared] playerTeamColors] objectAtIndex:indexPath.row] isEqualToString: @"none"]){
			cell.contentView.backgroundColor = [UIColor blueColor];
			[cell.playerName setTextColor:[UIColor whiteColor]];
			cell.playerType.hidden = NO;
			[[[FJGlobalData shared] playerTeamColors] replaceObjectAtIndex:indexPath.row withObject:@"blue"];
			
			
			//if this is the first blue, make it captain
			if([[FJGlobalData shared] blueCaptainId] == 0){
				cell.playerType.selectedSegmentIndex = 1;
				
				[[FJGlobalData shared] setBlueCaptainId:[[[[FJGlobalData shared] playerIds] objectAtIndex:indexPath.row] integerValue]];
				
			} else if(cell.playerType.selectedSegmentIndex == 1){
				cell.playerType.selectedSegmentIndex = 0;
			}
		}else if([[[[FJGlobalData shared] playerTeamColors] objectAtIndex:indexPath.row] isEqualToString: @"blue"]){
			cell.contentView.backgroundColor = [UIColor orangeColor];
			[cell.playerName setTextColor:[UIColor whiteColor]];
			cell.playerType.hidden = NO;
			[[[FJGlobalData shared] playerTeamColors] replaceObjectAtIndex:indexPath.row withObject:@"orange"];
			
			if(cell.playerType.selectedSegmentIndex == 1){
				cell.playerType.selectedSegmentIndex = 0;
				[[FJGlobalData shared] setBlueCaptainId:0];
			}
			//if this is the first orange, then make it the captain
			if([[FJGlobalData shared] orangeCaptainId] == 0){
				cell.playerType.selectedSegmentIndex = 1;
				[[FJGlobalData shared] setOrangeCaptainId:[[[[FJGlobalData shared] playerIds] objectAtIndex:indexPath.row] integerValue]];
				
			}
		}else if([[[[FJGlobalData shared] playerTeamColors] objectAtIndex:indexPath.row] isEqualToString: @"orange"]){
			cell.contentView.backgroundColor = [UIColor whiteColor];
			[cell.playerName setTextColor:[UIColor blackColor]];
			cell.playerType.hidden = YES;
			[[[FJGlobalData shared] playerTeamColors] replaceObjectAtIndex:indexPath.row withObject:@"none"];
			if(cell.playerType.selectedSegmentIndex == 1){
				cell.playerType.selectedSegmentIndex = 0;
				
				[[FJGlobalData shared] setOrangeCaptainId:0];

			}
		}
	}
}

@end
