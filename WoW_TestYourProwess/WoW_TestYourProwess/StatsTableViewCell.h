//
//  StatsTableViewCell.h
//  WoW_TestYourProwess
//
//  Created by Anton lopez on 6/11/15.
//  Copyright (c) 2015 Anton lopez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CharacterInformation.h"

@interface StatsTableViewCell : UITableViewCell
{
    UILabel* infoLabel;
}

-(BOOL)setInfo: (NSMutableDictionary*)stats atIndex: (int)index;

@end
