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
        [self addChild:healthBar];
        healthBar.position=ccp(health.contentSize.width/2,2*self.contentSize.height/2+10);
        healthBar.midpoint = ccp(0,0.5); // Here is where all magic is
        healthBar.barChangeRate = ccp(1, 0);
        
        
        
        //include updates
        [self scheduleUpdate];
	}
    
	return self;
}

-(void)constructAt:(float) angle{
    //get the radius of the world
    radiusOfWorld=[[GameMechanics sharedGameMechanics] gameScene].radiusOfWorld;
    //calculate the x and y position based on the angle given
    float xPos=radiusOfWorld*cos(angle);
    float yPos=radiusOfWorld*sin(angle);
    //set the position
    self.position=CGPointMake(xPos,yPos);
    //calculate the rotation of the image base of the angle
    self.rotation=CC_RADIANS_TO_DEGREES(-angle+M_PI_2);
    
    
    //have the barn visible
    self.visible=TRUE;
    //set the health bar
    healthBar.percentage=100;
}

-(void)attack{
    if(hitDidRun == FALSE){
        hitDidRun=TRUE;
    }
}
-(void)gotHit:(int)damage{
    //decrease the health by the amount of damage
    self.hitPoints-=(damage - armor);
    //display health bar base of the amount of health left
    //    healthBar.percentage-=100*(damage/self.initialHitPoints);
    if(self.hitPoints<=0){
        self.visible=FALSE;
        if(self.enemy){
            [[GameMechanics sharedGameMechanics] game].gold+=reward;
        }
    }
}

-(void)update:(ccTime)delta{
    //
}

//-(void)draw{
//    ccColor4F rectColor = ccc4f(0.5, 0.5, 0.5, 1.0);
//    CGPoint center = ccp(self.position.x + self.contentSize.width / 2, self.position.y + self.contentSize.height / 2);
//    ccDrawSolidRect(ccp(center.x-self.contentSize.width/2,center.y+self.contentSize.height/2), ccp(self.contentSize.width, 10), rectColor);
//    [super draw];
//}
@end
