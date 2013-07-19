//
//  ShipBullets.m
//  AngryVeggie
//
//  Created by Danny on 6/27/13.
//
//

#import "ShipBullets.h"
#import "GameMechanics.h"

@implementation ShipBullets


- (id)initWithMonsterPicture{
    self = [super initWithFile:@"cat2.png"];
    
    if (self)
    {
        [self setScale:.12 ];
        speed=8;

        [self reset];
        [self scheduleUpdate];
        
    }
    return self;
}
- (void)spawn{
    
    //get the radius of the world
    radiusOfWorld=[[GameMechanics sharedGameMechanics] gameScene].radiusOfWorld;
    
    //distance from the center of the world to the ship
    float worldYPos=[[[GameMechanics sharedGameMechanics] gameScene] getChildByTag:1].position.y;
    float shipYPos=[[[GameMechanics sharedGameMechanics] gameScene] getChildByTag:0].position.y;
    
    distanceToSpawn=fabsf(worldYPos-shipYPos);
    
    self.boundingZone=atanf((self.contentSize.width/2)/(radiusOfWorld+self.contentSize.height/2))/2;
    self.hitZone=atanf((self.contentSize.width/2)/(radiusOfWorld+self.contentSize.height/2))/6;
    
    float angleOfRotation=[[[GameMechanics sharedGameMechanics] gameScene] getChildByTag:1].rotation;
    self.distanceFromWorld=distanceToSpawn;
    
    //angle of the spawn
    angle= M_PI_2+CC_DEGREES_TO_RADIANS(angleOfRotation);
    angle=fmodf(angle+2*M_PI, 2*M_PI);
    // Select a spawn location
    float xPos=distanceToSpawn*cos(angle);
    float yPos=distanceToSpawn*sin(angle);
    
    self.rotation=CC_RADIANS_TO_DEGREES(-angle+M_PI_2);
    self.position=ccp(xPos,yPos);
    
    self.hitZoneAngle1=angle+self.hitZone;
    self.hitZoneAngle1=fmodf(self.hitZoneAngle1+2*M_PI, 2*M_PI);
    self.hitZoneAngle2=angle-self.hitZone;
    self.hitZoneAngle2=fmodf(self.hitZoneAngle2+2*M_PI, 2*M_PI);

        self.areaOfEffect=TRUE;

    self.visible=TRUE;
    self.attacked=FALSE;
}

- (void)gotHit{
    self.visible = FALSE;
    self.position = ccp(-MAX_INT, 0);
}

- (void)update:(ccTime)delta
{
    // only execute the block, if the game is in 'running' mode
    if ([[GameMechanics sharedGameMechanics] gameState] == GameStateRunning)
    {
        if(self.visible){
            [self updateRunningMode:delta];
        }
    }
}

- (void)updateRunningMode:(ccTime)delta
{
    self.distanceFromWorld-=speed;
    if(self.distanceFromWorld <= radiusOfWorld){
        self.visible=FALSE;
        self.position = ccp(-MAX_INT, 0);
    }
    float deltaX=self.distanceFromWorld*cos(angle);
    float deltaY=self.distanceFromWorld*sin(angle);
    CGPoint newPosition = ccp(deltaX, deltaY);
    [self setPosition:newPosition];
    
    
    
}

-(void)reset{
    [self gotHit];
    int level=[[[[[GameMechanics sharedGameMechanics]game]levelsOfEverything] objectForKey:@"Ship Damage"] integerValue];
    self.damage=[[[[[[GameMechanics sharedGameMechanics]game]gameInfo]objectForKey:@"Ship Damage"]   objectAtIndex:level] integerValue];
    level=[[[[[GameMechanics sharedGameMechanics]game]levelsOfEverything] objectForKey:@"Ship AreaOfEffect Damage"]integerValue];
    self.areaOfEffectDamage=[[[[[[GameMechanics sharedGameMechanics]game]gameInfo]objectForKey:@"AreaOfEffect Damage"]   objectAtIndex:level]integerValue];
    
}


@end
