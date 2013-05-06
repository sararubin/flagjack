//
//  FJGlobalData.m
//  FlagJack
//
//  Created by Ian Guerin on 4/3/13.
//  Copyright (c) 2013 Guerin. All rights reserved.
//

#import "FJGlobalData.h"

@implementation FJGlobalData

static FJGlobalData *shared = nil;
NSString *authCode = @"&&^#guer16n";

+ (FJGlobalData *)shared {
    if (shared == nil) {
        shared = [[super allocWithZone:NULL] init];
    }
	
    return shared;
}

-(void) unfreeze{
	[self setIsFrozen:NO];
	//afnetworking post data
	NSURL *urlForPost = [NSURL URLWithString:@"http://lolliproject.com/flagjack/set-player-frozen.php"];
	AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:urlForPost];
	
	NSString *authCode = @"&&^#guer16n";
	NSString *freezeTime = [NSString stringWithFormat:@"%D",0];
	NSString *idString = [NSString stringWithFormat:@"%d",[[FJGlobalData shared] idToDisclose]];
	
	
	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys: authCode, @"authorize", freezeTime, @"freezeTime", idString, @"freezeId", nil];
	
	[httpClient postPath:@"" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
		NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
		if([responseStr isEqualToString:@"failure"]){
			NSLog(@"failed to save name");
		}else{
			//unfroze in the eyes of the database
		}
		
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		NSLog(@"[HTTPClient Error]: %@", error.localizedDescription);
	}];

}

@end
