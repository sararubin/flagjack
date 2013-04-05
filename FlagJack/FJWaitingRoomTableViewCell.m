//
//  FJWaitingRoomTableViewCell.m
//  FlagJack
//
//  Created by Ian Guerin on 4/4/13.
//  Copyright (c) 2013 Guerin. All rights reserved.
//

#import "FJWaitingRoomTableViewCell.h"

@implementation FJWaitingRoomTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (IBAction)changePlayerType:(UISegmentedControl *)sender {
	
	UITableViewCell* cell = (UITableViewCell*)[[sender superview] superview];
	UITableView* table = (UITableView*)[cell superview];
	NSIndexPath* indexPath = [table indexPathForCell:cell];
	int row = [indexPath row];
	
	if([[[[FJGlobalData shared] playerTeamColors] objectAtIndex:row] isEqualToString: @"orange"] && sender.selectedSegmentIndex == 1){//orange
		[[FJGlobalData shared] setOrangeCaptainId:[[[[FJGlobalData shared] playerIds] objectAtIndex:row] integerValue]];
	} else if(sender.selectedSegmentIndex == 1){//blue
		[[FJGlobalData shared] setBlueCaptainId:[[[[FJGlobalData shared] playerIds] objectAtIndex:row] integerValue]];
	} else if([[[[FJGlobalData shared] playerTeamColors] objectAtIndex:row] isEqualToString: @"orange"] && sender.selectedSegmentIndex == 0){//orange
		[[FJGlobalData shared] setOrangeCaptainId:0];
	} else if(sender.selectedSegmentIndex == 0){//blue
		[[FJGlobalData shared] setBlueCaptainId:0];
	}
	
	//knock out everyone else, color specific
	NSArray* paths = [table indexPathsForVisibleRows];
	for(int i = 0; i < paths.count; i++){
		if([[paths objectAtIndex:i] row] != row){
			int aRow = [[paths objectAtIndex:i] row];
			if([[[[FJGlobalData shared] playerTeamColors] objectAtIndex:row] isEqualToString: @"orange"] && [[[[FJGlobalData shared] playerTeamColors] objectAtIndex:aRow] isEqualToString: @"orange"]){
				FJWaitingRoomTableViewCell* aCell = (FJWaitingRoomTableViewCell*)[table cellForRowAtIndexPath:[paths objectAtIndex:i]];
				aCell.playerType.selectedSegmentIndex = 0;
			} else if([[[[FJGlobalData shared] playerTeamColors] objectAtIndex:row] isEqualToString: @"blue"] && [[[[FJGlobalData shared] playerTeamColors] objectAtIndex:aRow] isEqualToString: @"blue"]){
				FJWaitingRoomTableViewCell* aCell = (FJWaitingRoomTableViewCell*)[table cellForRowAtIndexPath:[paths objectAtIndex:i]];
				aCell.playerType.selectedSegmentIndex = 0;
			}
			
		}
		
	}
	
	//tell myself that I am the captain
	if(row == [[[FJGlobalData shared] playerIds] indexOfObject:[NSString stringWithFormat:@"%d",[[FJGlobalData shared] myId]]] ){
		if(sender.selectedSegmentIndex == 1){
			[[FJGlobalData shared] setIsCaptain:YES];
		} else{
			[[FJGlobalData shared] setIsCaptain:NO];
		}
	}
	
	
	//make me the captain
	//make anyone else who says captain, be a normal player
	//first orange should be captain, first blue should be captain
	
}
@end
