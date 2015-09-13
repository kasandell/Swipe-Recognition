//
//  SwipeRecognition.h
//  SwipeUnlock
//
//  Created by Kyle Sandell on 8/31/15.
//  Copyright (c) 2015 Kyle Sandell. All rights reserved.
//

#ifndef SwipeUnlock_SwipeRecognition_h
#define SwipeUnlock_SwipeRecognition_h

#import <Foundation/Foundation.h>
@interface SwipeRecognizer:NSObject{
  
}

@property NSUserDefaults *defaults;
@property struct fann *ann;
-(void)loadUserDefaults;
-(void)initialTrainNetwork:(NSArray *)points xVelocities:(NSArray *)xVelocArray yVelocities:(NSArray *)yVelocArray;
-(void)trainNetwork:(NSArray *)points xVelocities:(NSArray *)xVelocArray yVelocities:(NSArray *)yVelocArray;
-(void)saveNetwork;
-(void)loadNetworkWeights;
-(float)querySwipe:(NSArray *)points xVelocities:(NSArray *)xVelocArray yVelocities:(NSArray *)yVelocArray;
@end

#endif
