//
//  Walls.h
//  Veggy_V_Fruit
//
//  Created by Danny on 7/18/13.
//  Copyright (c) 2013 MakeGamesWithUs Inc. All rights reserved.
//

#import "Entity.h"

@interface Walls : Entity{
     NSString *nameOfMonster;
    CCBlink *blink;
    BOOL blinkDidRun;
    int reward;
}
@property (nonatomic, assign) float radiusToSpawnDelta;
@property (nonatomic, assign) float range;
//units health info
@property (nonatomic, assign) NSInteger hitPoints;
@property (nonatomic, assign) NSInteger hitPointsInit;
@property (nonatomic, assign) BOOL invincible;
- (id)initWithMonsterPicture;
- (void)gotHit:(int)damage;
- (void)spawnAt:(float) angleOfLocation;
-(void)destroy;
-(void)reset;
@end
