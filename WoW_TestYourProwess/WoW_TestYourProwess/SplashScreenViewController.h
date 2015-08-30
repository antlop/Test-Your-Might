//
//  SplashScreenViewController.h
//  WoW_TestYourProwess
//
//  Created by Anton lopez on 6/23/15.
//  Copyright (c) 2015 Anton lopez. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "Reachability.h"

@interface SplashScreenViewController : UIViewController
{
    CGRect mightFinal;
    CGRect yourFinal;
    CGRect BGFinal;
    NSDate* previousDateForTimestep;
    double dBGBucket;
    NSTimer* bgTimer;
    BOOL shouldTransition;
}
@property (weak, nonatomic) IBOutlet UIImageView *imageTestYou;
@property (weak, nonatomic) IBOutlet UIImageView *imageMight;
@property (weak, nonatomic) IBOutlet UIImageView *imageWorldBG;
@property (weak, nonatomic) IBOutlet UIImageView *imageCracks;


//@property (nonatomic) Reachability *hostReachability;
//@property (nonatomic) Reachability *internetReachability;
//@property (nonatomic) Reachability *wifiReachability;


@end
