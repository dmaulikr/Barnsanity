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
    [self runAction:run];
    
    //set health
    self.hitPoints=self.hitPointsInit;
    
    //set location and move direction
    if([[GameMechanics sharedGameMechanics]game].difficulty==EASY){
        self.moveDirection=left;
        self.flipX=180;
    }else{
    if((angleOfLocation <=0 && angleOfLocation >= -90)||(angleOfLocation >270 && angleOfLocation < 359))
    {
        self.moveDirection=left;
        self.flipX=180;
    }else{
        self.moveDirection=right;
    }
    }
    //angle of the spawn
    self.angle= M_PI_2+CC_DEGREES_TO_RADIANS(angleOfLocation);
    self.angle=fmodf(self.angle+2*M_PI, 2*M_PI);
    // Select a spawn location
    float xPos=radiusToSpawn*cos(self.angle);
    float yPos=radiusToSpawn*sin(self.angle);
    
    //set the location
    self.position = CGPointMake(xPos, yPos);
    self.rotation=CC_RADIANS_TO_DEGREES(-self.angle+M_PI_2);
    
    
    // Finally set yourself to be visible, this also flag the enemy as "in use"
    self.visible = YES;
    self.move=TRUE;
    self.alive=TRUE;
    self.attacked=FALSE;
    self.attacking=FALSE;
    hitDidRun=FALSE;
    blinkDidRun=FALSE;
    CGPoint monsterCenter = ccp(self.position.x + self.contentSize.width / 2, self.position.y + self.contentSize.height / 2);
    CGSize hitZoneSize = CGSizeMake(self.contentSize.width/2, self.contentSize.height/2);
    self.hitZone = CGRectMake(monsterCenter.x - 0.5 * hitZoneSize.width, monsterCenter.y - 0.5 * hitZoneSize.height, hitZoneSize.width, hitZoneSize.height);
	
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
        speedAngle= [[monsterInfo objectForKey:@"Move Speed"] doubleValue]  * (M_PI/1860);
        self.areaOfEffect=[[monsterInfo objectForKey:@"AreaOfEffect"] boolValue];
        self.areaOfEffectDamage=[[monsterInfo objectForKey:@"AreaOfEffect Damage"]integerValue];
    }
}



@end

