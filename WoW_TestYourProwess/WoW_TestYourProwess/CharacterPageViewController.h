//
//  CharacterPageViewController.h
//  WoW_TestYourProwess
//
//  Created by Anton lopez on 6/11/15.
//  Copyright (c) 2015 Anton lopez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "CharacterInformation.h"
#import "StatsTableViewController.h"
#import "item.h"
#import "ItemDetailViewController.h"

@interface CharacterPageViewController : UIViewController <UIAlertViewDelegate>
{
    IBOutlet UIImageView* imageProfileMain;                 // character screen cap
    IBOutlet UILabel* labelCharacterName;         
    IBOutlet UIBarButtonItem* navButtonBattle;
    IBOutlet UIView* selectionView;
    IBOutlet UIButton* grpSelectionButton;
    IBOutlet UIButton* allOtherButton;
    IBOutlet UIActivityIndicatorView *activityLoading;
    
    UILabel* labelSelectCharacter;
    NSString* szThumbnailPath;
    
    CharacterInformation* myCharacter;
    
    StatsTableViewController* tableViewStats;
    
    bool boolDidLoad;                                       // do not want to re-add subviews
    bool boolHaveCharInfo;                                  // do I already have a character?
    
    ItemDetailViewController *itemInfoView;
    
    NSMutableArray* sounds;
}

@end
