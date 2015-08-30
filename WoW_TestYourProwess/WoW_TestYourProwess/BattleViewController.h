//
//  BattleViewController.h
//  WoW_TestYourProwess
//
//  Created by Anton lopez on 6/15/15.
//  Copyright (c) 2015 Anton lopez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CharacterInformation.h"
#import "CombatText.h"

@interface BattleViewController : UIViewController
{
    IBOutlet UIImageView* imageMyChampIcon;
    IBOutlet UIImageView* imageOpponentIcon;
    IBOutlet UILabel* labelMyChampName;
    IBOutlet UILabel* labelOpponentName;
    IBOutlet UITableView* tableCombat;
    IBOutlet UIProgressView* progressMyChampHealth;
    IBOutlet UIProgressView* progressOpponantHealth;
    IBOutlet UILabel* labelMyChampHP;
    IBOutlet UILabel* labelOpponentHP;
    IBOutlet UIButton* buttonStartFight;
    IBOutlet UIView* viewMyChampDamage;
    IBOutlet UIView* viewMyOpponantDamage;
    
    NSArray* keys;
    
    int playerHP;
    int opponantHP;
    
    NSTimer* playerAttackTimer;
    NSTimer* opponentAttackTimer;
    NSTimer* playerOffHandAttackTimer;
    NSTimer* opponentOffHandAttackTimer;
    NSTimer* updateTimer;
    NSTimer* playerHealTimer;
    NSTimer* opponentHealTimer;
    
    NSMutableArray* combatText;
    
    NSDate* previousDateForTimestep;
    BOOL endCombatText;
    
    AVAudioPlayer* fetalityPlayer;
    
    CGRect myChampDmgRect;
    CGRect myOppDmgRect;
    
    BOOL bFightHasStarted;
}

@property CharacterInformation* myChampInfo;
@property CharacterInformation* myOpponantInfo;

-(void)shouldLoadOpponant:(NSString*)charName inRealm: (NSString*)realmName;

@end
