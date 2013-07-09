//
//  Ship.h
//  AngryVeggie
//
//  Created by Danny on 6/25/13.
//
//

#import "CCSprite.h"

@interface Ship : CCSprite{
    int fireDelayInitial;
    int fireDelayTimer;
}
- (id)initWithMonsterPicture;
-(void)fireBullet;
-(void)reset;
@end
