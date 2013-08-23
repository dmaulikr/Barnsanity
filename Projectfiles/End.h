//
//  End.h
//  Barnsanity
//
//  Created by Danny on 8/22/13.
//  Copyright (c) 2013 MakeGamesWithUs Inc. All rights reserved.
//

#import "CCLayer.h"
#import "Game.h"
#import "CCSpriteBackgroundNode.h"
#import "CCBackgroundColorNode.h"

@interface End : CCLayer
{
    CCMenu *menu;
    CCSprite *thereMoreSpace;
    CCSprite *wholeNewWorld;
    CCSprite *defendAndAttack;
    CCSprite *finish;
    int count;
    int waitCount;
    BOOL checkPoint1;
    BOOL checkPoint2;
    BOOL checkPoint3;
}
@end
