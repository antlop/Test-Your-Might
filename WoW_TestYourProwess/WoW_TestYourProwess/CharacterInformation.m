//
//  CharacterInformation.m
//  WoW_TestYourProwess
//
//  Created by Anton lopez on 6/11/15.
//  Copyright (c) 2015 Anton lopez. All rights reserved.
//

#import "CharacterInformation.h"

@implementation CharacterInformation

- (instancetype)init
{
    self = [super init];
    if (self) {
        _gearItems = [[Items alloc]init];
    }
    return self;
}

-(void)reset
{
    
    szCharacterName = @"";
    szRealmName = @"";
    imageThumbnail = nil;
    dictStats = nil;
    statsArray = nil;
    szClass = @"";
    szSpec = @"";
    cClassColor = nil;
    _level = 1;
}

//////// Mutatores /////////
-(void)setClass:(int)nclass
{

    switch (nclass) {
        case 1:
            szClass = @"Warrior";
            cClassColor = [UIColor brownColor];
            return;
            
        case 2:
            szClass = @"Paladin";
            cClassColor = [UIColor colorWithRed:1.0 green:0.0 blue:1.0 alpha:1.0];
            return;
            
        case 3:
            szClass = @"Hunter";
            cClassColor = [UIColor greenColor];
            return;
            
        case 4:
            szClass = @"Rogue";
            cClassColor = [UIColor yellowColor];
            return;
            
        case 5:
            szClass = @"Priest";
            cClassColor = [UIColor whiteColor];
            return;
            
        case 6:
            szClass = @"Death Knight";
            cClassColor = [UIColor colorWithRed:1 green:0.0 blue:0.1 alpha:1.0];
            return;
            
        case 7:
            szClass = @"Shaman";
            cClassColor = [UIColor blueColor];
            return;
            
        case 8:
            szClass = @"Mage";
            cClassColor = [UIColor colorWithRed:0.0 green:1.0 blue:1.0 alpha:1.0];
            return;
            
        case 9:
            szClass = @"Warlock";
            cClassColor = [UIColor purpleColor];
            return;
            
        case 10:
            szClass = @"Monk";
            cClassColor = [UIColor colorWithRed:50/255 green:1.0 blue:116/255 alpha:1.0];
            return;
            
        case 11:
            szClass = @"Druid";
            cClassColor = [UIColor orangeColor];
            return;
    }
}
-(void)setName: (NSString*)name
{
    szCharacterName = name;
}
-(void)setRealm: (NSString*)realm
{
    szRealmName = realm;
}
-(void)setThumbnail: (UIImage*)img
{
    imageThumbnail = img;
}
-(void)setStats: (NSMutableDictionary*)stats
{
    dictStats = stats;
    [self generateStats:stats];
}
-(void)setSpec:(NSString *)spec
{
    szSpec = spec;
    if( [spec isEqualToString:@"Holy"] )
    {
        if([szClass isEqualToString:@"Paladin"])
        {
            specEnum = SPEC_PALY_HOLY;
        }
        else if( [szClass isEqualToString:@"Priest"])
        {
            specEnum = SPEC_PRIEST_HOLY;
        }
    }
    else if( [spec isEqualToString:@"Retribution"])
        specEnum = SPEC_PALY_RET;
    
    else if( [spec isEqualToString:@"Beast Mastery"])
        specEnum = SPEC_HUNT_BM;
    else if( [spec isEqualToString:@"Survival"])
        specEnum = SPEC_HUNT_SUR;
    else if( [spec isEqualToString:@"Marksmanship"])
        specEnum = SPEC_HUNT_MARK;
    
    else if( [spec isEqualToString:@"Arms"])
        specEnum = SPEC_WAR_ARMS;
    else if( [spec isEqualToString:@"Fury"])
        specEnum = SPEC_WAR_FURY;
    else if( [spec isEqualToString:@"Protection"])
    {
        if( [szClass isEqualToString:@"Warrior"])
            specEnum = SPEC_WAR_PROT;
        else if( [szClass isEqualToString:@"Paladin"])
            specEnum = SPEC_PALY_PROT;
    }
    
    else if( [spec isEqualToString:@"Affliction"])
        specEnum = SPEC_LOCK_AFF;
    else if( [spec isEqualToString:@"Demonology"])
        specEnum = SPEC_LOCK_DEM;
    else if( [spec isEqualToString:@"Destruction"])
        specEnum = SPEC_LOCK_DEST;
    
    else if( [spec isEqualToString:@"Elemental"])
        specEnum = SPEC_SHAM_ELE;
    else if( [spec isEqualToString:@"Enhancement"])
        specEnum = SPEC_SHAM_ENH;
    else if( [spec isEqualToString:@"Restoration"])
    {
        if( [szClass isEqualToString:@"Shaman"])
            specEnum = SPEC_SHAM_RESTO;
        else if( [szClass isEqualToString:@"Druid"])
            specEnum = SPEC_DRUID_RESTO;
    }
    
    else if( [spec isEqualToString:@"Assassination"])
        specEnum = SPEC_ROGUE_ASS;
    else if( [spec isEqualToString:@"Combat"])
        specEnum = SPEC_ROGUE_COMB;
    else if( [spec isEqualToString:@"Subtlety"])
        specEnum = SPEC_ROGUE_SUB;
    
    else if( [spec isEqualToString:@"Discipline"])
        specEnum = SPEC_PRIEST_DISC;
    else if( [spec isEqualToString:@"Shadow"])
        specEnum = SPEC_PRIEST_SHADOW;
    
    
    else if( [spec isEqualToString:@"Brewmaster"])
        specEnum = SPEC_MONK_BREW;
    else if( [spec isEqualToString:@"Mistweaver"])
        specEnum = SPEC_MONK_MIST;
    else if( [spec isEqualToString:@"Windwalker"])
        specEnum = SPEC_MONK_WIND;
    
    else if( [spec isEqualToString:@"Arcane"])
        specEnum = SPEC_MAGE_ARC;
    else if( [spec isEqualToString:@"Fire"])
        specEnum = SPEC_MAGE_FIRE;
    else if( [spec isEqualToString:@"Frost"])
    {
        if( [szClass isEqualToString:@"Mage"])
            specEnum = SPEC_MAGE_FROST;
        else if( [szClass isEqualToString:@"Death Knight"])
            specEnum = SPEC_DK_FROST;
    }
    
    else if( [spec isEqualToString:@"Balance"])
        specEnum = SPEC_DRUID_BOOM;
    else if( [spec isEqualToString:@"Feral"])
        specEnum = SPEC_DRUID_FER;
    else if( [spec isEqualToString:@"Guardian"])
        specEnum = SPEC_DRUID_GUAR;
    
    else if( [spec isEqualToString:@"Blood"])
        specEnum = SPEC_DK_BLOOD;
    else if( [spec isEqualToString:@"Unholy"])
        specEnum = SPEC_DK_UNHOLY;
}



