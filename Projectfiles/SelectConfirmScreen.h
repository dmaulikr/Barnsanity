//
//  QuitConfirmScreen.h
//  Veggy_V_Fruit
//
//  Created by Danny on 7/22/13.
//  Copyright (c) 2013 MakeGamesWithUs Inc. All rights reserved.
//

#import "CCLayer.h"
#import "Game.h"
#import "CCSpriteBackgroundNode.h"
#import "CCBackgroundColorNode.h"

@interface SelectConfirmScreen : CCLayer
{
        CCBackgroundColorNode *backgroundNode;
    CCMenu *menu;
    CCMenuItemSprite *yes;
    CCMenuItemSprite *no;

}

- (id)initWithGame;
@end
