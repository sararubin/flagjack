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

@interface FJWaitingRoomViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *playerTableView;
@property BOOL refreshed;

- (IBAction)refreshPlayerList:(id)sender;

-(void) getPlayerList;

@end
