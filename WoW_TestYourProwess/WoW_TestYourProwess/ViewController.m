//
//  ViewController.m
//  WoW_TestYourProwess
//
//  Created by Anton lopez on 6/11/15.
//  Copyright (c) 2015 Anton lopez. All rights reserved.
//

#import "ViewController.h"
#import "ArrayCreator.h"
#import "CharacterInformation.h"

@interface ViewController () <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>
{
    NSArray* realmList;
    UIPickerView* picker_RealmList;
    NSInteger nSelectedRealmRow;
    CharacterInformation *charInfo;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSString *pageSFXPath = [[NSBundle mainBundle]
                             pathForResource:@"Harlem Shake" ofType:@"wav"];
    NSURL *pageSFXURL = [NSURL fileURLWithPath:pageSFXPath];
    shakePlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:pageSFXURL
                                                         error:nil];
    shakePlayer.numberOfLoops = 0;
    
    txtTrans = textField_CharacterName.transform;
    pickerTrans = picker_Server.transform;
    bgTrans = imageBGForTextField.transform;
    btnTrans = buttonForSelection.transform;
    
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
    
    
    ////// fills the realm list with an array of strings
    realmList = [ArrayCreator createServerArray];
    nSelectedRealmRow = 0;
    
    
    ////// the picker for selecting a realm
    picker_RealmList = [[UIPickerView alloc] initWithFrame:CGRectMake(75, 0, self.view.frame.size.width-100, 285)];
    picker_RealmList.dataSource = self;
    picker_RealmList.delegate = self;
    picker_RealmList.center = self.view.center;
    picker_RealmList.backgroundColor = [UIColor clearColor];
    [self.view addSubview:picker_RealmList];
    
    
    ////// initialize the player character information
    charInfo = [[CharacterInformation alloc] init];
    
    
    ////// this is a foreground image for the picker
    selectorImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 235)];
    selectorImage.image = [UIImage imageNamed:@"realmPicker.png"];
    selectorImage.center = self.view.center;
    [self.view addSubview:selectorImage];
    imgTrans = selectorImage.transform;
    
    
    ////// Load saved info //////
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if( [defaults objectForKey:@"champName"])
    {
        
        NSString *name = [defaults objectForKey:@"champName"];
        [charInfo setName:name];
        textField_CharacterName.text = name;

    }
    if( [defaults objectForKey:@"realmName"])
    {
        NSString *realm = [defaults objectForKey:@"realmName"];
        
        [charInfo setRealm:realm];
        
        for( int i = 0; i < realmList.count; ++i )
        {
            if( [realmList[i] isEqualToString:realm])
            {
                nSelectedRealmRow = i;
                break;
            }
        }
        [picker_RealmList selectRow:nSelectedRealmRow inComponent:0 animated:YES];
       
      //  [[NSNotificationCenter defaultCenter] postNotificationName:@"LOAD_CHAR" object:charInfo];
        
        ////// switch to the character information tab
      //  [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(changeTab) userInfo:nil repeats:NO];
        return;
    }
    
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Be Warned" message:@"Pick Carefully! You will be bound with your choice forever!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
  // [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(changeTab) userInfo:nil repeats:NO];
    
    
    textField_CharacterName.delegate = self;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
     [textField_CharacterName resignFirstResponder];
    return YES;
}

-(void)warnTheUser
{
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Be Warned" message:@"Pick Carefully! You will be bound with your choice forever!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    
    [alert show];
}

-(void)changeTab
{
    [self.tabBarController setSelectedIndex:1];
    self.tabBarItem.enabled = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

////////// Button Action //////////
-(IBAction)downloadCharacterButtonClicked:(id)sender
{
    if( textField_CharacterName.text.length < 1 )
    {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"You need to fill out the character name field" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    else if( [textField_CharacterName.text isEqualToString:@"ududlrlraabb"] )
    {
        [shakePlayer prepareToPlay];
        [shakePlayer play];
        
        [NSTimer scheduledTimerWithTimeInterval:15.0f target:self selector:@selector(animate) userInfo:nil repeats:NO];
        [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(firstanimate) userInfo:nil repeats:NO];
    }
    else
    {
        ////// set the character information to use to look it up in the API
        [charInfo setName:textField_CharacterName.text];
        [charInfo setRealm:[realmList objectAtIndex:nSelectedRealmRow]];
    
        ////// notify the other views that the user wants to load a character
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LOAD_CHAR" object:charInfo];
        
        ////// switch to the character information tab
        [self changeTab];
    }
}
-(void)firstanimate
{
    [UIView animateWithDuration:0.25f delay:0.0f options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat animations:^{
        // shake them
        
        buttonForSelection.transform = CGAffineTransformTranslate(buttonForSelection.transform, arc4random()%100, 0.0f);
        
    } completion:^(BOOL finished) {
        
        buttonForSelection.transform = btnTrans;
    } ];

}

-(void)animate
{
    if( [shakePlayer isPlaying])
    {
        [UIView animateWithDuration:0.25f delay:0.0f options:UIViewAnimationOptionAutoreverse  animations:^{
            // shake them
            
            textField_CharacterName.transform = CGAffineTransformTranslate(textField_CharacterName.transform, arc4random()%100, 0.0f);
            picker_Server.transform = CGAffineTransformTranslate(picker_Server.transform, arc4random()%100, 0.0f);
            imageBGForTextField.transform = CGAffineTransformTranslate(imageBGForTextField.transform, arc4random()%100, 0.0f);
            buttonForSelection.transform = CGAffineTransformTranslate(buttonForSelection.transform, arc4random()%100, 0.0f);
            
            int r1 = arc4random()%50+20;
            int r2 = arc4random()%50+20;
            int r3 = arc4random()%50+20;
            int r4 = arc4random()%50+20;
            if( arc4random()%2==0)
                r1 *= -1;
            if( arc4random()%2==0)
                r2 *= -1;
            if( arc4random()%2==0)
                r3 *= -1;
            if( arc4random()%2==0)
                r4 *= -1;
            
            textField_CharacterName.transform = CGAffineTransformRotate(textField_CharacterName.transform, r1);
            picker_Server.transform = CGAffineTransformRotate(picker_Server.transform, r2);
            imageBGForTextField.transform = CGAffineTransformRotate(imageBGForTextField.transform, r3);
            buttonForSelection.transform = CGAffineTransformRotate(buttonForSelection.transform, r4);
            
            
            selectorImage.transform = CGAffineTransformScale(selectorImage.transform, (arc4random()%100+20)*0.01f, (arc4random()%100+20)*0.01f);
        } completion:^(BOOL finished) {
            // set back to original
            textField_CharacterName.transform = txtTrans;
            picker_Server.transform = pickerTrans;
            imageBGForTextField.transform = bgTrans;
            buttonForSelection.transform = btnTrans;
            selectorImage.transform = imgTrans;
            [self animate];
        } ];
    }
    else
    {
        textField_CharacterName.transform = txtTrans;
        picker_Server.transform = pickerTrans;
        imageBGForTextField.transform = bgTrans;
        buttonForSelection.transform = btnTrans;
    }
}

-(IBAction)login:(id)sender
{
    ////// not yet used
    ////// need to learn OAuth 2.0
}

////////// Picker View Methods /////////
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
  
    return realmList.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [NSString stringWithFormat:@"%@",[realmList objectAtIndex:row]];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    nSelectedRealmRow = row;
    
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 50;
}


@end
