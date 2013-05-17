//
//  FJNameYourselfViewController.h
//  FlagJack
//
//  Created by Ian Guerin on 4/3/13.
//  Copyright (c) 2013 Guerin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFHTTPClient.h"
#import "FJGlobalData.h"

//this method allows for players to give themselves a custom name
@interface FJNameYourselfViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *nameYourselfTextField;
- (IBAction)toWaitingRoomButton:(id)sender;
@end
