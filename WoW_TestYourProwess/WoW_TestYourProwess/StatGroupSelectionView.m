//
//  StatGroupSelectionView.m
//  WoW_TestYourProwess
//
//  Created by Anton lopez on 6/18/15.
//  Copyright (c) 2015 Anton lopez. All rights reserved.
//

#import "StatGroupSelectionView.h"

@implementation StatGroupSelectionView

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        bShouldShow = false;
        nSelectedGroup = 0;
        
        NSString *clickSFXPath = [[NSBundle mainBundle] pathForResource:@"clicked" ofType:@"wav"];
        NSURL* clickSFXURL = [NSURL fileURLWithPath:clickSFXPath];
        clickSoundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:clickSFXURL error:nil];
        clickSoundPlayer.numberOfLoops = 0;
    }
    return self;
}


-(BOOL)buttonWasPressed:(StatsTableViewController*)table
{
    bShouldShow = !bShouldShow;
    if(bShouldShow)
    {
        [self openMe: table];
    }
    else
    {
        [self closeMe: table];
    }
    return bShouldShow;
}
-(void)closeMe:(StatsTableViewController*)table
{
    
    //CGRectMake(16, 250, self.view.frame.size.width - 32, 265)
    
    [UIView animateWithDuration:0.5 animations:^{
        CGRect r = self.frame;
        r.size.height = 0;
        self.frame = r;
        
        table.view.frame = CGRectMake(60, 250, self.superview.frame.size.width - 120, 265);
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}
-(void)openMe:(StatsTableViewController*)table
{
    self.hidden = NO;
    [UIView animateWithDuration:0.5 animations:^{
        CGRect r = self.frame;
        r.size.height = 140;
        self.frame = r;
        
        table.view.frame = CGRectMake(60, 390, self.superview.frame.size.width - 120, 125);
    }];
}


-(IBAction)selectedStatGroup:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SELECTED_STAT_GROUP" object:[NSNumber numberWithInt:[sender tag]]];
    [clickSoundPlayer play];
}

@end
