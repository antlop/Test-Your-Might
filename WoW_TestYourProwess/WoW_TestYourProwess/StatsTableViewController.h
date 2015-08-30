//
//  StatsTableViewController.h
//  WoW_TestYourProwess
//
//  Created by Anton lopez on 6/11/15.
//  Copyright (c) 2015 Anton lopez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StatsTableViewController : UITableViewController
{
    NSMutableArray* keys;
    NSArray* statsArray;
}

@property NSMutableDictionary* characterStats;
@property int group;

-(instancetype)init: (CGRect)rect withOriginalStatsDictionary: (NSArray*)stats;

@end
