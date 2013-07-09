//
//  MonsterButtonCache.h
//  Veggy_V_Fruit
//
//  Created by Danny on 7/8/13.
//  Copyright (c) 2013 MakeGamesWithUs Inc. All rights reserved.
//

#import "CCNode.h"

@interface MonsterButtonCache : CCNode
{
    //a dictionary to hold the array of different monster units
    NSMutableDictionary* monsterButton;
}
+ (id)sharedMonsterButtonCache;
-(void)placeButton:(Class)buttonClass atLocation:(int) place;
@end