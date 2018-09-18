//
//  BattleViewController.m
//  WoW_TestYourProwess
//
//  Created by Anton lopez on 6/15/15.
//  Copyright (c) 2015 Anton lopez. All rights reserved.
//

#import "BattleViewController.h"

@interface BattleViewController ()

@end

@implementation BattleViewController


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
        _myOpponantInfo = [[CharacterInformation alloc] init];
        bFightHasStarted = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    myChampDmgRect = CGRectMake(36, 272, 110, 110);
    myOppDmgRect = CGRectMake(164, 272, 110, 110);
    
    ////// Sound ///////
    
    NSString *deathSFXPath = [[NSBundle mainBundle] pathForResource:@"Fatality" ofType:@"wav"];
    NSURL* deathSFXURL = [NSURL fileURLWithPath:deathSFXPath];
    fetalityPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:deathSFXURL error:nil];
    fetalityPlayer.numberOfLoops = 0;
    
    
    playerAttackTimer = [[NSTimer alloc] init];
    opponentAttackTimer = [[NSTimer alloc] init];
    updateTimer = [[NSTimer alloc] init];
    
    combatText = [[NSMutableArray alloc]init];
    endCombatText = FALSE;
    
    
    viewMyChampDamage.hidden = YES;
    viewMyOpponantDamage.hidden = YES;
    
    // Create Background
    UIImage *img = [UIImage imageNamed:@"worn-paper-background.png"];
    CGSize size = self.view.frame.size;
    UIGraphicsBeginImageContextWithOptions(size, YES, 1.0f);
    size.height -= self.tabBarController.tabBar.bounds.size.height;
    
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *background = UIGraphicsGetImageFromCurrentImageContext();
    UIColor *bgColor = [[UIColor alloc] initWithPatternImage:background];
    self.view.backgroundColor = bgColor;
    
    
    
    if( _myChampInfo != nil)
    {
        imageMyChampIcon.image = [_myChampInfo getThumbnail];
        
        progressMyChampHealth.progress = 1;
        playerHP = [[[_myChampInfo getStats] objectForKey:@"health"] integerValue];
        
        labelMyChampHP.text = [NSString stringWithFormat:@"HP: %d", playerHP];
        labelMyChampName.text = [_myChampInfo getCharName];
    }
    else
    {
        _myChampInfo = [[CharacterInformation alloc] init];
    }
    
    // activity Loop / attack loop (make this the GCD)
   /// [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(methodB:) userInfo:nil repeats:YES]
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)shouldLoadOpponant:(NSString*)charName inRealm: (NSString*)realmName
{
    [_myOpponantInfo setName:charName];
    [_myOpponantInfo setRealm:realmName];
    
    // throw on sepearte thread
    //[self loadOpponantCharacterInformation:realmName];
    
    NSString* apperanceRequestString = [NSString stringWithFormat:@"https://us.api.battle.net/wow/character/%@/%@?fields=stats&locale=en_US&apikey=e3jfrwhxhgj4d2y9szwcs3nnrj9h2vqb", [_myOpponantInfo getRealmName], [_myOpponantInfo getCharName]];
    
    // create a url from the string above while replacing the spaces
    NSURLRequest* characterApperanceRequestURL = [NSURLRequest requestWithURL:[NSURL URLWithString:[apperanceRequestString stringByReplacingOccurrencesOfString:@" " withString:@"%20"]]];
    
    [NSURLConnection sendAsynchronousRequest:characterApperanceRequestURL queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        [self performSelectorOnMainThread:@selector(didLoadOpponantCharacterInformation:) withObject:data waitUntilDone:YES];
    }];
    
    //// this will get the characters specilization
    NSString* specRequestString = [NSString stringWithFormat:@"https://us.api.battle.net/wow/character/%@/%@?fields=talents&locale=en_US&apikey=e3jfrwhxhgj4d2y9szwcs3nnrj9h2vqb", [_myOpponantInfo getRealmName], [_myOpponantInfo getCharName]];
    
    NSURLRequest* charSpecRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[specRequestString stringByReplacingOccurrencesOfString:@" " withString:@"%20"]]];
    
    [NSURLConnection sendAsynchronousRequest:charSpecRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        [self performSelectorOnMainThread:@selector(getCharacterClassAndSpec:) withObject:data waitUntilDone:YES];
    }];

}

