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
	NSURL *urlForPost = [NSURL URLWithString:@"http://localhost:8888/flagjack/get-player-list.php"];
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
			NSMutableArray *players = [[NSMutableArray alloc] init];
			NSMutableArray *playerIds = [[NSMutableArray alloc] init];
			
			[words removeObjectAtIndex: [words count]-1];
			for(int i = 0; i < [words count]; i++){
				if(i%2 == 0){
					[playerIds addObject:words[i]];
				}else{
					[players addObject:words[i]];
				}

			}
			
			[[FJGlobalData shared] setPlayers:players];
			[[FJGlobalData shared] setPlayerIds:playerIds];
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
    
    cell.textLabel.text = [[[FJGlobalData shared] playerIds] objectAtIndex: indexPath.row];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	
	/* here pop up Your subview with corresponding  value  from the array with array index indexpath.row ..*/
	
}

@end
