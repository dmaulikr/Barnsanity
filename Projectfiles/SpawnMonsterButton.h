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
    CCProgressTimer *delayTimer;
    CCLabelBMFont *scoreLabel;
}
@property (nonatomic, assign) NSString *nameOfMonster;
@property (nonatomic, assign) NSInteger cost;
-(id) initWithEntityImage:(NSString*)fileName andMonster:(NSString *)monsterName;
-(void)pressed;
-(void)updateDelay;

@end
