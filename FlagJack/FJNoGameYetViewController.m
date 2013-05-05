//
//  FJNoGameYetViewController.m
//  FlagJack
//
//  Created by Ian Guerin on 4/9/13.
//  Copyright (c) 2013 Guerin. All rights reserved.
//

#import "FJNoGameYetViewController.h"
#import "FJGlobalData.h"

@interface FJNoGameYetViewController ()

@end

@implementation FJNoGameYetViewController

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

- (void)viewDidAppear:(BOOL)animated{
	if([[FJGlobalData shared] gameHasStarted]){
		[self viewMap];
	}else{
		//game hasn't started yet
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewMap{
    UIViewController* controller = [self.storyboard instantiateViewControllerWithIdentifier:@"Map"];
    controller.view.frame = CGRectMake(0, 0, controller.view.frame.size.width, controller.view.frame.size.height);
    [self addChildViewController:controller];
    [self.view addSubview:controller.view];
}
@end
