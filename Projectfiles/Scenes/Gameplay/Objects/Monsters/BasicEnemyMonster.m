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
    //angle of the spawn
    angle=angleOfLocation;
    
    // Select a spawn location
    float xPos=radiusOfWorld*cos(angle);
    float yPos=radiusOfWorld*sin(angle);
    
    if(angle<M_PI){
        moveDirection=right;
    }else{
        moveDirection=left;
        self.flipX=180;
    }
    
    //set the location
    self.position = CGPointMake(xPos, yPos);
    self.rotation=CC_RADIANS_TO_DEGREES(-angle+M_PI_2);
	// Finally set yourself to be visible, this also flag the enemy as "in use"
	self.visible = YES;
    self.move=TRUE;
    self.alive=TRUE;
    hitDidRun=FALSE;
    blinkDidRun=FALSE;
    
	
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
        self.visible = FALSE;
        self.alive=FALSE;
        self.position = ccp(-MAX_INT, 0);
        [[GameMechanics sharedGameMechanics] game].gold+=reward;
    }else if(blinkDidRun==FALSE || [blink isDone]){
        [self runAction:blink];
    }
    
}




@end
