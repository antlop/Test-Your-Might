//
//  StatGroupSelectionView.h
//  WoW_TestYourProwess
//
//  Created by Anton lopez on 6/18/15.
//  Copyright (c) 2015 Anton lopez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "StatsTableViewController.h"

@interface StatGroupSelectionView : UIView
{
    BOOL bShouldShow;
    int nSelectedGroup;
    AVAudioPlayer* clickSoundPlayer;
}

-(BOOL)buttonWasPressed:(StatsTableViewController*)table;

-(IBAction)selectedStatGroup:(id)sender;
@end
