//
//  item.h
//  WoW_TestYourProwess
//
//  Created by Anton lopez on 6/19/15.
//  Copyright (c) 2015 Anton lopez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface item : NSObject

@property NSString* szName;
@property UIImage* icon;
@property int nItemLvl;
@property int nArmor;


- (instancetype)initWithName: (NSString*)name image:(UIImage*)szImage itemLvl: (int)iLvl armor:(int)nArmor;

@end