-(void)getCharacterClassAndSpec:(NSData*)data
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
            [_myOpponantInfo setClass:class];
            
            NSArray* specs = [specDictionary objectForKey:@"talents"];
            for( int i = 0; i < specs.count; ++i )
            {
                if( [[specs objectAtIndex:i] objectForKey:@"selected"])
                {
                    NSString* specName = [[[specs objectAtIndex:i] objectForKey:@"spec"]objectForKey:@"name"];
                    [_myOpponantInfo setSpec:specName];
                    return;
                }
            }
        }
    }

}

-(void)didLoadOpponantCharacterInformation: (NSData*)data
{
    if( data != nil )
    {
        // create a dictionary out of the information gathered
        NSDictionary* characterApperanceQueryDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        if( [[characterApperanceQueryDictionary objectForKey:@"status"] isEqualToString:@"nok"])
        {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Character Not Found" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [_myOpponantInfo setStats:[characterApperanceQueryDictionary objectForKey:@"stats"]];
            keys = [[_myOpponantInfo getStats] allKeys];
            // NSLog(@"got stats");
            
            
            
            NSString* szThumbnailPath = [characterApperanceQueryDictionary objectForKey:@"thumbnail"];
            NSString* thumbnailQueryURL = [NSString stringWithFormat:@"http://us.battle.net/static-render/us/%@", szThumbnailPath];
            
            NSData* d = [NSData dataWithContentsOfURL:[NSURL URLWithString:thumbnailQueryURL]];
            
            UIImage* img = [UIImage imageWithData:d];
            imageOpponentIcon.image = img;
            
            CALayer *mask = [CALayer layer];
            mask.contents = (id)[[UIImage imageNamed:@"mask.png"] CGImage];
            
            mask.frame = CGRectMake(0, 0, 56, 56);
            imageOpponentIcon.layer.mask = mask;
            imageOpponentIcon.layer.masksToBounds = YES;
            
            [_myOpponantInfo setThumbnail:img];
            [_myOpponantInfo setClass:[[characterApperanceQueryDictionary objectForKey:@"class"] integerValue]];
            _myOpponantInfo.level = [[characterApperanceQueryDictionary objectForKey:@"level"] integerValue];
            
            if(_myOpponantInfo != nil)
            {
                progressOpponantHealth.progress = 1;
                opponantHP = [[[_myOpponantInfo getStats] objectForKey:@"health"] integerValue];
                
                
                labelOpponentHP.text = [NSString stringWithFormat:@"HP: %d", opponantHP];
                labelOpponentName.text = [_myOpponantInfo getCharName];
            }
        }
        
    }
    
}

-(IBAction)startFight:(id)sender{
    
    buttonStartFight.hidden = YES;
    
    progressOpponantHealth.progress = 1;
    progressMyChampHealth.progress = 1;
    opponantHP = [[[_myOpponantInfo getStats] objectForKey:@"health"] integerValue];
    playerHP = [[[_myChampInfo getStats] objectForKey:@"health"] integerValue];
    labelOpponentHP.text = [NSString stringWithFormat:@"HP: %d",opponantHP];
    labelMyChampHP.text = [NSString stringWithFormat:@"HP: %d",playerHP];
    viewMyChampDamage.hidden = YES;
    viewMyOpponantDamage.hidden = YES;
    
    [self invalidateTheTimers];
    bFightHasStarted = YES;
    
    [self startTheFight:-10.0f];
}


