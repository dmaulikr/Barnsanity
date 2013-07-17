//
//  Seed.h
//  Veggy_V_Fruit
//
//  Created by Danny on 7/16/13.
//  Copyright (c) 2013 MakeGamesWithUs Inc. All rights reserved.
//

#import "CCSprite.h"

@interface Seed : CCSprite
{
    float radiusOfWorld;
    float distanceToSpawn;
    float speed;
    float angle;
    float distanceFromWorld;
    NSString *monsterName;
}

//information about the monster
@property (nonatomic, assign) BOOL visible;

- (id)initWithMonsterPicture;
- (void)spawnMonster:(NSString*)name;
-(void)reset;

@end
