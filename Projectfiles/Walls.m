//
//  Walls.m
//  Veggy_V_Fruit
//
//  Created by Danny on 7/18/13.
//  Copyright (c) 2013 MakeGamesWithUs Inc. All rights reserved.
//

#import "Walls.h"
#import "GameMechanics.h"
@implementation Walls
- (id)initWithMonsterPicture{
     @throw @"- (id)initWithMonsterPicture has to be implemented in Subclass.";
}
- (void)gotHit:(int)damage{
    //deduct hitpoint by damage
    self.hitPoints -=damage;
    //if hitpoint is 0 or less then the monster dies
    if(self.hitPoints<=0){
        self.invincible=TRUE;
        [self destroy];
    }else if(blinkDidRun==FALSE || [blink isDone]){
        blinkDidRun=TRUE;
        [self runAction:blink];
    }
}

- (void)spawnAt:(float) angleOfLocation{
    //resume update and run animation
    [self stopAllActions];
    
    radiusOfWorld=[[GameMechanics sharedGameMechanics] gameScene].radiusOfWorld;
    self.radiusToSpawn=radiusOfWorld+CCRANDOM_MINUS1_1()*self.radiusToSpawnDelta-5;
    self.boundingZone=atanf((self.contentSize.width/2)/(radiusOfWorld+self.contentSize.height/2))/2;
    self.hitZone=0;
    //set health
    self.hitPoints=self.hitPointsInit;
    
    //angle of the spawn
    self.angle= angleOfLocation;
    self.angle=fmodf(self.angle+2*M_PI, 2*M_PI);
    // Select a spawn location
    float xPos=self.radiusToSpawn*cos(self.angle);
    float yPos=self.radiusToSpawn*sin(self.angle);
    
    //set the location
    self.position = CGPointMake(xPos, yPos);
    self.rotation=CC_RADIANS_TO_DEGREES(-self.angle+M_PI_2);
    
    self.boundingZoneAngle1=self.angle+self.boundingZone;
    self.boundingZoneAngle1=fmodf(self.boundingZoneAngle1+2*M_PI, 2*M_PI);
    self.boundingZoneAngle2=self.angle-self.boundingZone;
    self.boundingZoneAngle2=fmodf(self.boundingZoneAngle2+2*M_PI, 2*M_PI);
    
    // Finally set yourself to be visible, this also flag the enemy as "in use"
    self.visible = YES;
            self.invincible=FALSE;
    blinkDidRun=FALSE;

}
-(void)destroy{
    self.visible=FALSE;
    self.position=ccp(-MAX_INT,0);
}
-(void)reset{
    [self destroy];
    
    int level=[[[[[GameMechanics sharedGameMechanics]game]levelsOfEverything] objectForKey:@"Game Levels"] integerValue];
    if(level >= 0){
        NSDictionary *monsterInfo=[[[[[GameMechanics sharedGameMechanics]game]gameInfo] objectForKey:@"Game Levels"]   objectAtIndex:level];
        self.hitPointsInit=[[monsterInfo objectForKey:nameOfMonster] integerValue];
    }
}
@end
