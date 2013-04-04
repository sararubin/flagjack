//
//  FJFirstViewController.m
//  FlagJack
//
//  Created by Ian Guerin on 4/2/13.
//  Copyright (c) 2013 Guerin. All rights reserved.
//

#import "FJLobbyViewController.h"

@interface FJLobbyViewController ()

@end

@implementation FJLobbyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)createGame:(id)sender {
	
	//afnetworking post data
	NSURL *urlForPost = [NSURL URLWithString:@"http://localhost:8888/flagjack/create-game.php"];
	AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:urlForPost];
	
	NSString *authCode = @"&&^#guer16n";
	
	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys: authCode, @"authorize", nil];
	
	[httpClient postPath:@"" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
		NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
		NSArray *words = [responseStr componentsSeparatedByString:@"?"];
		NSString *myId = [words[0] substringFromIndex:1];
		words = [words[1] componentsSeparatedByString:@"*"];
		NSString *gameCode = words[0];
		NSString *gameId = words[1];
		NSLog(@"created id:%@, gamecode:%@, gameid:%@", myId, gameCode, gameId);
		int myIdInt = [myId integerValue];
		int gameIdInt = [gameId integerValue];
		
		[[FJGlobalData shared] setMyId:myIdInt];
		[[FJGlobalData shared] setGameId:gameIdInt];
		[[FJGlobalData shared] setGameCode:gameCode];
		[[FJGlobalData shared] setIsAdmin:YES];
		
		UIViewController* controller = [self.storyboard instantiateViewControllerWithIdentifier:@"NameYourself"];
		controller.view.frame = CGRectMake(0, 0, controller.view.frame.size.width, controller.view.frame.size.height);
		[self addChildViewController:controller];
		[self.view addSubview:controller.view];
		
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		NSLog(@"[HTTPClient Error]: %@", error.localizedDescription);
	}];
}

- (IBAction)joinGame:(id)sender {
	if(_gameCodeTextField.hidden){
		[self moveJoinButtonUp: YES];
		[_joinButton setTitle:@"join this game" forState:UIControlStateNormal];
		[_createButton setTitle:@"nevermind, create new game" forState:UIControlStateNormal];
	}else{
		NSString* gameCode = _gameCodeTextField.text;

		[self textFieldShouldReturn:_gameCodeTextField];

		//afnetworking post data
		NSURL *urlForPost = [NSURL URLWithString:@"http://localhost:8888/flagjack/join-game.php"];
		AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:urlForPost];
		
		NSString *authCode = @"&&^#guer16n";
		
		NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys: authCode, @"authorize", gameCode, @"gameCode", nil];
		
		[httpClient postPath:@"" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
			NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
			//the call was successful, but was the game code valid?
			if([responseStr isEqualToString:@"game code error"]){
				NSLog(@"game code failure");
			}else{
				NSArray *words = [responseStr componentsSeparatedByString:@"?"];
				NSString *myId = [words[0] substringFromIndex:1];
				words = [words[1] componentsSeparatedByString:@"*"];
				NSString *gameCode = words[0];
				NSString *gameId = words[1];
				NSLog(@"joined id:%@, gamecode:%@, gameid:%@", myId, gameCode, gameId);
				int myIdInt = [myId integerValue];
				int gameIdInt = [gameId integerValue];
				
				[[FJGlobalData shared] setMyId:myIdInt];
				[[FJGlobalData shared] setGameId:gameIdInt];
				[[FJGlobalData shared] setGameCode:gameCode];
				[[FJGlobalData shared] setIsAdmin:NO];
			}
		} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
			NSLog(@"[HTTPClient Error]: %@", error.localizedDescription);
		}];

	}
}

- (void)moveJoinButtonUp: (BOOL)up{
	if(up){
		const float movementDuration = 0.3f;
		
		int moveGameCode = -120;
		int moveCreateButton = 120;
		
		[UIView beginAnimations: @"anim" context: nil];
		[UIView setAnimationBeginsFromCurrentState: YES];
		[UIView setAnimationDuration: movementDuration];
		_gameCodeTextField.frame = CGRectOffset(_gameCodeTextField.frame, 0, moveGameCode);
		_createButton.frame = CGRectOffset(_gameCodeTextField.frame, 0, moveCreateButton);
		
		[UIView commitAnimations];
		
		_gameCodeTextField.hidden = NO;
	}
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
