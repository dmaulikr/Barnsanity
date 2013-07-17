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
    //set health point
    self.hitPoints=self.hitPointsInit;
    
    //set up spawn locaiton
    //angle of the spawn
    self.angle=angleOfLocation;
    self.angle=fmodf(self.angle+2*M_PI, 2*M_PI);
    // Select a spawn location
    float xPos=radiusOfWorld*cos(self.angle);
    float yPos=radiusOfWorld*sin(self.angle);
    //set the location
    self.position = CGPointMake(xPos, yPos);
    self.rotation=CC_RADIANS_TO_DEGREES(-self.angle+M_PI_2);
    
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
        [self destroy];
                [[GameMechanics sharedGameMechanics]game].enemiesMonsterKilled=+1;
        //reward gold
        [[GameMechanics sharedGameMechanics] game].goldForLevel+=reward+[[GameMechanics sharedGameMechanics] game].goldBonusPerMonster;

    }else if(blinkDidRun==FALSE || [blink isDone]){
        blinkDidRun=TRUE;
        [self runAction:blink];
    }
    
}

-(void)reset{
    [self destroy];
}



@end
