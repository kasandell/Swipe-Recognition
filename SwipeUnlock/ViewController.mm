//
//  ViewController.m
//  SwipeUnlock
//
//  Created by Kyle Sandell on 8/23/15.
//  Copyright (c) 2015 Kyle Sandell. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property NSUserDefaults *defaults;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.defaults=[NSUserDefaults standardUserDefaults];
    BOOL fin=[self.defaults boolForKey:@"Calibration Completed"];
    if(fin==YES)
    {
        [self performSegueWithIdentifier:@"CalibrationCompleted" sender:self];
    }
    else{
        [self performSegueWithIdentifier:@"CalibrationIncomplete" sender:self];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
