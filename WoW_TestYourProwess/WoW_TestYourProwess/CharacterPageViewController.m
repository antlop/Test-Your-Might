//
//  CharacterPageViewController.m
//  WoW_TestYourProwess
//
//  Created by Anton lopez on 6/11/15.
//  Copyright (c) 2015 Anton lopez. All rights reserved.
//

#import "CharacterPageViewController.h"
#import "FindFightViewController.h"
#import "StatGroupSelectionView.h"
#import "Items.h"

@interface CharacterPageViewController ()

@end

@implementation CharacterPageViewController


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
        ////// I want to know when the user wants to download a character
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recievedRequestToLoadChar:) name:@"LOAD_CHAR" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeStatGroup:) name:@"SELECTED_STAT_GROUP" object:nil];
        
        boolDidLoad = boolHaveCharInfo = false;
        tableViewStats = [[StatsTableViewController alloc] init];
        
        [activityLoading stopAnimating];
        
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    itemInfoView.hidden = YES;
    allOtherButton.hidden = YES;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    ////// Sound ///////
//    NSString *pageSFXPath = [[NSBundle mainBundle]
//                            pathForResource:@"Page" ofType:@"wav"];
//    NSURL *pageSFXURL = [NSURL fileURLWithPath:pageSFXPath];
//    pageSoundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:pageSFXURL
//                                                                   error:nil];
//    pageSoundPlayer.numberOfLoops = 0;
    sounds = [[NSMutableArray alloc]init];
    [NSTimer scheduledTimerWithTimeInterval:0.01f target:self selector:@selector(checkForAudio) userInfo:nil repeats:YES];
    
    
    itemInfoView = [ItemDetailViewController getItemDetailView];
    itemInfoView.frame = CGRectMake(4, 62, 165, 85);
    itemInfoView.hidden = YES;
    [self.view addSubview:itemInfoView];
    
    ////// Create Background //////
    UIImage *img = [UIImage imageNamed:@"worn-paper-background.png"];
    CGSize size = self.view.frame.size;
    UIGraphicsBeginImageContextWithOptions(size, YES, 1.0f);
    size.height -= self.tabBarController.tabBar.bounds.size.height;
    
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *background = UIGraphicsGetImageFromCurrentImageContext();
    UIColor *bgColor = [[UIColor alloc] initWithPatternImage:background];
    self.view.backgroundColor = bgColor;
    //////////////////////////////
    
    
    if( boolHaveCharInfo == NO )
    {
        labelSelectCharacter = [[UILabel alloc] initWithFrame:CGRectMake(32, 100, self.view.frame.size.width - 64, 200)];
        labelSelectCharacter.text = @"Need to Select a Character";
        labelSelectCharacter.numberOfLines = 2;
        labelSelectCharacter.font = [UIFont fontWithDescriptor:labelSelectCharacter.font.fontDescriptor size:18];
        labelSelectCharacter.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:labelSelectCharacter];
    }
    
    navButtonBattle.enabled = NO;
    boolDidLoad = true;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [grpSelectionButton setTitle:@"Attributes" forState:UIControlStateNormal];
}

-(void)checkForAudio
{
    NSMutableArray* toDelete = [[NSMutableArray alloc]init];
    for( AVAudioPlayer* temp in sounds)
    {
        if( !temp.isPlaying)
        {
            [toDelete addObject:temp];
        }
    }
    
    for( AVAudioPlayer* temp in toDelete)
    {
        [sounds removeObject:temp];
    }
    [toDelete removeAllObjects];
}

