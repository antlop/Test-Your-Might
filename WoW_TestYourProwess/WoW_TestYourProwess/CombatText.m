//
//  CombatText.m
//  WoW_TestYourProwess
//
//  Created by Anton lopez on 6/18/15.
//  Copyright (c) 2015 Anton lopez. All rights reserved.
//

#import "CombatText.h"

@implementation CombatText

- (instancetype)initWithPosX:(float)posX andPosY: (float)posY
{
    self = [super init];
    if (self) {
        _deleteME = NO;
        _text = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, 100, 30)];
        
        NSString *hitSFXPath = [[NSBundle mainBundle]
                                pathForResource:@"HitSFX" ofType:@"wav"];
        NSURL *hitSFXURL = [NSURL fileURLWithPath:hitSFXPath];
        hitPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:hitSFXURL
                                                           error:nil];
        hitPlayer.numberOfLoops = 0;
        [hitPlayer prepareToPlay];
        [hitPlayer play];
    }
    return self;
}

-(void)updateMe:(double)deltaTime
{
    CGRect rect = _text.frame;

    if( rect.origin.y < -30)
        _deleteME = YES;
    else
    {
        rect.origin.y -= 100 * deltaTime;
        _text.frame = rect;
        
        [_text setAlpha:_text.alpha - deltaTime];
        
    }

}

@end
