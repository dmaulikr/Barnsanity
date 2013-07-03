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
    
    if((angleOfLocation <=0 && angleOfLocation >= -90)||(angleOfLocation >270 && angleOfLocation < 359))
    {
        moveDirection=left;
        self.flipX=180;
    }else{
        moveDirection=right;
    }
    //angle of the spawn
    angle= M_PI_2+CC_DEGREES_TO_RADIANS(angleOfLocation);
    
    // Select a spawn location
    float xPos=radiusOfWorld*cos(angle);
    float yPos=radiusOfWorld*sin(angle);
    
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
    }else if(blinkDidRun==FALSE || [blink isDone]){
        [self runAction:blink];
    }
    
}



@end

