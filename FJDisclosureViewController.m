//
//  FJDisclosureViewController.m
//  FlagJack
//
//  Created by Ian Guerin on 5/5/13.
//  Copyright (c) 2013 Guerin. All rights reserved.
//

#import "FJDisclosureViewController.h"
#import "AFHTTPClient.h"

@interface FJDisclosureViewController ()

@end

@implementation FJDisclosureViewController

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
	_enemies = [[NSMutableArray alloc]init];
	_enemyIds = [[NSMutableArray alloc]init];
	NSString* myColor = [[FJGlobalData shared]myTeamColor];
	for(int i = 0; i < [[[FJGlobalData shared] players] count]; i++){
		if(![[[[FJGlobalData shared] playerTeamColors] objectAtIndex:i] isEqualToString:myColor]){
			[_enemyIds addObject:[[[FJGlobalData shared] playerIds] objectAtIndex:i]];
			[_enemies addObject:[[[FJGlobalData shared] players] objectAtIndex:i]];
		}
	}
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
	NSString* obj = [NSString stringWithFormat:@"%d",[[FJGlobalData shared] idToDisclose]];
	int index = [[[FJGlobalData shared] playerIds] indexOfObject:obj];
	
	
	if([[FJGlobalData shared] discloseEnemy]){
		_freezeButton.hidden = NO;
		_playerName.text = @"Who was it?";
	}else{
		_freezeButton.hidden = YES;
		_picker.hidden = YES;
		_playerName.text = [NSString stringWithFormat:@"%@",[[[FJGlobalData shared] players] objectAtIndex:index]];
	}
	
}

- (IBAction)takeMeBack:(id)sender {
	[self.view removeFromSuperview];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
	return [_enemies count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [_enemies objectAtIndex:row];
}

-(void) pickerView:(UIPickerView*)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
	//nothing to do here
}

- (IBAction)freezeSomeone:(id)sender {
	if([[FJGlobalData shared] idToDisclose] == [[_enemyIds objectAtIndex:[_picker selectedRowInComponent:0]] intValue]){
		//freeze the person, we got em
		//afnetworking post data
		NSURL *urlForPost = [NSURL URLWithString:@"http://lolliproject.com/flagjack/set-player-frozen.php"];
		AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:urlForPost];
		
		NSString *authCode = @"&&^#guer16n";
		NSString *freezeTime = [NSString stringWithFormat:@"%D",3];
		NSString *idString = [NSString stringWithFormat:@"%d",[[FJGlobalData shared] idToDisclose]];
		
		
		NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys: authCode, @"authorize", freezeTime, @"freezeTime", idString, @"freezeId", nil];
		
		[httpClient postPath:@"" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
			NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
			if([responseStr isEqualToString:@"failure"]){
				NSLog(@"failed to save name");
			}else{
				//alert them that this person has been frozen
				
			}
			
		} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
			NSLog(@"[HTTPClient Error]: %@", error.localizedDescription);
		}];
	}else{
		//whoops, you just froze yourself for cheating:/
		//afnetworking post data
		NSURL *urlForPost = [NSURL URLWithString:@"http://lolliproject.com/flagjack/set-player-frozen.php"];
		AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:urlForPost];
		
		NSString *authCode = @"&&^#guer16n";
		NSString *freezeTime = [NSString stringWithFormat:@"%D",5];
		NSString *idString = [NSString stringWithFormat:@"%d",[[FJGlobalData shared] idToDisclose]];
		
		
		NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys: authCode, @"authorize", freezeTime, @"freezeTime", idString, @"freezeId", nil];
		
		[httpClient postPath:@"" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
			NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
			if([responseStr isEqualToString:@"failure"]){
				NSLog(@"failed to save name");
			}else{
				//alert them that they have frozen themselves
				//- (void)performSelector:(SEL)aSelector withObject:(id)anArgument afterDelay:(NSTimeInterval)delay
				[[FJGlobalData shared]performSelector:@selector(unfreeze) withObject:NULL afterDelay:10];
			}
			
		} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
			NSLog(@"[HTTPClient Error]: %@", error.localizedDescription);
		}];
	}
	
}
@end