-(void)startTheFight:(double)time
{
    if( bFightHasStarted )
    {
        [self invalidateTheTimers];
        double speed = 1.0f;
        if( time != -10.0f )
            speed = time;
        
        double myChampSpeed;
        
        if( [_myChampInfo getSpecEnum] == SPEC_HUNT_BM ||
           [_myChampInfo getSpecEnum] == SPEC_HUNT_MARK ||
           [_myChampInfo getSpecEnum] == SPEC_HUNT_SUR)
            myChampSpeed = [[[_myChampInfo getStats] objectForKey:@"rangedSpeed"] doubleValue] * 0.25;
        else
            myChampSpeed = [[[_myChampInfo getStats] objectForKey:@"mainHandSpeed"] doubleValue] * 0.25;
        
        
        playerAttackTimer = [NSTimer scheduledTimerWithTimeInterval:myChampSpeed*speed target:self selector:@selector(myChampDoDamage) userInfo:nil repeats:YES];
        
        
        double myOpponentSpeed;
        
        if( [_myOpponantInfo getSpecEnum] == SPEC_HUNT_BM ||
           [_myOpponantInfo getSpecEnum] == SPEC_HUNT_MARK ||
           [_myOpponantInfo getSpecEnum] == SPEC_HUNT_SUR)
            myOpponentSpeed = [[[_myOpponantInfo getStats] objectForKey:@"rangedSpeed"] doubleValue] * 0.25;
        else
            myOpponentSpeed = [[[_myOpponantInfo getStats] objectForKey:@"mainHandSpeed"] doubleValue] * 0.25;
        
        opponentAttackTimer = [NSTimer scheduledTimerWithTimeInterval:myOpponentSpeed*speed target:self selector:@selector(opponentDoDamage) userInfo:nil repeats:YES];
        
        updateTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(updateCombatText) userInfo:nil repeats:YES];
        endCombatText = FALSE;
        
        
        if( [self checkIfCharShouldHeal:_myChampInfo])
        {
            playerHealTimer = [NSTimer scheduledTimerWithTimeInterval:1.75f*speed target:self selector:@selector(myChampHeal) userInfo:nil repeats:YES];
        }
        if( [self checkIfCharShouldHeal:_myOpponantInfo])
        {
            opponentHealTimer = [NSTimer scheduledTimerWithTimeInterval:1.75f*speed target:self selector:@selector(myOpponantHeal) userInfo:nil repeats:YES];
        }
        if( [self checkIfCharShouldUseOffHand:_myChampInfo])
        {
            
            double Speed = [[[_myChampInfo getStats] objectForKey:@"offHandSpeed"] doubleValue] * 0.25;
            
            playerOffHandAttackTimer = [NSTimer scheduledTimerWithTimeInterval:Speed*speed target:self selector:@selector(myChampDoOffDamage) userInfo:nil repeats:YES];
        }
        if( [self checkIfCharShouldUseOffHand:_myOpponantInfo])
        {
            double Speed = [[[_myOpponantInfo getStats] objectForKey:@"offHandSpeed"] doubleValue] * 0.25;
            
            opponentOffHandAttackTimer = [NSTimer scheduledTimerWithTimeInterval:Speed*speed target:self selector:@selector(myOpponantDoOffDamage) userInfo:nil repeats:YES];
            
        }
    }
    
}
- (IBAction)SpeedUp:(id)sender
{
    [self invalidateTheTimers];
    [self startTheFight:0.5f];
}

- (IBAction)NormalSpeed:(id)sender
{
    [self invalidateTheTimers];
    [self startTheFight:-10.0f];
}
- (IBAction)SlowDown:(id)sender
{
    [self invalidateTheTimers];
    [self startTheFight:1.5f];
}
-(void)invalidateTheTimers
{
    [playerAttackTimer invalidate];
    [opponentAttackTimer invalidate];
    [opponentHealTimer invalidate];
    [playerHealTimer invalidate];
    [playerOffHandAttackTimer invalidate];
    [opponentOffHandAttackTimer invalidate];
    
    playerAttackTimer = nil;
    opponentAttackTimer = nil;
    opponentHealTimer = nil;
    playerHealTimer = nil;
    playerOffHandAttackTimer = nil;
    opponentOffHandAttackTimer = nil;
    
}

