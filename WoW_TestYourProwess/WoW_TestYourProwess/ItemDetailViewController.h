//
//  ItemDetailViewController.h
//  WoW_TestYourProwess
//
//  Created by Anton lopez on 6/19/15.
//  Copyright (c) 2015 Anton lopez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "item.h"

@interface ItemDetailViewController : UIView
{
    item* toShowItem;
    UILabel* labelName;
    UILabel* labelArmorValue;
    UILabel* labelILvl;
}

+(instancetype)getItemDetailView;

-(void)setItem: (item*)newItem atNewPosition: (CGPoint)point;

@end
