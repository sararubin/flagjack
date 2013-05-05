//
//  FJDisclosureViewController.m
//  FlagJack
//
//  Created by Ian Guerin on 5/5/13.
//  Copyright (c) 2013 Guerin. All rights reserved.
//

#import "FJDisclosureViewController.h"

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)takeMeBack:(id)sender {
	[self.view removeFromSuperview];
}
@end