-(void)opponentDoDamage
{
    int dmg = [self calculateDmgFor:_myOpponantInfo against:_myChampInfo];
    playerHP -= dmg;
    
    CGPoint p = progressMyChampHealth.frame.origin;
    p.x -= 30;
    [self generatecombatTextWithRespectTo:p withDamage:dmg];
    
    if( playerHP < 0 )
    {
        playerHP = 0;
        progressMyChampHealth.progress = 0;
        labelMyChampHP.text = @"Dead";
        [self invalidateTheTimers];
        endCombatText = TRUE;
        viewMyChampDamage.hidden = NO;
        
        bFightHasStarted = NO;
        buttonStartFight.hidden = NO;
        [fetalityPlayer play];
    }
    else
    {
        int hp =[[[_myChampInfo getStats] objectForKey:@"health"] integerValue];
        
        if( hp > 0 )
        {
            labelMyChampHP.text = [NSString stringWithFormat:@"HP: %d", playerHP];
            progressMyChampHealth.progress = ((100*playerHP)/hp) * 0.01;
        }
    }
}

-(void)myOpponantDoOffDamage
{
    int dmg = [self calculateOffDmgFor:_myOpponantInfo against:_myChampInfo];
    playerHP -= dmg;
    
    CGPoint p = progressMyChampHealth.frame.origin;
    p.x += 45;
    [self generatecombatTextWithRespectTo:p withDamage:dmg];
    
    if( playerHP < 0 )
    {
        playerHP = 0;
        progressMyChampHealth.progress = 0;
        labelMyChampHP.text = @"Dead";
        [self invalidateTheTimers];
        endCombatText = TRUE;
        viewMyChampDamage.hidden = NO;
        
        bFightHasStarted = NO;
        buttonStartFight.hidden = NO;
        [fetalityPlayer play];
    }
    else
    {
        int hp =[[[_myChampInfo getStats] objectForKey:@"health"] integerValue];
        
        if( hp > 0 )
        {
            labelMyChampHP.text = [NSString stringWithFormat:@"HP: %d", playerHP];
            progressMyChampHealth.progress = ((100*playerHP)/hp) * 0.01;
        }
    }
}

-(void)myChampDoDamage
{
    int dmg = [self calculateDmgFor:_myChampInfo against:_myOpponantInfo];
    
    opponantHP -= dmg;
    
    CGPoint p = progressOpponantHealth.frame.origin;
    p.x -= 30;
    [self generatecombatTextWithRespectTo:p withDamage:dmg];
    
    if( opponantHP < 0 )
    {
        opponantHP = 0;
        progressOpponantHealth.progress = 0;
        labelOpponentHP.text = @"Dead";
        
        [self invalidateTheTimers];
        
        viewMyOpponantDamage.hidden = NO;
        
        
        endCombatText = TRUE;
        bFightHasStarted = NO;
        
        buttonStartFight.hidden = NO;
        buttonStartFight.titleLabel.text = @"Fight!";
        [fetalityPlayer play];
    }
    else
    {
        int hp =[[[_myOpponantInfo getStats] objectForKey:@"health"] integerValue];
        
        if( hp > 0 )
        {
            labelOpponentHP.text = [NSString stringWithFormat:@"HP: %d", opponantHP];
            
            progressOpponantHealth.progress = ((100*opponantHP)/hp) * 0.01;
        }
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self invalidateTheTimers];
}

