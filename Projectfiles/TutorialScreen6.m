//
//  TutorialScreen6.m
//  Veggy_V_Fruit
//
//  Created by Danny on 7/26/13.
//  Copyright (c) 2013 MakeGamesWithUs Inc. All rights reserved.
//

#import "TutorialScreen6.h"
#import "GameMechanics.h"
#import "STYLES.h"
#import "MonsterCache.h"
#import "MonsterButtonCache.h"
#import "SpawnMonsterButton.h"
@implementation TutorialScreen6
- (id)initWithGame
{
    self = [super init];
    
    if (self)
    {
        self.contentSize = [[CCDirector sharedDirector] winSize];
        // position of screen, animate to screen
        self.position = ccp(self.contentSize.width / 2, self.contentSize.height * .5);
        CCLayerColor* colorLayer = [CCLayerColor layerWithColor:SCREEN_BG_COLOR_TRANSPARENT];
        [self addChild:colorLayer z:0];
        [[GameMechanics sharedGameMechanics]gameScene].timer.visible=FALSE;
        [[GameMechanics sharedGameMechanics]gameScene].ableToRotate=FALSE;
        [[GameMechanics sharedGameMechanics]gameScene].ableToShoot=FALSE;
        [[MonsterCache sharedMonsterCache] setAbleToSpawn:FALSE];
        [[[[GameMechanics sharedGameMechanics]gameScene]energy ]resetEnergy:[[GameMechanics sharedGameMechanics]game].energyMax increasedAt:0];
        [self scheduleUpdate];
        
        thereMoreSpace=[CCSprite spriteWithFile:@"Tutorial6-1.png"];
        thereMoreSpace.position=ccp(0,0);
        [self addChild:thereMoreSpace];
        wholeNewWorld=[CCSprite spriteWithFile:@"Tutorial6-2.png"];
        wholeNewWorld.visible=FALSE;
        wholeNewWorld.position=ccp(0,0);
        [self addChild:wholeNewWorld];
        defendAndAttack=[CCSprite spriteWithFile:@"Tutorial6-3.png"];
        defendAndAttack.visible=FALSE;
        defendAndAttack.position=ccp(0,0);
        [self addChild:defendAndAttack];
        finish=[CCSprite spriteWithFile:@"Tutorial1-7.png"];
        finish.visible=FALSE;
        finish.position=ccp(0,0);
        [self addChild:finish];
        
        count=0;
        [[GameMechanics sharedGameMechanics]gameScene].touchHappened=FALSE;
        checkPoint1=TRUE;
    }
    
    return self;
}

-(void)update:(ccTime)delta{
    if([[GameMechanics sharedGameMechanics] gameState]==GameStateRunning){
        count++;
        if(checkPoint1 && [[GameMechanics sharedGameMechanics]gameScene].touchHappened){
            thereMoreSpace.visible=FALSE;
            [[GameMechanics sharedGameMechanics]gameScene].centerOfRotation.rotation+=2.5;
            if([[GameMechanics sharedGameMechanics]gameScene].centerOfRotation.rotation==270){
                checkPoint1=FALSE;
                defendAndAttack.visible=TRUE;
                checkPoint2=TRUE;
                [[GameMechanics sharedGameMechanics]gameScene].touchHappened=FALSE;
            }
        }else if(checkPoint2 && [[GameMechanics sharedGameMechanics]gameScene].touchHappened){
            defendAndAttack.visible=FALSE;
            finish.visible=TRUE;
            checkPoint3=TRUE;
            checkPoint2=FALSE;
            waitCount=count;
        }else if(checkPoint3 && count-waitCount>=80){
            [self exitTutorial];
        }
        
        
    }
}

-(void)exitTutorial{
    //remove this layer before going to the level selection layer
    self.visible = FALSE;
    [self removeFromParentAndCleanup:TRUE];
    [[[GameMechanics sharedGameMechanics]gameScene]enableGamePlayButtons];
    [[GameMechanics sharedGameMechanics]gameScene].energy.visible=TRUE;
    [[MonsterButtonCache sharedMonsterButtonCache] showButtons];
    [[[[GameMechanics sharedGameMechanics]gameScene]energy ]resetEnergy:[[GameMechanics sharedGameMechanics]game].energyMax increasedAt:[[GameMechanics sharedGameMechanics]game].energyPerSec];
    [[MonsterCache sharedMonsterCache] setAbleToSpawn:TRUE];
     [[GameMechanics sharedGameMechanics]gameScene].ableToRotate=TRUE;
     [[GameMechanics sharedGameMechanics]gameScene].ableToShoot=TRUE;
}@end
