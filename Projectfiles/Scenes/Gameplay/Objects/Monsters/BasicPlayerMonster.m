//
//  BasicPlayerMonster.m
//  AngryVeggie
//
//  Created by Danny on 6/21/13.
//
//

#import "BasicPlayerMonster.h"
#import "GameMechanics.h"
#import "math.h"

@implementation BasicPlayerMonster

- (void)spawnAt:(float) angleOfLocation
{
    //resume update and run animation
    [self stopAllActions];
    
    radiusOfWorld=[[GameMechanics sharedGameMechanics] gameScene].radiusOfWorld;
    self.radiusToSpawn=radiusOfWorld+CCRANDOM_MINUS1_1()*self.radiusToSpawnDelta-5;
    self.boundingZone=atanf((self.contentSize.width/2)/(radiusOfWorld+self.contentSize.height/2))/2.5;
    self.hitZone=CCRANDOM_MINUS1_1()*(M_PI/550)+self.range*atanf((self.contentSize.width/2)/(radiusOfWorld+self.contentSize.height/2))/2;
    [self setZOrder:(NSInteger)((2*radiusOfWorld)-self.radiusToSpawn)];
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
    
    //set location and move direction
    if([[GameMechanics sharedGameMechanics]game].difficulty==EASY){
        self.moveDirection=left;
        self.flipX=180;
        self.hitZoneAngle1=self.angle+self.hitZone;
        self.hitZoneAngle1=fmodf(self.hitZoneAngle1+2*M_PI, 2*M_PI);
        self.hitZoneAngle2=self.angle;
        self.hitZoneAngle2=fmodf(self.hitZoneAngle2+2*M_PI, 2*M_PI);
    }else{
        if(self.angle >=0 && self.angle <= M_PI_2)
        {
            self.moveDirection=left;
            self.flipX=180;
            
            self.hitZoneAngle1=self.angle+self.hitZone;
            self.hitZoneAngle1=fmodf(self.hitZoneAngle1+2*M_PI, 2*M_PI);
            self.hitZoneAngle2=self.angle;
            self.hitZoneAngle2=fmodf(self.hitZoneAngle2+2*M_PI, 2*M_PI);
        }else{
            self.moveDirection=right;
             self.flipX=0;
            self.hitZoneAngle1=self.angle;
            self.hitZoneAngle1=fmodf(self.hitZoneAngle1+2*M_PI, 2*M_PI);
            self.hitZoneAngle2=self.angle-self.hitZone;
            self.hitZoneAngle2=fmodf(self.hitZoneAngle2+2*M_PI, 2*M_PI);
        }
    }
    self.boundingZoneAngle1=self.angle+self.boundingZone;
    self.boundingZoneAngle1=fmodf(self.boundingZoneAngle1+2*M_PI, 2*M_PI);
    self.boundingZoneAngle2=self.angle-self.boundingZone;
    self.boundingZoneAngle2=fmodf(self.boundingZoneAngle2+2*M_PI, 2*M_PI);
        self.damage+=CCRANDOM_MINUS1_1()*self.damageDelta;
    // Finally set yourself to be visible, this also flag the enemy as "in use"
    self.visible = YES;
    self.alive=TRUE;
    self.attacked=FALSE;
    self.attacking=FALSE;
    hitDidRun=FALSE;
    blinkDidRun=FALSE;
    [self runAction:plant];
	
}

-(void) updateTimer:(NSTimer *) theTimer {
    if ([[GameMechanics sharedGameMechanics] gameState] == GameStateRunning)
    {
        if(spawnDelayTimer>0){
            spawnDelayTimer--;
                        float newPercentage=((float)(spawnDelayTimer-1)/(float)spawnDelayInitial)*100;
                        [delayTimer runAction:[CCProgressFromTo actionWithDuration:1.0f from:delayTimer.percentage to:newPercentage]];
            if(spawnDelayTimer==0){
                [self runAction:spawn];
            }
            
        }
    }
}

- (void)attack{
    // animation needs to be either done (isDone) or run for the first time (stabDidRun)
    if ((hitDidRun == FALSE) || [attack isDone])
    {
        [self runAction:attack];
        hitDidRun = TRUE;
    }
}

- (void)gotHit:(int)damage
{
        if(self.alive){
    //deduct hitpoint by damage
    //ableToAttack is set to false only when they are spawning in plant form,so if they get hit while in plant form, they take X2 damage
    if(self.ableToAttack){
        self.hitPoints -=2*damage;
    }else{
        self.hitPoints-=3*damage;
    }
    //if hitpoint is 0 or less then the monster dies
    if(self.hitPoints<=0){
//        [[GameMechanics sharedGameMechanics]game].playerMonsterKilled=+1;
        [self stopAllActions];
        self.visible = YES;
        [self runAction:death];
    }else if(blinkDidRun==FALSE || [blink isDone]){
        blinkDidRun=TRUE;
        [self runAction:blink];
    }
        }
}


-(void)reset{
    [self destroy];
    
    int level=[[[[[GameMechanics sharedGameMechanics]game]levelsOfEverything] objectForKey:nameOfMonster] integerValue];
    if(level >= 0){
        NSDictionary *monsterInfo=[[[[[GameMechanics sharedGameMechanics]game]gameInfo] objectForKey:nameOfMonster]   objectAtIndex:level];
        self.hitPointsInit=[[monsterInfo objectForKey:@"Health"] integerValue];
        self.damage=[[monsterInfo objectForKey:@"Damage"]integerValue];
        speed= [[monsterInfo objectForKey:@"Move Speed"] doubleValue] ;
        self.areaOfEffect=[[monsterInfo objectForKey:@"AreaOfEffect"] boolValue];
        self.areaOfEffectDamage=[[monsterInfo objectForKey:@"AreaOfEffect Damage"]integerValue];
        spawnDelayInitial=[[monsterInfo objectForKey:@"Delay"]integerValue];
        self.radiusToSpawnDelta=[[[[[GameMechanics sharedGameMechanics]game] gameInfo] objectForKey:@"Spawn Radius Delta"]integerValue];
        self.damageDelta=[[monsterInfo objectForKey:@"Damage Delta"]integerValue];
        self.range=[[monsterInfo objectForKey:@"Range"]integerValue];

    }
}



@end

