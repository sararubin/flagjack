//
//  FJDisclosureViewController.h
//  FlagJack
//
//  Created by Ian Guerin on 5/5/13.
//  Copyright (c) 2013 Guerin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FJGlobalData.h"

@interface FJDisclosureViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>

- (IBAction)takeMeBack:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *freezeButton;
@property (strong, nonatomic) IBOutlet UILabel *playerName;
@property (strong, nonatomic) IBOutlet UIPickerView *picker;
@property NSMutableArray* enemies;
@property NSMutableArray* enemyIds;
- (IBAction)freezeSomeone:(id)sender;

@end
