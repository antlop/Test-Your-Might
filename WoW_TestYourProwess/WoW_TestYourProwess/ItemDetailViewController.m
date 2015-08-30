//
//  ItemDetailViewController.m
//  WoW_TestYourProwess
//
//  Created by Anton lopez on 6/19/15.
//  Copyright (c) 2015 Anton lopez. All rights reserved.
//

#import "ItemDetailViewController.h"

@interface ItemDetailViewController ()

@end

@implementation ItemDetailViewController


+(instancetype)getItemDetailView
{
    static ItemDetailViewController* me;
    if(me != nil)
        return me;
    me = [[ItemDetailViewController alloc]init];
    
    me->labelName = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 160, 30)];
    me->labelILvl = [[UILabel alloc]initWithFrame:CGRectMake(10, 35, 160, 15)];
    me->labelArmorValue = [[UILabel alloc]initWithFrame:CGRectMake(10, 55, 160, 15)];
    
    
    me->labelName.font = [UIFont fontWithName:@"Superclarendon" size:10.0f];
    me->labelName.numberOfLines = 2;
    me->labelILvl.font = [UIFont fontWithName:@"Superclarendon" size:10.0f];
    me->labelArmorValue.font = [UIFont fontWithName:@"Superclarendon" size:10.0f];
    
    
    me->labelName.textColor = [UIColor whiteColor];
    me->labelILvl.textColor = [UIColor whiteColor];
    me->labelArmorValue.textColor = [UIColor whiteColor];
    
    me.frame = CGRectMake(4, 62, 165, 85);
    
    //Ability_warrior_charge
   // UIGraphicsEndImageContext();
    UIImage *img = [UIImage imageNamed:@"Ability_warrior_charge.png"];
    CGSize size = me.frame.size;
    UIGraphicsBeginImageContextWithOptions(size, YES, 1.0f);
    
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *background = UIGraphicsGetImageFromCurrentImageContext();
    UIColor *bgColor = [[UIColor alloc] initWithPatternImage:background];
    me.backgroundColor = bgColor;
    UIGraphicsEndImageContext();
    
    me.opaque = YES;
    
    [me addSubview:me->labelName];
    [me addSubview:me->labelILvl];
    [me addSubview:me->labelArmorValue];
    return me;
}

-(void)setItem: (item*)newItem atNewPosition: (CGPoint)point
{
    toShowItem = newItem;
    self.center = point;
    
    labelName.text = newItem.szName;
    labelILvl.text = [NSString stringWithFormat:@"ilvl %d", newItem.nItemLvl];
    labelArmorValue.text = [NSString stringWithFormat:@"Armor Value: %d", newItem.nArmor];
}

@end
