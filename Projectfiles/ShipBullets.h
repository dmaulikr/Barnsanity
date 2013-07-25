//
//  ShipBullets.h
//  AngryVeggie
//
//  Created by Danny on 6/27/13.
//
//

#import "Entity.h"

@interface ShipBullets : Entity{
    float angle;

}

//information about the monster




@property (nonatomic, assign) float distanceFromWorld;

- (id)initWithMonsterPicture;
- (void)spawn;
- (void)gotHit;
-(void)reset;

@end
