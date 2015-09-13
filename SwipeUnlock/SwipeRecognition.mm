//
//  SwipeRecognition.m
//  
//
//  Created by Kyle Sandell on 8/23/15.
//
//
#ifndef SWIPE_RECOGNITION_MM
#define SWIPE_RECOGNITION_MM
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#include "structs.h"
#include "SwipeRecognition.h"

#include <fann.h>

using namespace std;//obj-c++ cuz why not



@implementation SwipeRecognizer

-(void)loadUserDefaults
{
    self.defaults=[NSUserDefaults standardUserDefaults];
}


-(void)initialTrainNetwork:(NSArray *)points xVelocities:(NSArray *)xVelocArray yVelocities:(NSArray *)yVelocArray//create and train the network
{
    srand(time(NULL));
    //train the network and save the resulting weights and biases to a file for loading later
    const unsigned int num_input = 4;
    const unsigned int num_output = 1;
    const unsigned int num_layers = 2;
    const unsigned int num_neurons_hidden = 20;
    const float desired_error = (const float) 0.001;
    const unsigned int max_epochs = 500000;
    const unsigned int epochs_between_reports = 1000;
    
    self.ann = fann_create_standard(num_layers, num_input, num_neurons_hidden, num_output);
    
    fann_set_activation_function_hidden(self.ann, FANN_SIGMOID_SYMMETRIC);
    fann_set_activation_function_output(self.ann, FANN_SIGMOID_SYMMETRIC);
    
   
    [self.defaults synchronize];
    
    vector<float> inputs;
    vector<float> expected;
    int ps=points.count;
    int xs=xVelocArray.count;
    int ys=yVelocArray.count;
    int lowest=0;
    if(ps<xs)
    {
        lowest=ps;
    }
    else
    {
        lowest=xs;
    }
    
    if(lowest>ys)
    {
        lowest=ys;
    }
    
    for(int x=0;x<lowest;x++)
    {
        CGPoint p=[[points objectAtIndex:x] CGPointValue];
        fann_type input[4];
        fann_type expected[1];
        expected[0]=1.000;
        input[0]=p.x;
        input[1]=p.y;
        input[2]=[[xVelocArray objectAtIndex:x] floatValue];
        input[3]=[[yVelocArray objectAtIndex:x] floatValue];
        fann_train(self.ann, input, expected);
    }
    
    
}
-(void)trainNetwork:(NSArray *)points xVelocities:(NSArray *)xVelocArray yVelocities:(NSArray *)yVelocArray//continue to train the network
{
    vector<float> inputs;
    vector<float> expected;
    int ps=points.count;
    int xs=xVelocArray.count;
    int ys=yVelocArray.count;
    int lowest=0;
    if(ps<xs)
    {
        lowest=ps;
    }
    else
    {
        lowest=xs;
    }
    
    if(lowest>ys)
    {
        lowest=ys;
    }
    
    for(int x=0;x<lowest;x++)
    {
        CGPoint p=[[points objectAtIndex:x] CGPointValue];
        fann_type input[4];
        fann_type expected[1];
        expected[0]=1.000;
        input[0]=p.x;
        input[1]=p.y;
        input[2]=[[xVelocArray objectAtIndex:x] floatValue];
        input[3]=[[yVelocArray objectAtIndex:x] floatValue];
        fann_train(self.ann, input, expected);
    }

}


-(void)saveNetwork//save the network to a file
{
    fann_save(self.ann, "swipe_recognition.net");
}

-(void)loadNetworkWeights//load the network from a file
{
    self.ann=fann_create_from_file("swipe_recognition.net");
}

-(float)querySwipe:(NSArray *)points xVelocities:(NSArray *)xVelocArray yVelocities:(NSArray *)yVelocArray//get similarity of a swipe
{
    
    
    vector<float> outputs;
    int ps=points.count;
    int xs=xVelocArray.count;
    int ys=yVelocArray.count;
    int lowest=0;
    if(ps<xs)
    {
        lowest=ps;
    }
    else
    {
        lowest=xs;
    }
    
    if(lowest>ys)
    {
        lowest=ys;
    }
    for(int i=0; i<lowest; i++)
    {
        CGPoint p=[[points objectAtIndex:i] CGPointValue];
        
        fann_type inputs[4];
        fann_type *output;
        inputs[0]=p.x;
        inputs[1]=p.y;
        inputs[2]=[[xVelocArray objectAtIndex:i] floatValue];
        inputs[3]=[[yVelocArray objectAtIndex:i] floatValue];
        output=fann_run(self.ann, inputs);
        outputs.push_back(output[0]);
        
    }
    float fin=0;
    for(int x=0; x<outputs.size(); x++)
    {
        fin+=outputs[x];
    
    }
    fin/=outputs.size();
    return fin;
}

@end
#endif
