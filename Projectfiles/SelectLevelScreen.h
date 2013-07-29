//
//  SelectLevelScreen.h
//  Veggy_V_Fruit
//
//  Created by Danny on 7/10/13.
//  Copyright (c) 2013 MakeGamesWithUs Inc. All rights reserved.
//

#import "CCLayer.h"
#import "Game.h"
#import "CCSpriteBackgroundNode.h"
#import "CCBackgroundColorNode.h"


@interface SelectLevelScreen : CCLayer
{
    CCBackgroundColorNode *backgroundNode;
    CCMenu *menu;
    CCLabelTTF *requiredLevel;
    
    //level
    int levelToPlay;
    int maxLevelToPlay;
    
    //for level selection
    CCMenu *levelSelection;
    CCLabelBMFont *level;
    CCMenuItemSprite *decreaseLevel;
    CCMenuItemSprite *increaseLevel;
    
    //menu buttons
    CCMenuItemFont *playLevel;
    CCMenuItemFont *option;
    CCMenuItemFont *store;
    CCMenuItemSprite *volumeControl;
}

- (id)initWithGame;
-(void)present;
@end
