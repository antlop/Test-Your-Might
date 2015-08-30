//
//  Items.h
//  WoW_TestYourProwess
//
//  Created by Anton lopez on 6/19/15.
//  Copyright (c) 2015 Anton lopez. All rights reserved.
//

#import <Foundation/Foundation.h>

enum ItemSlots {
    SLOT_HEAD,
    SLOT_NECK,
    SLOT_SHOULDER,
    SLOT_CLOAK,
    SLOT_CHEST,
    SLOT_SHIRT,
    SLOT_TABARD,
    SLOT_WRIST,
    SLOT_HANDS,
    SLOT_BELT,
    SLOT_LEGS,
    SLOT_FEET,
    SLOT_RING1,
    SLOT_RING2,
    SLOT_TRINK1,
    SLOT_TRINK2,
    MAX_NUM_SLOTS
};

@interface Items : NSObject

@property NSArray* arrayItems;

@end
