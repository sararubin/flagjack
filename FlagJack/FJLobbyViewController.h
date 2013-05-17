//
//  FJFirstViewController.h
//  FlagJack
//
//  Created by Ian Guerin on 4/2/13.
//  Copyright (c) 2013 Guerin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFHTTPClient.h"
#import "FJGlobalData.h"


//this class controls the join game screen
@interface FJLobbyViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *joinButton;
@property (weak, nonatomic) IBOutlet UIButton *createButton;
@property (weak, nonatomic) IBOutlet UITextField *gameCodeTextField;

- (IBAction)joinGame:(id)sender;
- (IBAction)createGame:(id)sender;

- (void) moveJoinButtonUp: (BOOL) up;
- (BOOL)textFieldShouldReturn:(UITextField *)textField;
@end
