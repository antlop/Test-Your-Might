//
//  StatsTableViewCell.m
//  WoW_TestYourProwess
//
//  Created by Anton lopez on 6/11/15.
//  Copyright (c) 2015 Anton lopez. All rights reserved.
//

#import "StatsTableViewCell.h"

@implementation StatsTableViewCell

- (instancetype)init
{
    self = [super init];
    if (self) {
        infoLabel = nil;
    }
    return self;
}



-(BOOL)setInfo: (NSMutableDictionary*)stats atIndex: (int)index
{
    NSArray* keys = [stats allKeys];
    self.textLabel.text = [NSString stringWithFormat:@"%@", [keys objectAtIndex:index]];
    self.textLabel.font = [UIFont fontWithName:@"Superclarendon" size:10];
    float x = self.contentView.frame.size.width * 0.75;
    
    if( infoLabel == nil )
    {
        infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, 1, x, 18)];
        infoLabel.text = [NSString stringWithFormat:@" %@", [stats objectForKey:[keys objectAtIndex:index]]];
        infoLabel.font = [UIFont fontWithName:@"Superclarendon" size:10.0f];
        infoLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:infoLabel];
//        
//        CAGradientLayer *gradient = [CAGradientLayer layer];
//        gradient.frame = infoLabel.bounds;
//        
//        gradient.colors = [NSArray arrayWithObjects:(id)[[[UIColor brownColor] colorWithAlphaComponent:0.5] CGColor], (id)[[[UIColor blackColor] colorWithAlphaComponent:0.5] CGColor], nil];
//        [infoLabel.layer insertSublayer:gradient atIndex:0];
    }
    else
    {
        infoLabel.text = [NSString stringWithFormat:@" %@", [stats objectForKey:[keys objectAtIndex:index]]];
    }
    
    
    //self.detailTextLabel.text = [NSString stringWithFormat:@"%@", [stats objectForKey:key]];
    return YES;

}

@end
