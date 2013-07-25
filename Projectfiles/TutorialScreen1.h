//
//  TutorialScreen.h
//  Veggy_V_Fruit
//
//  Created by Danny on 7/19/13.
//  Copyright (c) 2013 MakeGamesWithUs Inc. All rights reserved.
//

#import "CCLayer.h"
#import "Game.h"
#import "CCSpriteBackgroundNode.h"
#import "CCBackgroundColorNode.h"
#import "SpawnMonsterButton.h"


@interface TutorialScreen1 : CCLayer
{

    CCMenu *menu;
    CCMenuItemSprite *monsterButton;
    
    CCMenuItemSprite* yourBarn;
    CCMenuItemSprite* enemyBarn;
    CCMenuItemSprite* firstPlant;
    CCMenuItemSprite* plantMore;
    CCMenuItemSprite* swipeToMove;
    CCMenuItemSprite* cantPlant;
    CCMenuItemSprite* play;
    CCSprite* pointToSeed;
    CCSprite* pointToButton;
    CCSprite* swipe;
    
    CCSprite *firstButton;
    
    SpawnMonsterButton *orangeButton;
    CCBlink *blink;
    int count;
    int waitCount;
    int monsterProduced;
    BOOL didMove;
    BOOL blinkDidRun;
    BOOL checkPoint1;
    BOOL checkPoint2;
    BOOL checkPoint3;
     BOOL checkPoint4;
     BOOL checkPoint5;
     BOOL checkPoint6;
    BOOL checkPoint7;
}

- (id)initWithGame;
@end
