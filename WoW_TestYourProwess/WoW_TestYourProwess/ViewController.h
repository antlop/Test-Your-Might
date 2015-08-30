//
//  ViewController.h
//  WoW_TestYourProwess
//
//  Created by Anton lopez on 6/11/15.
//  Copyright (c) 2015 Anton lopez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@interface ViewController : UIViewController
{
    IBOutlet UITextField* textField_CharacterName; 
    IBOutlet UIPickerView* picker_Server;
    IBOutlet UIImageView *imageBGForTextField;
    IBOutlet UIButton *buttonForSelection;
    
    CGAffineTransform txtTrans;
    CGAffineTransform pickerTrans;
    CGAffineTransform bgTrans;
    CGAffineTransform btnTrans;
    CGAffineTransform imgTrans;
    
    AVAudioPlayer* shakePlayer;
    UIImageView* selectorImage;
}

// not yet implemented: will login using OAuth 2.0
-(IBAction)login:(id)sender;


//called when the user clicks the "Load" button
-(IBAction)downloadCharacterButtonClicked:(id)sender;

@end

