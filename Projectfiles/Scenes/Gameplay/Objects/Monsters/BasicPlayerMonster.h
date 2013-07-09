//
//  BasicPlayerMonster.h
//  AngryVeggie
//
//  Created by Danny on 6/21/13.
//
//


#import "Monster.h"

@interface BasicPlayerMonster : Monster

{
    
}

- (id)initWithMonsterPicture;
- (void)spawnAt:(float) angleOfLocation;
- (void)gotHit:(int)damage;
- (void)attack;
-(void)reset;




@end


