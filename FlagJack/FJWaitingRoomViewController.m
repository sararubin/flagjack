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
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Really reset?" message:@"Do you really want to reset this game?" delegate:self cancelButtonTitle:@"okay, will do" otherButtonTitles:nil];
		[alert show];
	}*/
	
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

- (IBAction)refreshPlayerList:(id)sender {
	[self getPlayerList];
}

-(void) getPlayerList{
	
	//time to populate the list of players in this game!
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
				NSLog(@"%@ and name %@ color %@", words[i],words[i+1],words[i+2]);
				if([[[FJGlobalData shared] playerIds] containsObject:words[i]]){
					//good, then this is just a refresh of dat I already have
				}else{
					[playerIds addObject: words[i]];
					[players addObject: words[i+1]];
					[playerTeamColors addObject: words[i+2]];
				}
			}
			if(_refreshed == NO){
				_refreshed = YES;
				[[FJGlobalData shared] setPlayerIds:playerIds];
				[[FJGlobalData shared] setPlayers:players];
				[[FJGlobalData shared] setPlayerTeamColors:playerTeamColors];
			} else {
				[[[FJGlobalData shared] playerIds] addObjectsFromArray:playerIds];
				[[[FJGlobalData shared] players] addObjectsFromArray:players];
				[[[FJGlobalData shared] playerTeamColors] addObjectsFromArray:playerTeamColors];
			}
						
			NSLog(@"%@ ", [[[FJGlobalData shared] players]objectAtIndex:0]);
			
			[_playerTableView reloadData];
		}
		
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		NSLog(@"[HTTPClient Error]: %@", error.localizedDescription);
	}];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"PlayerCell"];
    static NSString *PlayerCellIdentifier = @"PlayerCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PlayerCellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
    cell.textLabel.text = [[[FJGlobalData shared] players] objectAtIndex: indexPath.row];
    
	cell.textLabel.backgroundColor = [UIColor clearColor];
	
	if([[[[FJGlobalData shared] playerTeamColors] objectAtIndex:indexPath.row] isEqualToString: @"none"]){
		cell.contentView.backgroundColor = [UIColor whiteColor];
	}else if([[[[FJGlobalData shared] playerTeamColors] objectAtIndex:indexPath.row] isEqualToString: @"blue"]){
		cell.contentView.backgroundColor = [UIColor blueColor];
	}else if([[[[FJGlobalData shared] playerTeamColors] objectAtIndex:indexPath.row] isEqualToString: @"orange"]){
		cell.contentView.backgroundColor = [UIColor orangeColor];
	}
	
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	
	if([[[[FJGlobalData shared] playerTeamColors] objectAtIndex:indexPath.row] isEqualToString: @"none"]){
		cell.contentView.backgroundColor = [UIColor blueColor];
		[[[FJGlobalData shared] playerTeamColors] replaceObjectAtIndex:indexPath.row withObject:@"blue"];
	}else if([[[[FJGlobalData shared] playerTeamColors] objectAtIndex:indexPath.row] isEqualToString: @"blue"]){
		cell.contentView.backgroundColor = [UIColor orangeColor];
		[[[FJGlobalData shared] playerTeamColors] replaceObjectAtIndex:indexPath.row withObject:@"orange"];
	}else if([[[[FJGlobalData shared] playerTeamColors] objectAtIndex:indexPath.row] isEqualToString: @"orange"]){
		cell.contentView.backgroundColor = [UIColor whiteColor];
		[[[FJGlobalData shared] playerTeamColors] replaceObjectAtIndex:indexPath.row withObject:@"none"];
	}
}

@end
