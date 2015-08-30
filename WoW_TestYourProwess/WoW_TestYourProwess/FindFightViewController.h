//
//  FindFightViewController.h
//  WoW_TestYourProwess
//
//  Created by Anton lopez on 6/12/15.
//  Copyright (c) 2015 Anton lopez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>
#import "CharacterInformation.h"

@interface FindFightViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate, MCSessionDelegate, MCBrowserViewControllerDelegate, UITextFieldDelegate>
{
    IBOutlet UITextField* textfieldNameOfOpponant;
}

// store the player characters information
#warning think about making this a singleton (only ever need/want 1)
@property (strong, nonatomic) CharacterInformation* playersCharacter;

@property (nonatomic, strong) MCBrowserViewController *browserVC;
@property (nonatomic, strong) MCAdvertiserAssistant *advertiser;
@property (nonatomic, strong) MCSession *mySession;
@property (nonatomic, strong) MCPeerID *myPeerID;

-(IBAction)findMyOpponant:(id)sender;
-(CharacterInformation*)loadEnemyCharacter;

@end
