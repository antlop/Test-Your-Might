//
//  StatsTableViewController.m
//  WoW_TestYourProwess
//
//  Created by Anton lopez on 6/11/15.
//  Copyright (c) 2015 Anton lopez. All rights reserved.
//

#import "StatsTableViewController.h"
#import "StatsTableViewCell.h"

@interface StatsTableViewController ()
{
    
    int index;
}

@end

@implementation StatsTableViewController

//-(instancetype)init: (CGRect)rect withOriginalStatsDictionary: (NSMutableDictionary*)stats andValidToPrintDictionary:(NSMutableDictionary*)toPrint
//{
//    self = [super init];
//    if( self )
//    {
//        self.view.frame = rect;
//        characterStats = stats;
//        toPrintDict = toPrint;
//        self.view.backgroundColor = [UIColor clearColor];
//        keys = (NSMutableArray*)[characterStats allKeys];
//        
//        index = 0;
//    }
//    return self;
//}


-(instancetype)init: (CGRect)rect withOriginalStatsDictionary: (NSArray*)stats
{
    self = [super init];
    if( self )
    {
        self.view.frame = rect;
        statsArray = stats;
        self.view.backgroundColor = [UIColor clearColor];
        keys = (NSMutableArray*)[_characterStats allKeys];
        self.tableView.separatorInset = UIEdgeInsetsZero;
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        self.tableView.bounces = NO;
        self.tableView.userInteractionEnabled = NO;
        
        index = 0;
    }
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    if(self)
    {
        [self.tableView registerClass:[StatsTableViewCell class] forCellReuseIdentifier:@"stat"];
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _characterStats.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 20;
}

//
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    switch (_group) {
//        case STATS_ATTACK:
//            return @"Attack Stats";
//            
//        case STATS_ATTRIBUTES:
//            return @"Attribute Stats";
//            
//        case STATS_DEFENCE:
//            return @"Defence Stats";
//            
//        case STATS_ENHANCEMENTS:
//            return @"Enhancement Stats";
//            
//        case STATS_SPELL:
//            return @"Spell Stats";
//    }
//    return nil;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    StatsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"stat"
                                                               forIndexPath:indexPath];
    cell = [cell initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"stat"];
    
    
    //[cell setInfo:[statsArray objectAtIndex:indexPath.section] atIndex:indexPath.row];
    [cell setInfo:_characterStats atIndex:indexPath.row];
    
    if( indexPath.row % 2 == 0)
        cell.backgroundColor = [UIColor colorWithRed: 0.5 green:0.3 blue:0 alpha:0.3];
    else
        cell.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.detailTextLabel.backgroundColor = [UIColor clearColor];
    
    return cell;
}


@end