-(void)myChampDoOffDamage
{
    int dmg = [self calculateOffDmgFor:_myChampInfo against:_myOpponantInfo];
    
    opponantHP -= dmg;
    CGPoint p = progressOpponantHealth.frame.origin;
    p.x += 45;
    [self generatecombatTextWithRespectTo:p withDamage:dmg];
    
    if( opponantHP < 0 )
    {
        opponantHP = 0;
        progressOpponantHealth.progress = 0;
        labelOpponentHP.text = @"Dead";
        viewMyOpponantDamage.hidden = NO;
        [self invalidateTheTimers];
        
        endCombatText = TRUE;
        bFightHasStarted = NO;
        
        buttonStartFight.hidden = NO;
        buttonStartFight.titleLabel.text = @"Fight!";
        [fetalityPlayer play];
    }
    else
    {
        int hp =[[[_myOpponantInfo getStats] objectForKey:@"health"] integerValue];
        
        if( hp > 0 )
        {
            labelOpponentHP.text = [NSString stringWithFormat:@"HP: %d", opponantHP];
            
            progressOpponantHealth.progress = ((100*opponantHP)/hp) * 0.01;
        }
    }

}

-(int)calculateOffDmgFor:(CharacterInformation*)me against:(CharacterInformation*)myEnemy
{
    double crit = [[[me getStats] objectForKey:@"crit"] doubleValue];
    int mindmg = [[[me getStats] objectForKey:@"offHandDmgMin"] intValue];
    int maxdmg = [[[me getStats] objectForKey:@"offHandDmgMax"] intValue];
    int armor = [[[me getStats] objectForKey:@"armor"] integerValue];
    
    double reduction = (armor / ((85.0*myEnemy.level) + armor + 400.0));
    int dmg = (arc4random()%(maxdmg - mindmg)) + mindmg;
    dmg -= dmg * reduction;
    
    double r = (arc4random()%100000) * 0.001;
    if( crit >= r )
        dmg *= 2;
    
    return dmg;
}

-(int)calculateDmgFor:(CharacterInformation*)me against:(CharacterInformation*)myEnemy
{
    double crit = [[[me getStats] objectForKey:@"crit"] doubleValue];
    int mindmg;
    int maxdmg;
    //rangedSpeed
    
    if( [me getSpecEnum] == SPEC_HUNT_BM ||
       [me getSpecEnum] == SPEC_HUNT_MARK ||
       [me getSpecEnum] == SPEC_HUNT_SUR)
    {
        
        mindmg = [[[me getStats] objectForKey:@"rangedDmgMin"] intValue];
        maxdmg = [[[me getStats] objectForKey:@"rangedDmgMax"] intValue];
    }
    else
    {
        mindmg = [[[me getStats] objectForKey:@"mainHandDmgMin"] intValue];
        maxdmg = [[[me getStats] objectForKey:@"mainHandDmgMax"] intValue];
    }
    int armor = [[[me getStats] objectForKey:@"armor"] integerValue];
    
    double reduction = (armor / ((85.0*myEnemy.level) + armor + 400.0));
    int dmg = (arc4random()%(maxdmg - mindmg)) + mindmg;
    dmg -= dmg * reduction;
    
    double r = (arc4random()%100000) * 0.001;
    if( crit >= r )
        dmg *= 2;
    
    return dmg;
}

-(void)generatecombatTextWithRespectTo: (CGPoint)point withDamage:(int)dmg
{
    CombatText *txt = [[CombatText alloc] initWithPosX:point.x + 20 andPosY:point.y - 40];
    txt.text.text = [NSString stringWithFormat:@"%d", dmg];
    txt.text.textColor = [UIColor redColor];
    txt.text.font = [UIFont fontWithName:@"Superclarendon-Bold" size:20.0f];
    [combatText addObject:txt];
    [self.view addSubview:txt.text];
}

