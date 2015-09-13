//
//  CalibrationViewController.h
//  
//
//  Created by Kyle Sandell on 8/23/15.
//
//

#import <UIKit/UIKit.h>
#import "structs.h"
#import "SwipeRecognition.h"
#import <Foundation/Foundation.h>
@interface CalibrationViewController : UIViewController
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