-(void)recievedRequestToLoadChar:(NSNotification*) notif
{
    ////// ok, so you want some character information
    [activityLoading startAnimating];
    //activityLoading.hidden = NO;
    
    NSArray* r = [self.view subviews];
    for( UIView* v in r)
    {
        if( [v isKindOfClass:[UIButton class]] && v.tag >= 10000)
            [v removeFromSuperview];
    }
    
    // we have the character name and server
    myCharacter = notif.object;
    
    // do not want the "Need to load a character" message
    [labelSelectCharacter removeFromSuperview];
    grpSelectionButton.enabled = YES;
    
    // Create the base string with the two components needed to access the API
    NSString* apperanceRequestString = [NSString stringWithFormat:@"https://us.api.battle.net/wow/character/%@/%@?fields=stats&locale=en_US&apikey=e3jfrwhxhgj4d2y9szwcs3nnrj9h2vqb", [myCharacter getRealmName], [myCharacter getCharName]];
    
    // create a url from the string above while replacing the spaces
    NSURLRequest* characterApperanceRequestURL = [NSURLRequest requestWithURL:[NSURL URLWithString:[apperanceRequestString stringByReplacingOccurrencesOfString:@" " withString:@"%20"]]];
    
    // download the information and called the "shouldLoadChar" method
    [NSURLConnection sendAsynchronousRequest:characterApperanceRequestURL queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        [self performSelectorOnMainThread:@selector(shouldLoadChar:) withObject:data waitUntilDone:YES];
    }];
    
    //// this will get the characters specilization
    NSString* specRequestString = [NSString stringWithFormat:@"https://us.api.battle.net/wow/character/%@/%@?fields=talents&locale=en_US&apikey=e3jfrwhxhgj4d2y9szwcs3nnrj9h2vqb", [myCharacter getRealmName], [myCharacter getCharName]];
    
    NSURLRequest* charSpecRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[specRequestString stringByReplacingOccurrencesOfString:@" " withString:@"%20"]]];
    
    [NSURLConnection sendAsynchronousRequest:charSpecRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        [self performSelectorOnMainThread:@selector(getCharacterClassAndSpec:) withObject:data waitUntilDone:YES];
    }];
    
    
    //// this will get the characters items
    NSString* itemsequestString = [NSString stringWithFormat:@"https://us.api.battle.net/wow/character/%@/%@?fields=items&locale=en_US&apikey=e3jfrwhxhgj4d2y9szwcs3nnrj9h2vqb", [myCharacter getRealmName], [myCharacter getCharName]];
    
    NSURLRequest* charItemsRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[itemsequestString stringByReplacingOccurrencesOfString:@" " withString:@"%20"]]];
    
    [NSURLConnection sendAsynchronousRequest:charItemsRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        [self getCharacterItems:data];
    }];

    
}
-(void)getCharacterClassAndSpec: (NSData*)data
{
    if( data != nil)
    {
        NSDictionary* specDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        if( [[specDictionary objectForKey:@"status"] isEqualToString:@"nok"] || specDictionary.count < 1)
        {
            
        }
        else
        {
            int class = [[specDictionary objectForKey:@"class"] integerValue];
            [myCharacter setClass:class];
            
            NSArray* specs = [specDictionary objectForKey:@"talents"];
            for( int i = 0; i < specs.count; ++i )
            {
                if( [[specs objectAtIndex:i] objectForKey:@"selected"])
                {
                    NSString* specName = [[[specs objectAtIndex:i] objectForKey:@"spec"]objectForKey:@"name"];
                    [myCharacter setSpec:specName];
                    
                    
                    labelCharacterName.text = [myCharacter getCharName];
                    labelCharacterName.textColor = [myCharacter getClassColor];
                  //  [labelCharacterName reloadInputViews];
                    
                    return;
                }
            }
        }
    }
}
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 100)
    {
        [myCharacter reset];
        imageProfileMain.image = nil;
        labelCharacterName.text = @"";
        tableViewStats.characterStats = nil;
        [tableViewStats.tableView reloadData];
        
        // re-add the "need to load a character" message
        [self.view addSubview:labelSelectCharacter];
        grpSelectionButton.enabled = NO;
        [activityLoading stopAnimating];
        
        // go back to the character selection view
        [[self.tabBarController.tabBar.items objectAtIndex:2] setEnabled:NO];
        [[self.tabBarController.tabBar.items objectAtIndex:0] setEnabled:YES];
        [self.tabBarController setSelectedIndex:0];
    }
}

-(void)shouldLoadChar: (NSData*)data
{
    if( data != nil )
    {
        // we have data and now create a dictionary from that
        NSDictionary* characterApperanceQueryDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        if( [[characterApperanceQueryDictionary objectForKey:@"status"] isEqualToString:@"nok"] || characterApperanceQueryDictionary.count < 1)
        {
            // could not find the requested character
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Error" message:[characterApperanceQueryDictionary objectForKey:@"reason"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            alert.tag = 100;
            [alert show];
            
   //         [myCharacter setName:@""];
            return;
            
            
        }
        else
        {
            // get the second half of the thumbnail image path
            szThumbnailPath = [characterApperanceQueryDictionary objectForKey:@"thumbnail"];
            
            // set the character stats
            [myCharacter setStats:[characterApperanceQueryDictionary objectForKey:@"stats"]];
            
            // we now have character information
            boolHaveCharInfo = true;
            [labelSelectCharacter removeFromSuperview];
            grpSelectionButton.enabled = YES;
            
            if( boolDidLoad )
            {
                [self loadThumbnail:szThumbnailPath];
#warning start these on the main thread
                [self setNameOfCharacterLabel];
                [self setStatsOfCharacterLabel];
                [myCharacter setClass:[[characterApperanceQueryDictionary objectForKey:@"class"] integerValue]];
                myCharacter.level = [[characterApperanceQueryDictionary objectForKey:@"level"] integerValue];
                
            }
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            
            [defaults setObject:[myCharacter getCharName] forKey:@"champName"];
            [defaults setObject:[myCharacter getRealmName] forKey:@"realmName"];
            
            [defaults synchronize];
            
            [[self.tabBarController.tabBar.items objectAtIndex:2] setEnabled:YES];
        }
    }
}

