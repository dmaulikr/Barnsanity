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

    CCSprite *whatIFound;
    CCSprite *tapToDrop;
    CCSprite *onePerLevel;
     CCSprite *missed;
    CCSprite *finish;
    int count;
    int waitCount;
    BOOL checkPoint1;
    BOOL checkPoint2;
    BOOL checkPoint3;
    BOOL checkPoint4;
    BOOL checkPoint5;
    BOOL readyForBomb;
    BOOL monsterKilled;
    BOOL missedBomb;
}
- (id)initWithGame;
@end
