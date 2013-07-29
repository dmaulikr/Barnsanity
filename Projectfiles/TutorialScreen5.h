//
//  TutorialScreen5.h
//  Veggy_V_Fruit
//
//  Created by Danny on 7/26/13.
//  Copyright (c) 2013 MakeGamesWithUs Inc. All rights reserved.
//

#import "CCLayer.h"
#import "Game.h"
#import "CCSpriteBackgroundNode.h"
#import "CCBackgroundColorNode.h"
@interface TutorialScreen5 : CCLayer
{
    CCMenu *menu;
    CCMenuItemSprite *whatIFound;
    CCMenuItemSprite *tapToDrop;
    CCMenuItemSprite *onePerLevel;
    CCMenuItemSprite *finish;
    int count;
    int waitCount;
    BOOL checkPoint1;
    BOOL checkPoint2;
    BOOL checkPoint3;
    BOOL checkPoint4;
    BOOL readyForBomb;
}
- (id)initWithGame;
@end