//////// Accesors /////////
-(NSString*)getClass
{
    return szClass;
}
-(NSString*)getCharName
{
    return szCharacterName;
}
-(NSString*)getRealmName
{
    return szRealmName;
}
-(UIImage*)getThumbnail
{
    return imageThumbnail;
}
-(NSMutableDictionary*)getStats
{
    return dictStats;
}

-(NSArray*)getDisplayStats
{
    return statsArray;
}
-(NSString*)getSpec
{
    return szSpec;
}

-(UIColor*)getClassColor
{
    return cClassColor;
}
-(int)getSpecEnum
{
    return specEnum;
}

-(void)generateStats:(NSMutableDictionary*)stats
{
    // attribute Stats
    NSMutableDictionary* attributes = [[NSMutableDictionary alloc] init];
    
    [attributes setObject:[stats objectForKey:@"str"] forKey:@"Strength"];
    [attributes setObject:[stats objectForKey:@"agi"] forKey:@"Agility"];
    [attributes setObject:[stats objectForKey:@"int"] forKey:@"Intellect"];
    [attributes setObject:[stats objectForKey:@"sta"] forKey:@"Stamina"];
    
    
    // enhancement Stats
    NSMutableDictionary* enhancements = [[NSMutableDictionary alloc] init];
    
    [enhancements setObject:[stats objectForKey:@"crit"] forKey:@"Crit"];
    [enhancements setObject:[stats objectForKey:@"haste"] forKey:@"Haste"];
    [enhancements setObject:[stats objectForKey:@"mastery"] forKey:@"Mastery"];
    [enhancements setObject:[stats objectForKey:@"spr"] forKey:@"Spirit"];
    [enhancements setObject:[stats objectForKey:@"bonusArmor"] forKey:@"Bonus Armor"];
    [enhancements setObject:[stats objectForKey:@"multistrike"] forKey:@"Multistrike"];
    [enhancements setObject:[stats objectForKey:@"leech"] forKey:@"Leech"];
    [enhancements setObject:[stats objectForKey:@"versatility"] forKey:@"Versatility"];
    [enhancements setObject:[stats objectForKey:@"avoidanceRatingBonus"] forKey:@"Avoidance"];
    
    
    // attack Stats
    NSMutableDictionary* attacks = [[NSMutableDictionary alloc] init];
    
    [attacks setObject:[stats objectForKey:@"mainHandDmgMin"] forKey:@"Main-Hand Min Dmg"];
    [attacks setObject:[stats objectForKey:@"mainHandDmgMax"] forKey:@"Main-Hand Max Dmg"];
    [attacks setObject:[stats objectForKey:@"mainHandSpeed"] forKey:@"Main-Hand Speed"];
    
    [attacks setObject:[stats objectForKey:@"offHandDmgMin"] forKey:@"Off-Hand Min Dmg"];
    [attacks setObject:[stats objectForKey:@"offHandDmgMax"] forKey:@"Off-Hand Max Dmg"];
    [attacks setObject:[stats objectForKey:@"offHandSpeed"] forKey:@"Off-Hand Speed"];
    
    [attacks setObject:[stats objectForKey:@"rangedDmgMin"] forKey:@"Ranged Min Dmg"];
    [attacks setObject:[stats objectForKey:@"rangedDmgMax"] forKey:@"Ranged Max Dmg"];
    [attacks setObject:[stats objectForKey:@"rangedSpeed"] forKey:@"Ranged Speed"];
    [attacks setObject:[stats objectForKey:@"attackPower"] forKey:@"Attack Power"];
    [attacks setObject:[stats objectForKey:@"rangedAttackPower"] forKey:@"Ranged Power"];
    
    
    // spell Stats
    NSMutableDictionary* spells = [[NSMutableDictionary alloc] init];
    
    [spells setObject:[stats objectForKey:@"spellPower"] forKey:@"Spell Power"];
    [spells setObject:[stats objectForKey:@"mana5"] forKey:@"Mana Regen"];
    [spells setObject:[stats objectForKey:@"mana5Combat"] forKey:@"Combat Regen"];
    
    
    // defence Stats
    NSMutableDictionary* defences = [[NSMutableDictionary alloc] init];
    
    [defences setObject:[stats objectForKey:@"armor"] forKey:@"Armor"];
    [defences setObject:[stats objectForKey:@"dodge"] forKey:@"Dodge"];
    [defences setObject:[stats objectForKey:@"parry"] forKey:@"Parry"];
    [defences setObject:[stats objectForKey:@"block"] forKey:@"Block"];
    
    statsArray = [[NSArray alloc] initWithObjects:attributes, enhancements, attacks, spells, defences, nil];
}


@end
