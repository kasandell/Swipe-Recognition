//
//  SwipeUnlockViewController.m
//  
//
//  Created by Kyle Sandell on 8/23/15.
//
//

#import "SwipeUnlockViewController.h"

#include "structs.h"
@interface SwipeUnlockViewController ()
@property SwipeRecognizer *recognizer;

@property double startmillis;
@property double lastmillis;
@property double currentmillis;
@property double finalmillis;
@property CGPoint lastPoint;
@property CGPoint currentPoint;
@property NSMutableArray *pointsArray;
@property NSMutableArray *xVelocityArray;
@property NSMutableArray *yVelocityArray;
@property NSUserDefaults *defaults;
@property bool first;
@property int count;
@end

@implementation SwipeUnlockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.recognizer init];
    [self.recognizer loadNetworkWeights];
    // Do any additional setup after loading the view.
    self.first=false;
    self.count=0;
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.startmillis=time(NULL);
    self.currentmillis=self.startmillis;
    UITouch *touch=[touches anyObject];
    self.currentPoint=[touch locationInView:self.view];
    [self.pointsArray addObject:[NSValue valueWithCGPoint:self.currentPoint]];
    self.lastPoint=[touch locationInView:self.view];
    
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.lastmillis=time(NULL);
    UITouch *touch=[touches anyObject];
    self.lastPoint=[touch locationInView:self.view];
    int deltaX=self.lastPoint.x-self.currentPoint.x;
    int deltaY=self.lastPoint.y-self.currentPoint.y;
    double deltaTime=self.lastmillis-self.currentmillis;
    struct Velocity v;
    v.vX=deltaX/deltaTime;
    v.vY=deltaY/deltaTime;
    [self.xVelocityArray addObject:[NSNumber numberWithFloat:v.vX]];
    [self.yVelocityArray addObject:[NSNumber numberWithFloat:v.vY]];
    [self.pointsArray addObject:[NSValue valueWithCGPoint:self.currentPoint]];
    self.currentPoint=self.lastPoint;
    self.currentmillis=self.lastmillis;
    
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.count++;
    self.lastmillis=time(NULL);
    UITouch *touch=[touches anyObject];
    self.lastPoint=[touch locationInView:self.view];
    int deltaX=self.lastPoint.x-self.currentPoint.x;
    int deltaY=self.lastPoint.y-self.currentPoint.y;
    double deltaTime=self.lastmillis-self.currentmillis;
    struct Velocity v;
    v.vX=deltaX/deltaTime;
    v.vY=deltaY/deltaTime;
    [self.xVelocityArray addObject:[NSNumber numberWithFloat:v.vX]];
    [self.yVelocityArray addObject:[NSNumber numberWithFloat:v.vY]];
    [self.pointsArray addObject:[NSValue valueWithCGPoint:self.currentPoint]];
    self.finalmillis=self.lastmillis-self.startmillis;
    float res=[self.recognizer querySwipe:self.pointsArray xVelocities:self.xVelocityArray yVelocities:self.yVelocityArray];
    if(res>.92)
    {
        
        UIAlertView *successAlert=[[UIAlertView alloc] initWithTitle:@"SUCCESS" message:@"Recognized Your Swipe" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [successAlert show];
    }
    else{
        
        UIAlertView *notRecognized=[[UIAlertView alloc] initWithTitle:@"Unrecognized" message:@"Did Not Recognize Your Swipe. Please Try Again" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [notRecognized show];
    }

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
