//
//  FJNameYourselfViewController.m
//  FlagJack
//
//  Created by Ian Guerin on 4/3/13.
//  Copyright (c) 2013 Guerin. All rights reserved.
//

#import "FJNameYourselfViewController.h"

@interface FJNameYourselfViewController ()

@end

@implementation FJNameYourselfViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)toWaitingRoomButton:(id)sender {

	[self textFieldShouldReturn:_nameYourselfTextField];
	
	//afnetworking post data
	NSURL *urlForPost = [NSURL URLWithString:@"http://lolliproject.com/flagjack/set-player-name.php"];
	AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:urlForPost];
	
	NSString *authCode = @"&&^#guer16n";
	NSString *name = _nameYourselfTextField.text;
	NSString *idString = [NSString stringWithFormat:@"%d",[[FJGlobalData shared] myId]];
	
	
	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys: authCode, @"authorize", name, @"name", idString, @"myId", nil];
	
	[httpClient postPath:@"" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
		NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
		if([responseStr isEqualToString:@"failure"]){
			NSLog(@"failed to save name");
		}else{
			[[FJGlobalData shared] setMyName:name];
			
			UITableViewController* controller = [self.storyboard instantiateViewControllerWithIdentifier:@"WaitingRoom"];
			controller.view.frame = CGRectMake(0, 0, controller.view.frame.size.width, controller.view.frame.size.height);
			[self addChildViewController:controller];
			[self.view addSubview:controller.view];
		}
		
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		NSLog(@"[HTTPClient Error]: %@", error.localizedDescription);
	}];

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
@end
