//
//  StatisticScreen.h
//  Veggy_V_Fruit
//
//  Created by Danny on 7/14/13.
//  Copyright (c) 2013 MakeGamesWithUs Inc. All rights reserved.
//

#import "CCLayer.h"
#import "Game.h"
#import "CCSpriteBackgroundNode.h"
#import "CCBackgroundColorNode.h"

@interface StatisticScreen : CCLayer
{
    CCBackgroundColorNode *backgroundNode;
    CCMenu *menu;
    CCMenuItemFont *accept;
    
}


- (id)initWithGame;
- (void)present;
@end
