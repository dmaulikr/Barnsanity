//
//  Barn.m
//  AngryVeggie
//
//  Created by Danny on 6/25/13.
//
//

#import "Barn.h"
#import "GameMechanics.h"
#import "MonsterCache.h"
#import "CCProgressTimer.h"

@implementation Barn



-(id) initWithEntityImage:(BOOL) enemySide
{
	// Loading the Entity's sprite using a file, is a ship for now but you can change this
    
	if ((self = [super initWithFile:@"chest.png"]))
	{
        
        //for the specific image
        
        //set which side is this unit
        self.enemy=enemySide;
        if(self.enemy){
            [self setColor:ccc3(255, 0, 0)];
        }else{
             [self setColor:ccc3(255, 255, 0)];
        }
        
        CCFiniteTimeAction *startHit = [CCCallBlock actionWithBlock:^{
            // stop running animation
        }];
        
        CCFiniteTimeAction *finishHit = [CCCallBlock actionWithBlock:^{
            self.attacking = FALSE;

            
        }];
        
        attack= [CCSequence actions:startHit,[CCDelayTime actionWithDuration:1] ,finishHit, nil];
        
        //health bar
        CCSprite *health=[[CCSprite alloc] initWithFile:@"n2pY1.png"];
        [health setScale:2];
        healthBar=[CCProgressTimer progressWithSprite:health];
        healthBar.type = kCCProgressTimerTypeBar;
        [healthBar setPercentage:100.0f];
        [self addChild:healthBar];
        healthBar.position=ccp(health.contentSize.width/2,2*self.contentSize.height/2+10);
        healthBar.midpoint = ccp(0,0.5);
        healthBar.barChangeRate = ccp(1, 0);
        
        
        blink = [CCBlink actionWithDuration:.4f blinks:2];
        
        //include updates
        [self scheduleUpdate];
	}
    
	return self;
}

-(void)constructAt:(float) angle{
    
    
    //resume update and set up stats
    [self reset];
    [self resumeSchedulerAndActions];
    radiusOfWorld=[[GameMechanics sharedGameMechanics] gameScene].radiusOfWorld;
    self.boundingZone=2.5*atanf((self.contentSize.width/2)/(radiusOfWorld+self.contentSize.height/2));
    if([[GameMechanics sharedGameMechanics]game].difficulty==EASY){
        self.hitZone=9*atanf((self.contentSize.width/2)/(radiusOfWorld+self.contentSize.height/2));
        self.alertZone=5*self.boundingZone;
    }else{
        self.hitZone=7*atanf((self.contentSize.width/2)/(radiusOfWorld+self.contentSize.height/2));
         self.alertZone=3.5*self.boundingZone;
    }
    
    self.angle=fmodf(angle+2*M_PI, 2*M_PI);
    //set up spawn location
    //get the radius of the world
    //calculate the x and y position based on the angle given
    float xPos=radiusOfWorld*cos(self.angle);
    float yPos=radiusOfWorld*sin(self.angle);
    //set the position
    self.position=CGPointMake(xPos,yPos);
    //calculate the rotation of the image base of the angle
    self.rotation=CC_RADIANS_TO_DEGREES(-self.angle+M_PI_2);
    
    self.hitZoneAngle1=self.angle+self.hitZone;
    self.hitZoneAngle1=fmodf(self.hitZoneAngle1+2*M_PI, 2*M_PI);
    self.hitZoneAngle2=self.angle-self.hitZone;
    self.hitZoneAngle2=fmodf(self.hitZoneAngle2+2*M_PI, 2*M_PI);
    self.boundingZoneAngle1=self.angle+self.boundingZone;
    self.boundingZoneAngle1=fmodf(self.boundingZoneAngle1+2*M_PI, 2*M_PI);
    self.boundingZoneAngle2=self.angle-self.boundingZone;
    self.boundingZoneAngle2=fmodf(self.boundingZoneAngle2+2*M_PI, 2*M_PI);
    
    self.alertZoneAngle1=self.angle+self.alertZone;
    self.alertZoneAngle1=fmodf(self.alertZoneAngle1+2*M_PI, 2*M_PI);
    self.alertZoneAngle2=self.angle-self.alertZone;
    self.alertZoneAngle2=fmodf(self.alertZoneAngle2+2*M_PI, 2*M_PI);
    self.hitPoints=self.hitPointsInit;
    //have the barn visible
    self.visible=TRUE;
    self.attacking=FALSE;
    blinkDidRun=FALSE;
    hitDidRun=FALSE;
    self.alive=TRUE;
    
    
    //set the health bar
    healthBar.percentage=100;
}

-(void)attack{
    if(hitDidRun == FALSE||[attack isDone]){
        hitDidRun=TRUE;
         self.attacking = TRUE;
        [self runAction:attack];
    }
}
-(void)gotHit:(int)damage{
    //decrease the health by the amount of damage
    if((damage - armor)>0){
        self.hitPoints-=(damage - armor);
    }
    //display health bar base of the amount of health left
    [healthBar setPercentage:((float)self.hitPoints/(float)self.hitPointsInit)*100];
    if(self.hitPoints<=0){
        //stop all update and actions
        [self pauseSchedulerAndActions];
        [self stopAllActions];
        //turn invisible
        self.visible=FALSE;
        self.alive=FALSE;
        self.position = ccp(-MAX_INT, 0);
        
    }else if(blinkDidRun==FALSE || [blink isDone]){
        blinkDidRun=TRUE;
        [self runAction:blink];
    }
}

-(void)update:(ccTime)delta{
    
}

-(void)reset{
    if(self.enemy){
        int level=[[GameMechanics sharedGameMechanics]game].gameplayLevel;
        NSDictionary *monsterInfo=[[[[[[GameMechanics sharedGameMechanics]game]gameInfo] objectForKey:@"Game Levels"]objectAtIndex:level]   objectForKey:@"Barn"];
        self.hitPointsInit=[[monsterInfo objectForKey:@"Health"] integerValue];
        self.damage=[[monsterInfo objectForKey:@"Damage"]integerValue];
        armor=[[monsterInfo objectForKey:@"Armor"] integerValue];
    }else{
        int level=[[[[[GameMechanics sharedGameMechanics]game]levelsOfEverything] objectForKey:@"Player Barn Health"]integerValue];
        self.hitPointsInit=[[[[[[GameMechanics sharedGameMechanics]game]gameInfo] objectForKey:@"Player Barn Health"]   objectAtIndex:level] integerValue];
        level=[[[[[GameMechanics sharedGameMechanics]game]levelsOfEverything] objectForKey:@"Player Barn Damage"] integerValue];
        self.damage=[[[[[[GameMechanics sharedGameMechanics]game]gameInfo] objectForKey:@"Player Barn Damage"]   objectAtIndex:level]integerValue];
        level=[[[[[GameMechanics sharedGameMechanics]game]levelsOfEverything] objectForKey:@"Player Barn Armor"] integerValue];
        armor=[[[[[[GameMechanics sharedGameMechanics]game]gameInfo] objectForKey:@"Player Barn Armor"]   objectAtIndex:level] integerValue];
    }
 
}


@end
