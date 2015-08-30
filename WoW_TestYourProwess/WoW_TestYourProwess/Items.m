//
//  Items.m
//  WoW_TestYourProwess
//
//  Created by Anton lopez on 6/19/15.
//  Copyright (c) 2015 Anton lopez. All rights reserved.
//

#import "Items.h"
#import "item.h"

@implementation Items

- (instancetype)init
{
    self = [super init];
    if (self) {
  //      _arrayItems = [NSArray alloc] init
        NSMutableArray* arr = [[NSMutableArray alloc] init];
        for( int i = 0; i < MAX_NUM_SLOTS; ++i)
        {
            item *temp = [[item alloc]init];
            [arr addObject:temp];
        }
        
        _arrayItems = [[NSArray alloc] initWithArray:arr];
    }
    return self;
}

@end
