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
    
    //set health
    self.hitPoints=self.hitPointsInit;
    
    //angle of the spawn
    self.angle= angleOfLocation;
    self.angle=fmodf(self.angle+2*M_PI, 2*M_PI);
    // Select a spawn location
    float xPos=radiusOfWorld*cos(self.angle);
    float yPos=radiusOfWorld*sin(self.angle);
    
    //set the location
    self.position = CGPointMake(xPos, yPos);
    self.rotation=CC_RADIANS_TO_DEGREES(-self.angle+M_PI_2);
    
    //set location and move direction
    if([[GameMechanics sharedGameMechanics]game].difficulty==EASY){
        self.moveDirection=left;
        self.flipX=180;
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
    //deduct hitpoint by damage
    self.hitPoints -=damage;
    //if hitpoint is 0 or less then the monster dies
    if(self.hitPoints<=0){
        [[GameMechanics sharedGameMechanics]game].playerMonsterKilled=+1;
        [self destroy];
    }else if(blinkDidRun==FALSE || [blink isDone]){
        blinkDidRun=TRUE;
        [self runAction:blink];
    }
    
}


-(void)reset{
    [self destroy];
    
    int level=[[[[[GameMechanics sharedGameMechanics]game]levelsOfEverything] objectForKey:nameOfMonster] integerValue];
    if(level >= 0){
        NSDictionary *monsterInfo=[[[[[GameMechanics sharedGameMechanics]game]gameInfo] objectForKey:nameOfMonster]   objectAtIndex:level];
        self.hitPointsInit=[[monsterInfo objectForKey:@"Health"] integerValue];
        self.damage=[[monsterInfo objectForKey:@"Damage"]integerValue];
        speed= [[monsterInfo objectForKey:@"Move Speed"] doubleValue]  * (M_PI/1860);
        self.areaOfEffect=[[monsterInfo objectForKey:@"AreaOfEffect"] boolValue];
        self.areaOfEffectDamage=[[monsterInfo objectForKey:@"AreaOfEffect Damage"]integerValue];
        spawnDelayInitial=[[monsterInfo objectForKey:@"Delay"]integerValue];
    }
}



@end

