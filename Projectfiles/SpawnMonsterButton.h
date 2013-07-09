//
//  SpawnMonsterButton.h
//  AngryVeggie
//
//  Created by Danny on 6/27/13.
//
//

#import "CCSprite.h"

@interface SpawnMonsterButton : CCSprite
{
    int fireDelayInitial;
    int fireDelayTimer;
    float angleOfSpawn;
    NSString *nameOfMonster;
    CCProgressTimer *delayTimer;
}
-(id) initWithEntityImage;
-(void)pressed;
-(void)updateDelay;

@end