-(void)myChampHeal
{
    int SP = [[[_myChampInfo getStats] objectForKey:@"spellPower"] intValue];
    int range = (arc4random()%SP) + SP;
    
    double crit = [[[_myChampInfo getStats] objectForKey:@"crit"] doubleValue];
    
    double r = (arc4random()%100000) * 0.001;
    if( crit >= r )
        range*=2;
    
    playerHP += range;
    
    int hp =[[[_myChampInfo getStats] objectForKey:@"health"] integerValue];
    
    if( hp > 0 )
    {
        labelMyChampHP.text = [NSString stringWithFormat:@"HP: %d", playerHP];
        progressMyChampHealth.progress = ((100*playerHP)/hp) * 0.01;
    }
    
    CGPoint p = progressMyChampHealth.frame.origin;
    CombatText *txt = [[CombatText alloc] initWithPosX:p.x + 20 andPosY:p.y - 40];
    txt.text.text = [NSString stringWithFormat:@"%d", range];
    txt.text.textColor = [UIColor greenColor];
    txt.text.font = [UIFont fontWithName:@"Superclarendon-Bold" size:20.0f];
    [combatText addObject:txt];
    [self.view addSubview:txt.text];
}

-(void)myOpponantHeal
{
    int SP = [[[_myOpponantInfo getStats] objectForKey:@"spellPower"] intValue];
    int range = (arc4random()%SP) + SP;
    
    double crit = [[[_myOpponantInfo getStats] objectForKey:@"crit"] doubleValue];
    
    double r = (arc4random()%100000) * 0.001;
    if( crit >= r )
        range*=2;
    
    opponantHP += range;
    
    int hp =[[[_myOpponantInfo getStats] objectForKey:@"health"] integerValue];
    
    if( hp > 0 )
    {
        labelOpponentHP.text = [NSString stringWithFormat:@"HP: %d", opponantHP];
        
        progressOpponantHealth.progress = ((100*opponantHP)/hp) * 0.01;
    }
    
    CGPoint p = progressOpponantHealth.frame.origin;
    CombatText *txt = [[CombatText alloc] initWithPosX:p.x + 20 andPosY:p.y - 40];
    txt.text.text = [NSString stringWithFormat:@"%d", range];
    txt.text.textColor = [UIColor greenColor];
    txt.text.font = [UIFont fontWithName:@"Superclarendon-Bold" size:20.0f];
    [combatText addObject:txt];
    [self.view addSubview:txt.text];
}

-(void)updateCombatText
{
    NSTimeInterval deltaTime;
    NSDate *now = [NSDate date];
    
    if( previousDateForTimestep )
        deltaTime = [now timeIntervalSinceDate:previousDateForTimestep];
    else
        deltaTime = 0;

    NSMutableArray* toRemove = [[NSMutableArray alloc] init];
    
    for(CombatText* txt in combatText)
    {
        if( txt.deleteME )
            [toRemove addObject:txt];
        else
            [txt updateMe:deltaTime];
    }
    
    for( CombatText* txt in toRemove)
    {
        [combatText removeObject:txt];
    }
    [toRemove removeAllObjects];
    
    previousDateForTimestep = now;
    
    if( endCombatText && combatText.count == 0)
        [updateTimer invalidate];
}

-(BOOL)checkIfCharShouldHeal:(CharacterInformation*)charinfo
{
    switch ([charinfo getSpecEnum]) {
        case SPEC_DRUID_RESTO:
        case SPEC_MONK_MIST:
        case SPEC_PALY_HOLY:
        case SPEC_PRIEST_DISC:
        case SPEC_PRIEST_HOLY:
        case SPEC_SHAM_RESTO:
            return YES;
    }
    return NO;
}

-(BOOL)checkIfCharShouldUseOffHand:(CharacterInformation*)charinfo
{
    switch ([charinfo getSpecEnum]) {
        case SPEC_ROGUE_ASS:
        case SPEC_ROGUE_COMB:
        case SPEC_ROGUE_SUB:
        case SPEC_SHAM_ENH:
        case SPEC_WAR_FURY:
            return YES;
    }
    return NO;
}

@end
