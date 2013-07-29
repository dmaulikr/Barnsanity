//
//  TutorialScreen4.h
//  Veggy_V_Fruit
//
//  Created by Danny on 7/26/13.
//  Copyright (c) 2013 MakeGamesWithUs Inc. All rights reserved.
//

#import "CCLayer.h"
#import "Game.h"
#import "CCSpriteBackgroundNode.h"
#import "CCBackgroundColorNode.h"

@interface TutorialScreen4 : CCLayer
{
    CCMenu *menu;
    CCMenuItemSprite *whatIsThis;
    CCMenuItemSprite *weeds;
    CCMenuItemSprite *handle;
    CCMenuItemSprite *finish;
    int count;
    int waitCount;
    BOOL checkPoint1;
    BOOL checkPoint2;
    BOOL checkPoint3;
}
- (id)initWithGame;
@end
