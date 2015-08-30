//
//  item.m
//  WoW_TestYourProwess
//
//  Created by Anton lopez on 6/19/15.
//  Copyright (c) 2015 Anton lopez. All rights reserved.
//

#import "item.h"

@implementation item

- (instancetype)initWithName: (NSString*)name image:(UIImage*)szImage itemLvl: (int)iLvl armor:(int)nArmor
{
    self = [super init];
    if (self) {
        _szName = name;
        _nItemLvl = iLvl;
        _nArmor = nArmor;
        _icon = szImage;
    }
    return self;
}

@end
