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
        
        thereMoreSpace=[CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"Tutorial6-1.png"] selectedSprite:nil block:^(id sender) {
            checkPoint1=TRUE;
            thereMoreSpace.visible=FALSE;
            wholeNewWorld.visible=TRUE;
        }];
        thereMoreSpace.position=ccp(0,0);
        
        wholeNewWorld=[CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"Tutorial6-2.png"] selectedSprite:nil block:^(id sender) {

        }];
        wholeNewWorld.visible=FALSE;
        wholeNewWorld.position=ccp(0,0);
        defendAndAttack=[CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"Tutorial6-3.png"] selectedSprite:nil block:^(id sender) {
            defendAndAttack.visible=FALSE;
            finish.visible=TRUE;
            checkPoint2=TRUE;
            waitCount=count;
        }];
        defendAndAttack.visible=FALSE;
        defendAndAttack.position=ccp(0,0);
        
        finish=[CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"Tutorial1-7.png"] selectedSprite:nil block:^(id sender) {
            
        }];
        finish.visible=FALSE;
        finish.position=ccp(0,0);
        
        
        menu=[CCMenu menuWithItems:thereMoreSpace,wholeNewWorld,defendAndAttack,finish, nil];
        menu.position=ccp(0,0);
        [self addChild:menu];
        
        count=0;
    }
    
    return self;
}

-(void)update:(ccTime)delta{
    if([[GameMechanics sharedGameMechanics] gameState]==GameStateRunning){
        count++;
        if(checkPoint1){
            [[GameMechanics sharedGameMechanics]gameScene].centerOfRotation.rotation+=1.5;
            if([[GameMechanics sharedGameMechanics]gameScene].centerOfRotation.rotation==270){
                checkPoint1=FALSE;
                wholeNewWorld.visible=FALSE;
                defendAndAttack.visible=TRUE;
            }
        }else if(checkPoint2 && count-waitCount>80){
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
