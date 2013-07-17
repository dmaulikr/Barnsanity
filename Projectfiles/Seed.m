//
//  Seed.m
//  Veggy_V_Fruit
//
//  Created by Danny on 7/16/13.
//  Copyright (c) 2013 MakeGamesWithUs Inc. All rights reserved.
//

#import "Seed.h"
#import "GameMechanics.h"
@implementation Seed
- (id)initWithMonsterPicture{
    self = [super initWithFile:@"cat1.png"];
    
    if (self)
    {
        [self setScale:.12 ];
        speed=5;
        //get the radius of the world
        radiusOfWorld=[[GameMechanics sharedGameMechanics] gameScene].radiusOfWorld;
        
        //distance from the center of the world to the ship
        float worldYPos=[[[GameMechanics sharedGameMechanics] gameScene] getChildByTag:1].position.y;
        float shipYPos=[[[GameMechanics sharedGameMechanics] gameScene] getChildByTag:0].position.y;
        
        distanceToSpawn=fabsf(worldYPos-shipYPos);
        [self scheduleUpdate];
    }
    return self;
}
- (void)spawnMonster:(NSString*)name
{
    monsterName=name;
    float angleOfRotation=[[[GameMechanics sharedGameMechanics] gameScene] getChildByTag:1].rotation;
    distanceFromWorld=distanceToSpawn;
    
    //angle of the spawn
    angle= M_PI_2+CC_DEGREES_TO_RADIANS(angleOfRotation);
    
    // Select a spawn location
    float xPos=distanceToSpawn*cos(angle);
    float yPos=distanceToSpawn*sin(angle);
    
    self.rotation=CC_RADIANS_TO_DEGREES(-angle+M_PI_2);
    self.position=ccp(xPos,yPos);
    
    self.visible=TRUE;
        [self resumeSchedulerAndActions];
}


- (void)update:(ccTime)delta
{
    // only execute the block, if the game is in 'running' mode
    if ([[GameMechanics sharedGameMechanics] gameState] == GameStateRunning)
    {
        if(self.visible){
            [self updateRunningMode:delta];
        }
    }
}
-(void)destroy{
    self.visible=FALSE;
    self.position = ccp(-MAX_INT, 0);
    [self pauseSchedulerAndActions];
}
-(void)plant{
    [[MonsterCache sharedMonsterCache] spawn:monsterName atAngle:angle];
}
- (void)updateRunningMode:(ccTime)delta
{
    distanceFromWorld-=speed;
    if(distanceFromWorld <= radiusOfWorld){
        [self plant];
        [self destroy];
    }
    float deltaX=distanceFromWorld*cos(angle);
    float deltaY=distanceFromWorld*sin(angle);
    CGPoint newPosition = ccp(deltaX, deltaY);
    [self setPosition:newPosition];
    
    
    
}

-(void)reset{
    [self destroy];
    
}


@end
