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
        self.damage=1;
        speed=4;
        //get the radius of the world
        radiusOfWorld=[[GameMechanics sharedGameMechanics] gameScene].radiusOfWorld;
        
        //distance from the center of the world to the ship
        float worldYPos=[[[GameMechanics sharedGameMechanics] gameScene] getChildByTag:1].position.y;
        float shipYPos=[[[GameMechanics sharedGameMechanics] gameScene] getChildByTag:0].position.y;
        
        distanceToSpawn=fabsf(worldYPos-shipYPos);
        
        [self scheduleUpdate];
    }
    return self;
}
- (void)spawn{
    float angleOfRotation=[[[GameMechanics sharedGameMechanics] gameScene] getChildByTag:1].rotation;
    distanceFromWorld=distanceToSpawn;
    
    //angle of the spawn
    angle= M_PI_2+CC_DEGREES_TO_RADIANS(angleOfRotation);
    
    // Select a spawn location
    float xPos=distanceToSpawn*cos(angle);
    float yPos=distanceToSpawn*sin(angle);
    
    self.rotation=CC_RADIANS_TO_DEGREES(-angle+M_PI_2);
    self.position=ccp(xPos,yPos);
    
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
    distanceFromWorld-=speed;
    if(distanceFromWorld <= radiusOfWorld){
        self.visible=FALSE;
        self.position = ccp(-MAX_INT, 0);
    }
    float deltaX=distanceFromWorld*cos(angle);
    float deltaY=distanceFromWorld*sin(angle);
    CGPoint newPosition = ccp(deltaX, deltaY);
    [self setPosition:newPosition];
    
    
    
}


@end
