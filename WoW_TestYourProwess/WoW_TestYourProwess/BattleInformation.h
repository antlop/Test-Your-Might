//
//  BattleInformation.h
//  WoW_TestYourProwess
//
//  Created by Anton lopez on 6/12/15.
//  Copyright (c) 2015 Anton lopez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CharacterInformation.h"

@interface BattleInformation : NSObject
{
    
}
@property (strong, nonatomic) CharacterInformation* playerCharInfo;
@property (strong, nonatomic) CharacterInformation* enemyCharInfo;

-(void)startTheFight;

@end
