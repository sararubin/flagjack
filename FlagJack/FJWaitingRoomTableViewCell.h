//
//  FJWaitingRoomTableViewCell.h
//  FlagJack
//
//  Created by Ian Guerin on 4/4/13.
//  Copyright (c) 2013 Guerin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FJGlobalData.h"

@interface FJWaitingRoomTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *playerName;
@property (weak, nonatomic) IBOutlet UISegmentedControl *playerType;

- (IBAction)changePlayerType:(UISegmentedControl *)sender;

	
@end
