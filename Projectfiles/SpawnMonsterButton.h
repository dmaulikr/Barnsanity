//
//  SpawnMonsterButton.h
//  AngryVeggie
//
//  Created by Danny on 6/27/13.
//
//

#import "CCSprite.h"

@interface SpawnMonsterButton : CCSprite{
    int fireDelayInitial;
    int fireDelayTimer;
    float angleOfSpawn;
}
-(id) initWithEntityImage;
-(void)pressed;

@end