-(void)loadThumbnail:(NSString*)path
{
    ////// THUMBNAIL //////
    // path for the thumbnail image
    NSString* thumbnailQueryURL = [NSString stringWithFormat:@"http://render-us.worldofwarcraft.com/character/%@", path];
    
    // we now have a thumbnail
    NSData* d = [NSData dataWithContentsOfURL:[NSURL URLWithString:thumbnailQueryURL]];
    [self setThumbnailImage:d];
    
    
    ////// CHARACTER SCREEN CAP //////
    // switch string from thumbnail to profilemain
    NSString* sz = [path stringByReplacingOccurrencesOfString:@"avatar" withString:@"profilemain"];
    NSString* profileQueryURL = [NSString stringWithFormat:@"http://render-us.worldofwarcraft.com/character/%@", sz];
    
    NSURLRequest* imgRequestURL = [NSURLRequest requestWithURL:[NSURL URLWithString:profileQueryURL]];
    
    // get the profile image on a seperate thread
    //      then call the return method on the main thread
    [NSURLConnection sendAsynchronousRequest:imgRequestURL queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        [self performSelectorOnMainThread:@selector(setProfileImage:) withObject:data waitUntilDone:YES];
        
        if(connectionError) {
            NSLog(@"%@", [connectionError localizedDescription]);
        }
        
    }];
    
    NSData* da = [[NSData alloc ] initWithContentsOfURL:[NSURL URLWithString:sz]];
    imageProfileMain.image = [UIImage imageWithData:da];
}

-(void)setNameOfCharacterLabel
{
    // make the tabs title the name of the character
    self.title = [myCharacter getCharName];
}

-(void)setStatsOfCharacterLabel
{
    tableViewStats = [tableViewStats init:CGRectMake(60, 250, self.view.frame.size.width - 120, 265) withOriginalStatsDictionary: [myCharacter getDisplayStats]];
    tableViewStats.characterStats = [[myCharacter getDisplayStats] objectAtIndex:0];
    tableViewStats.group = 0;
    
    [tableViewStats.tableView reloadData];
    
    [self.view addSubview:tableViewStats.view];
    [self.view sendSubviewToBack:tableViewStats.view];
}

-(void)setThumbnailImage: (NSData*)imageData
{
    [myCharacter setThumbnail:[UIImage imageWithData:imageData]];
}

-(void)setProfileImage: (NSData*)imageData
{
    imageProfileMain.image = [UIImage imageWithData:imageData];
    
    // Create a mask to look like a torn image
    CALayer *mask = [CALayer layer];
    mask.contents = (id)[[UIImage imageNamed:@"BlackFrameMask.png"] CGImage];
    mask.frame = CGRectMake(0, 0, 712, 456);
    imageProfileMain.layer.mask = mask;
    imageProfileMain.layer.masksToBounds = YES;
    
    [self.view sendSubviewToBack:imageProfileMain];
    
    // notify everyone that the Player Champion is HERE!
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PLAYER_CHAMP" object:myCharacter];
    
    [activityLoading stopAnimating];
}

-(IBAction)pickWitchStats:(id)sender
{
    StatGroupSelectionView* sgsv = (StatGroupSelectionView*)selectionView;
    [sgsv buttonWasPressed: tableViewStats];
    
    // [clickSoundPlayer play];
    NSString *clickSFXPath = [[NSBundle mainBundle] pathForResource:@"clicked" ofType:@"wav"];
    NSURL* clickSFXURL = [NSURL fileURLWithPath:clickSFXPath];
    AVAudioPlayer* soundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:clickSFXURL error:nil];
    soundPlayer.numberOfLoops = 0;
    [sounds addObject:soundPlayer];
    [soundPlayer prepareToPlay];
    [soundPlayer play];
}

