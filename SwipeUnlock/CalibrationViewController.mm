//
//  CalibrationViewController.m
//  
//
//  Created by Kyle Sandell on 8/23/15.
//
//

#import "CalibrationViewController.h"

@interface CalibrationViewController ()

@end

@implementation CalibrationViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    NSString *alertString=@"Hold your phone how you normally would and then proceed to swipe the screen the same way you would to unlock your phone 10 times";
    // Do any additional setup after loading the view.
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Swipe Recognition" message:alertString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:NULL, nil];
    [alert show];

    self.first=false;
    self.count=0;
    self.defaults=[NSUserDefaults standardUserDefaults];
    [self.defaults setBool:NO forKey:@"Calibration Complete"];
    [self.defaults synchronize];
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
    SwipeRecognizer *rec=[[SwipeRecognizer alloc] init];
    if(!self.first)
    {
        [rec initialTrainNetwork:self.pointsArray xVelocities:self.xVelocityArray yVelocities:self.yVelocityArray];
        self.first=true;
    }
    else
    {
        [rec trainNetwork:self.pointsArray xVelocities:self.xVelocityArray yVelocities:self.yVelocityArray];
    }
    if(self.count==10)
    {
        [rec saveNetwork];
    }
    [self.defaults setBool:YES forKey:@"Calibration Complete"];
    [self.defaults synchronize];
    [self performSegueWithIdentifier:@"CalibrationComplete" sender:self];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
