//
//  OnlineChampionsTableViewCell.h
//  WoW_TestYourProwess
//
//  Created by Anton lopez on 7/6/15.
//  Copyright (c) 2015 Anton lopez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OnlineChampionsTableViewCell : UITableViewCell
{
    IBOutlet UIImageView* o_iconImage;
}

@property (strong, nonatomic) NSString* m_szName;

@end
