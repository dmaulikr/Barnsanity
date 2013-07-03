//
//  Barn.h
//  AngryVeggie
//
//  Created by Danny on 6/25/13.
//
//

#import "CCSprite.h"

@interface Barn : CCSprite{
    //the radius of the world
    float radiusOfWorld;
    
    int reward;
    int armor;
    BOOL hitDidRun;
    //control how much of the health bar to show
    CCProgressTimer *healthBar;
    
}
//the health of the unit
@property (nonatomic, assign) NSInteger hitPoints;
@property (nonatomic, assign) NSInteger damage;
//checks if the unit is visible
@property (nonatomic, assign) BOOL visible;
@property (nonatomic, assign) BOOL attacking;
//the hitzone of the unit
@property (nonatomic, assign) CGRect hitZone;
//whether the unit is an enemy's unit or not
@property (nonatomic, assign) BOOL enemy;

//initialize the unit
-(id) initWithEntityImage:(BOOL)enemySide;
//spawn the unit into the world
-(void)constructAt:(float) angle;
//if the unit is attacked
-(void) gotHit:(int) damage;
-(void)attack;
@end
