//
//  TutorialScreen4.m
//  Veggy_V_Fruit
//
//  Created by Danny on 7/26/13.
//  Copyright (c) 2013 MakeGamesWithUs Inc. All rights reserved.
//

#import "TutorialScreen4.h"
#import "GameMechanics.h"
#import "STYLES.h"
#import "MonsterCache.h"
#import "MonsterButtonCache.h"
#import "SpawnMonsterButton.h"

@implementation TutorialScreen4
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
        
        whatIsThis=[CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"Tutorial4-1.png"] selectedSprite:nil block:^(id sender) {
            checkPoint1=TRUE;
            whatIsThis.visible=FALSE;
            
        }];
        whatIsThis.position=ccp(0,0);
        
        weeds=[CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"Tutorial4-2.png"] selectedSprite:nil block:^(id sender) {
            weeds.visible=FALSE;
            handle.visible=TRUE;
        }];
        weeds.visible=FALSE;
        weeds.position=ccp(0,0);
        
        handle=[CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"Tutorial4-3.png"] selectedSprite:nil block:^(id sender) {
            handle.visible=FALSE;
            finish.visible=TRUE;
            checkPoint3=TRUE;
            waitCount=count;
        }];
        handle.visible=FALSE;
        handle.position=ccp(0,0);
        
        finish=[CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"Tutorial1-7.png"] selectedSprite:nil block:^(id sender) {
                
            
        }];
        finish.visible=FALSE;
        finish.position=ccp(0,0);
        
        menu=[CCMenu menuWithItems:whatIsThis,weeds,handle,finish, nil];
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
            [[GameMechanics sharedGameMechanics]gameScene].centerOfRotation.rotation+=2.5;
            if([[GameMechanics sharedGameMechanics]gameScene].centerOfRotation.rotation==0){
                checkPoint1=FALSE;
                [[MonsterCache sharedMonsterCache]spawnWall:@"Tree" atAngle:M_PI_2+M_PI_4/4];
                [[MonsterCache sharedMonsterCache]spawnWall:@"ScareCrow" atAngle:M_PI_2-M_PI_4/4];
                waitCount=count;
                checkPoint2=TRUE;
            }
        }else if(checkPoint2 && count-waitCount>30){
            weeds.visible=TRUE;
            checkPoint2=FALSE;
        }else if(checkPoint3 && count-waitCount>80){
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
}
@end
