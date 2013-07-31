//
//  OptionScreen.h
//  Veggy_V_Fruit
//
//  Created by Danny on 7/25/13.
//  Copyright (c) 2013 MakeGamesWithUs Inc. All rights reserved.
//

#import "CCLayer.h"
#import "Game.h"
#import "CCSpriteBackgroundNode.h"
#import "CCBackgroundColorNode.h"
#import "PopUp.h"
@interface OptionScreen : CCLayer
{
    CCBackgroundColorNode *backgroundNode;
    CCMenu *menu;
    CCMenuItemSprite *resetGame;
    CCMenuItemSprite *back;
    BOOL disableMenuButtons;
    PopUp *goOnPopUp;
}

- (id)initWithGame;
@end
