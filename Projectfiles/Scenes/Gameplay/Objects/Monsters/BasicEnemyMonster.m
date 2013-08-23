/*
 * Kobold2D™ --- http://www.kobold2d.org
 *
 * Copyright (c) 2010-2011 Steffen Itterheim.
 * Released under MIT License in Germany (LICENSE-Kobold2D.txt).
 */


#import "BasicEnemyMonster.h"
#import "math.h"

@implementation BasicEnemyMonster

- (void)spawnAt:(float) angleOfLocation
{
    //start update and run action
    [self stopAllActions];
    //get the radius of the world
    radiusOfWorld=[[GameMechanics sharedGameMechanics] gameScene].radiusOfWorld;
    //calculate where to spawn
        self.radiusToSpawn=radiusOfWorld+CCRANDOM_MINUS1_1()*self.radiusToSpawnDelta-5;
    //calculate the boudzone and hit zone of the monster
    self.boundingZone= atanf((self.contentSize.width/2)/(radiusOfWorld+self.contentSize.height/2))/2.5;
    self.hitZone=CCRANDOM_MINUS1_1()*(M_PI/550)+self.range*atanf((self.contentSize.width/2)/(radiusOfWorld+self.contentSize.height/2))/2;
    
    //base on where you spawn, set the zorder of the monster
        [self setZOrder:(NSInteger)((2*radiusOfWorld)-self.radiusToSpawn)];
    
    
    //set up spawn locaiton
    //angle of the spawn
    self.angle=angleOfLocation;
    self.angle=fmodf(self.angle+2*M_PI, 2*M_PI);
    // Select a spawn location
    float xPos=  self.radiusToSpawn*cos(self.angle);
    float yPos=  self.radiusToSpawn*sin(self.angle);
    //set the location
    self.position = CGPointMake(xPos, yPos);
    self.rotation=CC_RADIANS_TO_DEGREES(-self.angle+M_PI_2);
    //set up the hit zone angles according to the direction they are moving towards
    if([[GameMechanics sharedGameMechanics]game].difficulty==EASY){
        self.flipX=0;
        self.moveDirection=right;
        self.hitZoneAngle1=self.angle;
        self.hitZoneAngle1=fmodf(self.hitZoneAngle1+2*M_PI, 2*M_PI);
        self.hitZoneAngle2=self.angle-self.hitZone;
        self.hitZoneAngle2=fmodf(self.hitZoneAngle2+2*M_PI, 2*M_PI);
    }else{
    
    if(self.angle<=M_PI){
                self.flipX=0;
        self.moveDirection=right;
        self.hitZoneAngle1=self.angle;
        self.hitZoneAngle1=fmodf(self.hitZoneAngle1+2*M_PI, 2*M_PI);
        self.hitZoneAngle2=self.angle-self.hitZone;
        self.hitZoneAngle2=fmodf(self.hitZoneAngle2+2*M_PI, 2*M_PI);
    }else{
        self.moveDirection=left;
        self.flipX=180;
        self.hitZoneAngle1=self.angle+self.hitZone;
        self.hitZoneAngle1=fmodf(self.hitZoneAngle1+2*M_PI, 2*M_PI);
        self.hitZoneAngle2=self.angle;
        self.hitZoneAngle2=fmodf(self.hitZoneAngle2+2*M_PI, 2*M_PI);
    }
    }
    self.boundingZoneAngle1=self.angle+self.boundingZone;
    self.boundingZoneAngle1=fmodf(self.boundingZoneAngle1+2*M_PI, 2*M_PI);
    self.boundingZoneAngle2=self.angle-self.boundingZone;
    self.boundingZoneAngle2=fmodf(self.boundingZoneAngle2+2*M_PI, 2*M_PI);
    
    
    
    //set health point
    self.hitPoints=self.hitPointsInit;
    self.damage+=CCRANDOM_MINUS1_1()*self.damageDelta;
	// Finally set yourself to be visible, this also flag the enemy as "in use"
	self.visible = YES;
    self.alive=TRUE;
    self.attacked=FALSE;
    self.attacking=FALSE;
    self.hitDidRun=FALSE;
    blinkDidRun=FALSE;
    [self runAction:plant];
	
}

- (void)attack{
    // animation needs to be either done (isDone) or run for the first time (stabDidRun)
    if ((self.hitDidRun == FALSE) || [attack isDone])
    {
        [self stopAction:attack];
        [self runAction:attack];
        self.hitDidRun = TRUE;
         self.attacking = TRUE;
         self.attacked=TRUE;
    }
}

- (void)gotHit:(int)damage
{
    //deduct hitpoint by damage
    //ableToAttack is set to false only when they are spawning in plant form,so if they get hit while in plant form, they take X2 damage
        
        self.hitPoints -=2*damage;
    //if hitpoint is 0 or less then the monster dies
    if(self.hitPoints<=0){
        [self stopAllActions];
        self.visible = YES;
        [self runAction:death];

//                [[GameMechanics sharedGameMechanics]game].enemiesMonsterKilled++;
        //reward gold
        if([[GameMechanics sharedGameMechanics] game].difficulty==EASY){
        [[GameMechanics sharedGameMechanics] game].goldForLevel+=reward+[[GameMechanics sharedGameMechanics] game].goldBonusPerMonster;
        }else{
            [[GameMechanics sharedGameMechanics] game].goldForLevel+=2*reward+[[GameMechanics sharedGameMechanics] game].goldBonusPerMonster;
        }
        [[GameMechanics sharedGameMechanics] game].scorePerLevel+=(.4*(reward+[[GameMechanics sharedGameMechanics] game].goldBonusPerMonster));
        [[GameMechanics sharedGameMechanics] game].energy+=energyReward;

    }else if(blinkDidRun==FALSE || [blink isDone]){
        blinkDidRun=TRUE;
        [self runAction:blink];
    }


}

-(void)reset{
    [self destroy];
}

-(void)setStats{
    NSDictionary *monsterInfo=[[[[[GameMechanics sharedGameMechanics]game]gameInfo] objectForKey:@"Enemy Monsters"]objectForKey:nameOfMonster ];
    self.hitPointsInit=[[monsterInfo objectForKey:@"Health"] integerValue];
    self.damage=[[monsterInfo objectForKey:@"Damage"]integerValue];
    speed=[[monsterInfo objectForKey:@"Move Speed"] doubleValue] ;
    self.areaOfEffect=[[monsterInfo objectForKey:@"AreaOfEffect"] boolValue];
    self.areaOfEffectDamage=[[monsterInfo objectForKey:@"AreaOfEffect Damage"]integerValue];
    reward=[[monsterInfo objectForKey:@"Gold Reward"] integerValue];
    energyReward=[[monsterInfo objectForKey:@"Energy Reward"] integerValue];
    self.radiusToSpawnDelta=[[[[[GameMechanics sharedGameMechanics]game] gameInfo] objectForKey:@"Spawn Radius Delta"]integerValue];
    self.damageDelta=[[monsterInfo objectForKey:@"Damage Delta"] integerValue];
    self.range=[[monsterInfo objectForKey:@"Range"] integerValue];
}

@end