-(void)changeStatGroup:(NSNotification*)grp
{
    int buttonNum = [grp.object intValue];
    NSString* displayString = @"";
    switch (buttonNum)
    {
        case 0:
            displayString = @"Attributes";
            break;
        case 1:
            displayString = @"Enhancements";
            break;
        case 2:
            displayString = @"Attacks";
            break;
        case 3:
            displayString = @"Spells";
            break;
        case 4:
            displayString = @"Defences";
            break;
    }
    [grpSelectionButton setTitle:displayString forState:UIControlStateNormal];
    [grpSelectionButton setTitle:displayString forState:UIControlStateHighlighted];
    
    tableViewStats.characterStats = [[myCharacter getDisplayStats] objectAtIndex:buttonNum];
    tableViewStats.group = buttonNum;
    [tableViewStats.tableView reloadData];
    
}


-(void)getItemData: (NSDictionary*)dict forItem: (item*)t passThroughIndex:(int)type
{
    t.szName = [dict objectForKey:@"name"];
    t.nArmor = [[dict objectForKey:@"armor"] intValue];
    t.nItemLvl = [[dict objectForKey:@"itemLevel"] intValue];
    
    NSString* imagePath = [NSString stringWithFormat:@"http://us.media.blizzard.com/wow/icons/56/%@.jpg", [dict objectForKey:@"icon"]];
    
    t.icon = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imagePath]]];
    
    
    [self performSelectorOnMainThread:@selector(createItemIconView:) withObject:[NSNumber numberWithInt:type] waitUntilDone:YES];

}

-(void)createItemIconView: (NSNumber*)type;
{
    int kind = [type intValue];
    if( [[myCharacter.gearItems.arrayItems objectAtIndex:kind] icon] == nil)
        return;
    float xPos = self.view.frame.size.width - 60;
    float yPos = 20 + (60 * (kind - SLOT_HANDS));
    if( kind <= SLOT_WRIST)
    {
        xPos = 4;
        yPos = 20 + (60 * kind);
    }
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(xPos, yPos, 56, 56)];
    [btn setImage:[[myCharacter.gearItems.arrayItems objectAtIndex:kind] icon] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(itemClicked:) forControlEvents:UIControlEventTouchUpInside];
    btn.tag = 10000 + kind;
    [self.view addSubview:btn];
    
}

-(void)itemClicked:(id)sender
{
    
    int kind = [sender tag] - 10000;
    float xPos = self.view.frame.size.width - 145;
    float yPos = 60 + (60 * (kind - SLOT_HANDS));
    if( kind <= SLOT_WRIST)
    {
        xPos = 145;
        yPos = 60 + (60 * kind);
    }

    [itemInfoView setItem:[myCharacter.gearItems.arrayItems objectAtIndex:kind] atNewPosition:CGPointMake(xPos, yPos)];
    
    itemInfoView.hidden = NO;
    allOtherButton.hidden = NO;
    
    
    NSString *pageSFXPath = [[NSBundle mainBundle]
                             pathForResource:@"Page" ofType:@"wav"];
    NSURL *pageSFXURL = [NSURL fileURLWithPath:pageSFXPath];
    AVAudioPlayer* soundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:pageSFXURL
                                                             error:nil];
    soundPlayer.numberOfLoops = 0;
    [sounds addObject:soundPlayer];
    [soundPlayer prepareToPlay];
    [soundPlayer play];
//
//    if( pageSoundPlayer.isPlaying)
//       [pageSoundPlayer stop];
//    [pageSoundPlayer play];
}

