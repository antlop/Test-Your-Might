//
//  SplashScreenViewController.m
//  WoW_TestYourProwess
//
//  Created by Anton lopez on 6/23/15.
//  Copyright (c) 2015 Anton lopez. All rights reserved.
//

#import "SplashScreenViewController.h"

@interface SplashScreenViewController ()

@end

@implementation SplashScreenViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
        mightFinal = CGRectMake(60, 200, 200, 60);
        yourFinal = CGRectMake(100, 135, 120, 70);
        BGFinal = CGRectMake(8, 110, 300, 150);
        
        shouldTransition = YES;
        self.imageWorldBG.frame = BGFinal;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [NSTimer scheduledTimerWithTimeInterval:4.0f target:self selector:@selector(transitionToActualApp) userInfo:nil repeats:NO];
    
    
    [UIView animateWithDuration:0.75f delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^
    {
        self.imageWorldBG.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.5, 0.5);
    } completion:^(BOOL finished)
    {
        self.imageCracks.alpha = 1.0f;
        [UIView animateWithDuration:0.2f delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^
         {
             self.imageWorldBG.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.525, 0.525);
         } completion:^(BOOL finished)
         {
             [UIView animateWithDuration:0.15f delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^
              {
                  self.imageWorldBG.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.5, 0.5);
              } completion:^(BOOL finished)
              {
                  [self fadeOtherElementsIn];
              }];
         }];
    }];
    
    
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
//    
//    NSString *remoteHostName = @"www.apple.com";
//    
//    self.hostReachability = [Reachability reachabilityWithHostName:remoteHostName];
//    [self.hostReachability startNotifier];
//    
//    self.internetReachability = [Reachability reachabilityForInternetConnection];
//    [self.internetReachability startNotifier];
//    
//    self.wifiReachability = [Reachability reachabilityForLocalWiFi];
//    [self.wifiReachability startNotifier];
    
}

/*!
 * Called by Reachability whenever status changes.
 */
//- (void) reachabilityChanged:(NSNotification *)note
//{
//    
//    NetworkStatus internetStatus = [_internetReachability currentReachabilityStatus];
//    BOOL overrider = NO;
//    
//    switch (internetStatus)
//    {
//        case NotReachable:
//        {
//            shouldTransition = NO;
//            break;
//        }
//        case ReachableViaWiFi:
//        case ReachableViaWWAN:
//        {
//            overrider = YES;
//            [NSTimer scheduledTimerWithTimeInterval:4.0f target:self selector:@selector(transitionToActualApp) userInfo:nil repeats:NO];
//            break;
//        }
//    }
//    
//    NetworkStatus hostStatus = [_hostReachability currentReachabilityStatus];
//    switch (hostStatus)
//    {
//        case NotReachable:
//        {
//            shouldTransition = NO;
//            break;
//        }
//        case ReachableViaWiFi:
//        case ReachableViaWWAN:
//        {
//            overrider = YES;
//            [NSTimer scheduledTimerWithTimeInterval:4.0f target:self selector:@selector(transitionToActualApp) userInfo:nil repeats:NO];
//            break;
//        }
//    }
//    
//    if( overrider )
//        shouldTransition = YES;
//    else
//    {
//        // could not find the requested character
//        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Connection Error" message:@"Please Connect To Internet" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//        [alert show];
//    }
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)fadeOtherElementsIn
{
    [UIView animateWithDuration:0.4f delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^
     {
         self.imageMight.alpha = 1.0f;
         self.imageTestYou.alpha = 1.0f;

     } completion:^(BOOL finished)
     {
         
     }];
}

-(void)transitionToActualApp
{
    if( shouldTransition == YES)
    {
        // Get the storyboard named secondStoryBoard from the main bundle:
        UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        // Load the initial view controller from the storyboard.
        // Set this by selecting 'Is Initial View Controller' on the appropriate view controller in the storyboard.
        UIViewController *theInitialViewController = [secondStoryBoard instantiateInitialViewController];
        theInitialViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:theInitialViewController animated:YES completion:nil];
    }
}

//
//- (void)dealloc
//{
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
//}

@end
