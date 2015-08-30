//
//  CharacterInformation.h
//  WoW_TestYourProwess
//
//  Created by Anton lopez on 6/11/15.
//  Copyright (c) 2015 Anton lopez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import  <UIKit/UIKit.h>
#import "Items.h"

enum StatTypes {
    STATS_ATTRIBUTES,
    STATS_ENHANCEMENTS,
    STATS_ATTACK,
    STATS_SPELL,
    STATS_DEFENCE
};

enum SpecTypes {
    SPEC_WAR_FURY,
    SPEC_WAR_ARMS,
    SPEC_WAR_PROT,
    
    SPEC_LOCK_AFF,
    SPEC_LOCK_DEM,
    SPEC_LOCK_DEST,
    
    SPEC_SHAM_ELE,
    SPEC_SHAM_ENH,
    SPEC_SHAM_RESTO,
    
    SPEC_ROGUE_ASS,
    SPEC_ROGUE_COMB,
    SPEC_ROGUE_SUB,
    
    SPEC_PRIEST_DISC,
    SPEC_PRIEST_HOLY,
    SPEC_PRIEST_SHADOW,
  
    SPEC_PALY_HOLY,
    SPEC_PALY_PROT,
    SPEC_PALY_RET,
    
    SPEC_MONK_BREW,
    SPEC_MONK_MIST,
    SPEC_MONK_WIND,
    
    SPEC_MAGE_ARC,
    SPEC_MAGE_FIRE,
    SPEC_MAGE_FROST,
    
    SPEC_HUNT_BM,
    SPEC_HUNT_MARK,
    SPEC_HUNT_SUR,
    
    SPEC_DRUID_BOOM,
    SPEC_DRUID_FER,
    SPEC_DRUID_GUAR,
    SPEC_DRUID_RESTO,
    
    SPEC_DK_BLOOD,
    SPEC_DK_FROST,
    SPEC_DK_UNHOLY
};

@interface CharacterInformation : NSObject
{
    NSString* szCharacterName;
    NSString* szRealmName;
    UIImage* imageThumbnail;
    NSMutableDictionary* dictStats;
    NSArray* statsArray;
    NSString* szClass;
    NSString* szSpec;
    UIColor* cClassColor;
    int specEnum;
}
@property int level;
@property Items* gearItems;

-(void)reset;

//////// Mutatores /////////
-(void)setClass: (int)nclass;
-(void)setName: (NSString*)name;
-(void)setRealm: (NSString*)realm;
-(void)setThumbnail: (UIImage*)img;
-(void)setStats: (NSMutableDictionary*)stats;
-(void)setSpec: (NSString*)spec;

//////// Accesors /////////
-(NSString*)getClass;
-(NSString*)getCharName;
-(NSString*)getRealmName;
-(UIImage*)getThumbnail;
-(NSMutableDictionary*)getStats;
-(NSArray*)getDisplayStats;
-(NSString*)getSpec;
-(UIColor*)getClassColor;
-(int)getSpecEnum;

@end