-(void)getCharacterItems:(NSData*)data
{
    if( data != nil)
    {
        NSDictionary* itemsReqDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        if( [[itemsReqDict objectForKey:@"status"] isEqualToString:@"nok"] || itemsReqDict.count < 1)
        {
            
        }
        else
        {
            // head
            NSDictionary* headsDict = [[itemsReqDict objectForKey:@"items"] objectForKey:@"head"];
            item *temp = [myCharacter.gearItems.arrayItems objectAtIndex:SLOT_HEAD];
            [self getItemData:headsDict forItem:temp passThroughIndex:SLOT_HEAD];
            
            // neck
            NSDictionary* neckDict = [[itemsReqDict objectForKey:@"items"] objectForKey:@"neck"];
            temp = [myCharacter.gearItems.arrayItems objectAtIndex:SLOT_NECK];
            [self getItemData:neckDict forItem:temp passThroughIndex:SLOT_NECK];
            
            // head
            NSDictionary* shoulderDict = [[itemsReqDict objectForKey:@"items"] objectForKey:@"shoulder"];
            temp = [myCharacter.gearItems.arrayItems objectAtIndex:SLOT_SHOULDER];
            [self getItemData:shoulderDict forItem:temp passThroughIndex:SLOT_SHOULDER];
            
            // head
            NSDictionary* backDict = [[itemsReqDict objectForKey:@"items"] objectForKey:@"back"];
            temp = [myCharacter.gearItems.arrayItems objectAtIndex:SLOT_CLOAK];
            [self getItemData:backDict forItem:temp passThroughIndex:SLOT_CLOAK];
            
            // head
            NSDictionary* chestDict = [[itemsReqDict objectForKey:@"items"] objectForKey:@"chest"];
            temp = [myCharacter.gearItems.arrayItems objectAtIndex:SLOT_CHEST];
            [self getItemData:chestDict forItem:temp passThroughIndex:SLOT_CHEST];
            
            // head
            NSDictionary* shirtDict = [[itemsReqDict objectForKey:@"items"] objectForKey:@"shirt"];
            temp = [myCharacter.gearItems.arrayItems objectAtIndex:SLOT_SHIRT];
            [self getItemData:shirtDict forItem:temp passThroughIndex:SLOT_SHIRT];
            
            // head
            NSDictionary* tabardDict = [[itemsReqDict objectForKey:@"items"] objectForKey:@"tabard"];
            temp = [myCharacter.gearItems.arrayItems objectAtIndex:SLOT_TABARD];
            [self getItemData:tabardDict forItem:temp passThroughIndex:SLOT_TABARD];
            
            // head
            NSDictionary* wristDict = [[itemsReqDict objectForKey:@"items"] objectForKey:@"wrist"];
            temp = [myCharacter.gearItems.arrayItems objectAtIndex:SLOT_WRIST];
            [self getItemData:wristDict forItem:temp passThroughIndex:SLOT_WRIST];
            
            // head
            NSDictionary* handsDict = [[itemsReqDict objectForKey:@"items"] objectForKey:@"hands"];
            temp = [myCharacter.gearItems.arrayItems objectAtIndex:SLOT_HANDS];
            [self getItemData:handsDict forItem:temp passThroughIndex:SLOT_HANDS];
            
            // head
            NSDictionary* waistDict = [[itemsReqDict objectForKey:@"items"] objectForKey:@"waist"];
            temp = [myCharacter.gearItems.arrayItems objectAtIndex:SLOT_BELT];
            [self getItemData:waistDict forItem:temp passThroughIndex:SLOT_BELT];
            
            // head
            NSDictionary* legsDict = [[itemsReqDict objectForKey:@"items"] objectForKey:@"legs"];
            temp = [myCharacter.gearItems.arrayItems objectAtIndex:SLOT_LEGS];
            [self getItemData:legsDict forItem:temp passThroughIndex:SLOT_LEGS];
            
            // head
            NSDictionary* feetDict = [[itemsReqDict objectForKey:@"items"] objectForKey:@"feet"];
            temp = [myCharacter.gearItems.arrayItems objectAtIndex:SLOT_FEET];
            [self getItemData:feetDict forItem:temp passThroughIndex:SLOT_FEET];
            
            // head
            NSDictionary* finger1Dict = [[itemsReqDict objectForKey:@"items"] objectForKey:@"finger1"];
            temp = [myCharacter.gearItems.arrayItems objectAtIndex:SLOT_RING1];
            [self getItemData:finger1Dict forItem:temp passThroughIndex:SLOT_RING1];
            
            // head
            NSDictionary* finger2Dict = [[itemsReqDict objectForKey:@"items"] objectForKey:@"finger2"];
            temp = [myCharacter.gearItems.arrayItems objectAtIndex:SLOT_RING2];
            [self getItemData:finger2Dict forItem:temp passThroughIndex:SLOT_RING2];
            
            // head
            NSDictionary* trinket1Dict = [[itemsReqDict objectForKey:@"items"] objectForKey:@"trinket1"];
            temp = [myCharacter.gearItems.arrayItems objectAtIndex:SLOT_TRINK1];
            [self getItemData:trinket1Dict forItem:temp passThroughIndex:SLOT_TRINK1];
            
            // head
            NSDictionary* trinket2Dict = [[itemsReqDict objectForKey:@"items"] objectForKey:@"trinket2"];
            temp = [myCharacter.gearItems.arrayItems objectAtIndex:SLOT_TRINK2];
            [self getItemData:trinket2Dict forItem:temp passThroughIndex:SLOT_TRINK2];
        }
    }
}
-(IBAction)backgroundClicked:(id)sender
{
    itemInfoView.hidden = YES;
    allOtherButton.hidden = YES;
}

@end
