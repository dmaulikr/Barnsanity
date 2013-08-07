//
//  TutorialScreen5.m
//  Veggy_V_Fruit
//
//  Created by Danny on 7/26/13.
//  Copyright (c) 2013 MakeGamesWithUs Inc. All rights reserved.
//

#import "TutorialScreen5.h"
#import "GameMechanics.h"
#import "STYLES.h"
#import "MonsterCache.h"
#import "MonsterButtonCache.h"
#import "SpawnMonsterButton.h"
@implementation TutorialScreen5
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
         [[[GameMechanics sharedGameMechanics]gameScene]disableGameplayButtons];
        [self scheduleUpdate];
        
        whatIFound=[CCSprite spriteWithFile:@"Tutorial5-1.png"];
        whatIFound.position=ccp(0,0);
        [self addChild:whatIFound];
        tapToDrop=[CCSprite spriteWithFile:@"Tutorial5-2.png"];
        tapToDrop.visible=FALSE;
        tapToDrop.position=ccp(0,0);
        [self addChild:tapToDrop];
        onePerLevel=[CCSprite spriteWithFile:@"Tutorial5-3.png"];
        onePerLevel.visible=FALSE;
        onePerLevel.position=ccp(0,0);
        [self addChild:onePerLevel];
        missed=[CCSprite spriteWithFile:@"Tutorial5-4.png"];
        missed.visible=FALSE;
        missed.position=ccp(0,0);
        [self addChild:missed];
        finish=[CCSprite spriteWithFile:@"Tutorial1-7.png"];
        finish.visible=FALSE;
        finish.position=ccp(0,0);
        [self addChild:finish];
        
        checkPoint1=TRUE;
        count=0;
        monsterKilled=TRUE;
        [[GameMechanics sharedGameMechanics]gameScene].touchHappened=FALSE;
    }
    
    return self;
}

-(void)update:(ccTime)delta{
    if([[GameMechanics sharedGameMechanics] gameState]==GameStateRunning){
        count++;
        if(checkPoint1 && [[GameMechanics sharedGameMechanics]gameScene].touchHappened){
            whatIFound.visible=FALSE;
            [[GameMechanics sharedGameMechanics]gameScene].centerOfRotation.rotation+=2.5;
            if([[GameMechanics sharedGameMechanics]gameScene].centerOfRotation.rotation==0){
                checkPoint1=FALSE;
                checkPoint2=TRUE;
            }
        }else if(checkPoint2){
        
            for(int i=0; i<60;i++){
                [[MonsterCache sharedMonsterCache]spawnEnemyOfType:@"Carrot" atAngle:M_PI_2+M_PI_4/4+CCRANDOM_MINUS1_1()*M_PI_4/6 ];
            }
            for(int i=0; i<5;i++){
                [[MonsterCache sharedMonsterCache]spawn:@"Orange" atAngle:M_PI_2-M_PI_4/4+CCRANDOM_MINUS1_1()*M_PI_4/8 ];
            }
            monsterKilled=FALSE;
            [[[GameMechanics sharedGameMechanics]gameScene].ship runAction:[CCRepeatForever actionWithAction:[CCBlink actionWithDuration:1.5f blinks:1]]];
                  [[GameMechanics sharedGameMechanics]gameScene].ship.bombUsed=FALSE;
            checkPoint2=FALSE;
            tapToDrop.visible=TRUE;
            readyForBomb=TRUE;
            waitCount=count;
        }else if(checkPoint3){
            onePerLevel.visible=TRUE;
            [[MonsterCache sharedMonsterCache] reset];
            checkPoint3=FALSE;
            checkPoint4=TRUE;
            [[GameMechanics sharedGameMechanics]gameScene].touchHappened=FALSE;
        }else if(checkPoint4 && [[GameMechanics sharedGameMechanics]gameScene].touchHappened){
            onePerLevel.visible=FALSE;
            finish.visible=TRUE;
            checkPoint4=FALSE;
            checkPoint5=TRUE;
            waitCount=count;
        }else if(checkPoint5 && count-waitCount>=80){
            [self exitTutorial];
        }else if(missedBomb && [[GameMechanics sharedGameMechanics]gameScene].touchHappened){
            missedBomb=FALSE;
            checkPoint2=TRUE;
                missed.visible=FALSE;
                [[MonsterCache sharedMonsterCache] reset];
            [[MonsterCache sharedMonsterCache] setAbleToSpawn:FALSE];
                [[MonsterCache sharedMonsterCache]gameResumed];
            
        }
        
        if(readyForBomb){
            if([[MonsterCache sharedMonsterCache] theBomb].alive){
                readyForBomb=FALSE;
                tapToDrop.visible=FALSE;
                [[[GameMechanics sharedGameMechanics]gameScene].ship stopAllActions];
                waitCount=count-300;
            }
        }
        
        if(!monsterKilled && count-waitCount>600){
            if(![[MonsterCache sharedMonsterCache]anyMonsterAliveOfType:@"Carrot"]){
                monsterKilled=TRUE;
                checkPoint3=TRUE;
            }else{
                tapToDrop.visible=FALSE;
                monsterKilled=TRUE;
                missedBomb=TRUE;
                [[MonsterCache sharedMonsterCache] gamePaused];
                missed.visible=TRUE;
                [[GameMechanics sharedGameMechanics]gameScene].touchHappened=FALSE;
            }
        }
    }
}

-(void)exitTutorial{
    //remove this layer before going to the level selection layer
    self.visible = FALSE;
    [self removeFromParentAndCleanup:TRUE];
    [[[GameMechanics sharedGameMechanics]gameScene]enableGamePlayButtons];
    [[GameMechanics sharedGameMechanics]gameScene].energy.visible=TRUE;
      [[GameMechanics sharedGameMechanics]gameScene].ship.bombUsed=FALSE;
    [[GameMechanics sharedGameMechanics]gameScene].ship.visible=TRUE;
    [[MonsterButtonCache sharedMonsterButtonCache] showButtons];
    [[[[GameMechanics sharedGameMechanics]gameScene]energy ]resetEnergy:[[GameMechanics sharedGameMechanics]game].energyMax increasedAt:[[GameMechanics sharedGameMechanics]game].energyPerSec];
    [[MonsterCache sharedMonsterCache] setAbleToSpawn:TRUE];
     [[GameMechanics sharedGameMechanics]gameScene].ableToRotate=TRUE;
     [[GameMechanics sharedGameMechanics]gameScene].ableToShoot=TRUE;
}
@end
