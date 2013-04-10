//
//  FJSecondViewController.m
//  FlagJack
//
//  Created by Ian Guerin on 4/2/13.
//  Copyright (c) 2013 Guerin. All rights reserved.
//

#import "FJSecondViewController.h"

@interface FJSecondViewController ()

@end

@implementation FJSecondViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)viewMap:(id)sender {
    UIViewController* controller = [self.storyboard instantiateViewControllerWithIdentifier:@"Map"];
    controller.view.frame = CGRectMake(0, 0, controller.view.frame.size.width, controller.view.frame.size.height);
    [self addChildViewController:controller];
    [self.view addSubview:controller.view];
}
@end
