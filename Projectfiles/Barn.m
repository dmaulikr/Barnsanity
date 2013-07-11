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
        [self setScale:.5];
        //create the hit zone of the unit
        CGPoint center = ccp(self.position.x + self.contentSize.width / 2, self.position.y + self.contentSize.height / 2);
        CGSize hitZoneSize = CGSizeMake(self.contentSize.width/2, self.contentSize.height/2);
        self.hitZone = CGRectMake(center.x - 0.5 * hitZoneSize.width, center.y - 0.5 * hitZoneSize.width, hitZoneSize.width, hitZoneSize.height);
        
        //set which side is this unit
        self.enemy=enemySide;
        if(self.enemy){
            [self setColor:ccc3(255, 255, 0)];
        }else{
            [self setColor:ccc3(255, 0, 0)];
        }
        
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
        attack = [CCSequence actions:[CCDelayTime actionWithDuration:1.5], nil];
        
        //include updates
        [self scheduleUpdate];
	}
    
	return self;
}

-(void)constructAt:(float) angle{
    
    //resume update and set up stats
    [self reset];
    [self resumeSchedulerAndActions];
    
    //set up spawn location
    //get the radius of the world
    radiusOfWorld=[[GameMechanics sharedGameMechanics] gameScene].radiusOfWorld;
    //calculate the x and y position based on the angle given
    float xPos=radiusOfWorld*cos(angle);
    float yPos=radiusOfWorld*sin(angle);
    //set the position
    self.position=CGPointMake(xPos,yPos);
    //calculate the rotation of the image base of the angle
    self.rotation=CC_RADIANS_TO_DEGREES(-angle+M_PI_2);
    
    self.hitPoints=self.hitPointsInit;
    //have the barn visible
    self.visible=TRUE;
    self.attacking=FALSE;
    blinkDidRun=FALSE;
    hitDidRun=FALSE;
    
    //set the health bar
    healthBar.percentage=100;
}

-(void)attack{
    if(hitDidRun == FALSE||[attack isDone]){
        hitDidRun=TRUE;
        [self runAction:attack];
    }
}
-(void)gotHit:(int)damage{
    //decrease the health by the amount of damage
    self.hitPoints-=(damage - armor);
    //display health bar base of the amount of health left
    [healthBar setPercentage:((float)_hitPoints/(float)_hitPointsInit)*100];
    if(self.hitPoints<=0){
        //stop all update and actions
        [self pauseSchedulerAndActions];
        [self stopAllActions];
        //turn invisible
        self.visible=FALSE;
                self.position = ccp(-MAX_INT, 0);
        
        if(self.enemy){
            [[GameMechanics sharedGameMechanics] game].gold+=reward+[[GameMechanics sharedGameMechanics] game].goldBonusPerMonster;
        }
    }else if(blinkDidRun==FALSE || [blink isDone]){
        blinkDidRun=TRUE;
        [self runAction:blink];
    }
}

-(void)update:(ccTime)delta{
    self.attacking=FALSE;
    // calculate a hit zone
    CGPoint monsterCenter = ccp(self.position.x + self.contentSize.width / 2, self.position.y + self.contentSize.height / 2);
    CGSize hitZoneSize = CGSizeMake(self.contentSize.width/2, self.contentSize.height/2);
    self.hitZone = CGRectMake(monsterCenter.x - 0.5 * hitZoneSize.width, monsterCenter.y - 0.5 * hitZoneSize.width, hitZoneSize.width, hitZoneSize.height);
}

-(void)reset{
    if(self.enemy){
        int level=[[GameMechanics sharedGameMechanics]game].gameplayLevel;
        NSDictionary *monsterInfo=[[[[[[GameMechanics sharedGameMechanics]game]gameInfo] objectForKey:@"Game Levels"]objectAtIndex:level]   objectForKey:@"Barn"];
        self.hitPointsInit=[[monsterInfo objectForKey:@"Health"] integerValue];
        self.damage=[[monsterInfo objectForKey:@"Damage"]integerValue];
        armor=[[monsterInfo objectForKey:@"Armor"] integerValue];
    }else{
        NSDictionary *monsterlevel=[[[[GameMechanics sharedGameMechanics]game]levelsOfEverything] objectForKey:@"Player Barn"];
        int level=[[monsterlevel objectForKey:@"Health"]integerValue];
        self.hitPointsInit=[[[[[[[GameMechanics sharedGameMechanics]game]gameInfo] objectForKey:@"Player Barn"]objectForKey:@"Health"]   objectAtIndex:level] integerValue];
        level=[[monsterlevel objectForKey:@"Damage"] integerValue];
        self.damage=[[[[[[[GameMechanics sharedGameMechanics]game]gameInfo] objectForKey:@"Player Barn"]objectForKey:@"Damage"]   objectAtIndex:level]integerValue];
        level=[[monsterlevel objectForKey:@"Armor"] integerValue];
        armor=[[[[[[[GameMechanics sharedGameMechanics]game]gameInfo] objectForKey:@"Player Barn"]objectForKey:@"Armor"]   objectAtIndex:level] integerValue];
    }
 
}

- (void)draw
{
    [super draw];
    
#ifdef DEBUG
    // visualize the hit zone
    
     ccDrawColor4B(100, 0, 255, 255); //purple, values range from 0 to 255
     CGPoint origin = ccp(self.hitZone.origin.x - self.position.x, self.hitZone.origin.y - self.position.y);
     CGPoint destination = ccp(origin.x + self.hitZone.size.width, origin.y + self.hitZone.size.height);
     ccDrawRect(origin, destination);
     
    
#endif
}
@end
