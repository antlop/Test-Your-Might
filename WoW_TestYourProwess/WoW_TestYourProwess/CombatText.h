//
//  CombatText.h
//  WoW_TestYourProwess
//
//  Created by Anton lopez on 6/18/15.
//  Copyright (c) 2015 Anton lopez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@interface CombatText : NSObject
{
    AVAudioPlayer* hitPlayer;
}

@property BOOL deleteME;
@property (strong, nonatomic) UILabel* text;

-(void)updateMe:(double)deltaTime;

- (instancetype)initWithPosX:(float)posX andPosY: (float)posY;

@end
