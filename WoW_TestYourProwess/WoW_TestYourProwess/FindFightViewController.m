//
//  FindFightViewController.m
//  WoW_TestYourProwess
//
//  Created by Anton lopez on 6/12/15.
//  Copyright (c) 2015 Anton lopez. All rights reserved.
//

#import "FindFightViewController.h"
#import "ArrayCreator.h"
#import "BattleViewController.h"

@interface FindFightViewController ()
{
    NSArray* serverList;
    UIPickerView* picker_RealmList;
    NSInteger nSelectedRealmRow;
    CharacterInformation *charInfo;
    bool networkedEnemy;
}

@end

@implementation FindFightViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerCharacterDidLoad:) name:@"PLAYER_CHAMP" object:nil];
    }
    return self;
}

-(void)playerCharacterDidLoad:(NSNotification*) notif
{
    _playersCharacter = (CharacterInformation*)notif.object;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    // Create Background
    UIImage *img = [UIImage imageNamed:@"worn-paper-background.png"];
    CGSize size = self.view.frame.size;
    UIGraphicsBeginImageContextWithOptions(size, YES, 1.0f);
    size.height -= self.tabBarController.tabBar.bounds.size.height;
    
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *background = UIGraphicsGetImageFromCurrentImageContext();
    UIColor *bgColor = [[UIColor alloc] initWithPatternImage:background];
    self.view.backgroundColor = bgColor;
    
    networkedEnemy = NO;
    
    
    serverList = [ArrayCreator createServerArray];
    
    nSelectedRealmRow = 0;
    
    picker_RealmList = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 260)];
    picker_RealmList.dataSource = self;
    picker_RealmList.delegate = self;
    picker_RealmList.center = self.view.center;
    
    charInfo = [[CharacterInformation alloc] init];
    
    [self.view addSubview:picker_RealmList];
    
    
    UIImageView* selectorImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 235)];
    selectorImage.image = [UIImage imageNamed:@"realmPicker.png"];
    selectorImage.center = self.view.center;
    
    [self.view addSubview:selectorImage];
    
    
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];

    [self setUpMultipeer];
    
    textfieldNameOfOpponant.delegate = self;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textfieldNameOfOpponant resignFirstResponder];
    return YES;
}

////////------------------------ MULTIPLAYER --------------------------/////////
- (void) setUpMultipeer{
    //  Setup peer ID
    self.myPeerID = [[MCPeerID alloc] initWithDisplayName:[_playersCharacter getCharName]];
    
    //  Setup session
    self.mySession = [[MCSession alloc] initWithPeer:self.myPeerID];
    self.mySession.delegate = self;
    
    //  Setup BrowserViewController
    self.browserVC = [[MCBrowserViewController alloc] initWithServiceType:@"tmApp" session:self.mySession];
    
    self.browserVC.delegate = self;
    
    //  Setup Advertiser
    self.advertiser = [[MCAdvertiserAssistant alloc] initWithServiceType:@"tmApp" discoveryInfo:nil session:self.mySession];
    [self.advertiser start];
}

- (IBAction)ConnectToPlayersPlaying:(id)sender
{
    [self presentViewController:self.browserVC animated:YES completion:nil];
}

- (void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


- (void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state{
    
    if(state == MCSessionStateConnected) {
        NSLog(@"Connected");
        
        NSData *data=[NSKeyedArchiver archivedDataWithRootObject:_playersCharacter];
        
        [self.mySession sendData:data toPeers:[self.mySession connectedPeers] withMode:MCSessionSendDataReliable error:nil];
    }
    
}

// Received data from remote peer
- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID{
    
    // data to character info
    charInfo = [NSKeyedUnarchiver unarchiveObjectWithData:data ];
    networkedEnemy = YES;
    [self performSegueWithIdentifier:@"segueToBattle2" sender:self];
    
}
////////---------------------------------------------------------------/////////



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)findMyOpponant:(id)sender
{
    if( textfieldNameOfOpponant.text.length < 1 )
    {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"You need to fill out the character name field" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    else
    {
        // Load character information
        [self loadEnemyCharacter];
    }
    
}

-(CharacterInformation*)loadEnemyCharacter
{
    [charInfo setName:textfieldNameOfOpponant.text];
    [charInfo setRealm:[serverList objectAtIndex:nSelectedRealmRow]];
    return nil;
}


 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 
     if (networkedEnemy)
         return;
     
     if( [segue.identifier isEqualToString:@"segueToBattle"] ||
         [segue.identifier isEqualToString:@"segueToBattle2"])
     {
         BattleViewController* bvc = (BattleViewController*)segue.destinationViewController;
         bvc.myChampInfo = _playersCharacter;
         
         [bvc shouldLoadOpponant:textfieldNameOfOpponant.text inRealm:[serverList objectAtIndex:[picker_RealmList selectedRowInComponent:0]]];
     }
 }



////////// Picker View Methods /////////

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    return serverList.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    return [NSString stringWithFormat:@"%@",[serverList objectAtIndex:row]];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    nSelectedRealmRow = row;
    
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 50;
}


@end
