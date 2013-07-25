//
//  WinScreen.m
//  Veggy_V_Fruit
//
//  Created by Danny on 7/10/13.
//  Copyright (c) 2013 MakeGamesWithUs Inc. All rights reserved.
//

#import "WinScreen.h"
#import "GameMechanics.h"
#import "MonsterCache.h"
#import "STYLES.h"


@implementation WinScreen

- (id)initWithGame
{
    self = [super init];
    
    if (self)
    {
        self.contentSize = [[CCDirector sharedDirector] winSize];
        // position of screen, animate to screen
        self.position = ccp(self.contentSize.width / 2, self.contentSize.height * .5);
        
        // add a background image node
        backgroundNode = [[CCBackgroundColorNode alloc] init];
        backgroundNode.backgroundColor = ccc4(150, 150, 150, 150);
        backgroundNode.contentSize = self.contentSize;
        [self addChild:backgroundNode];
        
        // set anchor points new, since we changed content size
        //self.anchorPoint = ccp(0.5, 0.5);
        backgroundNode.anchorPoint = ccp(0.5, 0.5);
        
        // add title label
        CCLabelTTF *storeItemLabel = [CCLabelTTF labelWithString:@"Victory!"
                                                        fontName:DEFAULT_FONT
                                                        fontSize:32];
        storeItemLabel.color = DEFAULT_FONT_COLOR;
        storeItemLabel.position = ccp(0, 0.5 * self.contentSize.height - 25);
        [self addChild:storeItemLabel];
        
        NSString *scores=[NSString stringWithFormat:@"Total Score: %d",    [[GameMechanics sharedGameMechanics]game].score ];
        CCLabelTTF *score = [CCLabelTTF labelWithString:scores
                                                        fontName:DEFAULT_FONT
                                                        fontSize:16];
        score.color = DEFAULT_FONT_COLOR;
        score.position = ccp(-self.contentSize.width/2+80, 0.5 * self.contentSize.height - 45);
        [self addChild:score];
        
        NSString *moreKilled;
        if([[GameMechanics sharedGameMechanics]gameScene].ship.bombUsed){
        moreKilled=[NSString stringWithFormat:@"Bomb Used: Yes"];
        }else{
            moreKilled=[NSString stringWithFormat:@"Bomb Used: No"];
        }

        CCLabelTTF *moreKillThanDeath = [CCLabelTTF labelWithString:moreKilled
                                                           fontName:DEFAULT_FONT
                                                           fontSize:16];
        moreKillThanDeath.color = DEFAULT_FONT_COLOR;
        moreKillThanDeath.position = ccp(-self.contentSize.width/2+80, 0.5 * self.contentSize.height - 65);
        [self addChild:moreKillThanDeath];
        NSString *barn;
        if([[MonsterCache sharedMonsterCache] enemyBarn].hitPoints <= 0){
            barn=[NSString stringWithFormat:@"Enemy Barn Destroyed: Yes"];
        }else{
            barn=[NSString stringWithFormat:@"Enemy Barn Destroyed: No"];
        }
        
        CCLabelTTF *barnDestroyed = [CCLabelTTF labelWithString:barn
                                                       fontName:DEFAULT_FONT
                                                       fontSize:16];
        barnDestroyed.color = DEFAULT_FONT_COLOR;
        barnDestroyed.position= ccp(-self.contentSize.width/2+80, 0.5 * self.contentSize.height - 105);
        [self addChild:barnDestroyed];
        
        NSString *goldForLevel=[NSString stringWithFormat:@"Gold Earned: %d",[[GameMechanics sharedGameMechanics]game].goldForLevel];

        CCLabelTTF *goldEarned = [CCLabelTTF labelWithString:goldForLevel
                                                        fontName:DEFAULT_FONT
                                                        fontSize:16];
        goldEarned.color = DEFAULT_FONT_COLOR;
        goldEarned.position = ccp(-self.contentSize.width/2+80, 0.5 * self.contentSize.height - 135);
        [self addChild:goldEarned];
        
                NSString *total=[NSString stringWithFormat:@"Total Gold: %d",[[GameMechanics sharedGameMechanics]game].gold];
        CCLabelTTF *totalGold = [CCLabelTTF labelWithString:total
                                                        fontName:DEFAULT_FONT
                                                        fontSize:16];
        totalGold.color = DEFAULT_FONT_COLOR;
        totalGold.position = ccp(-self.contentSize.width/2+80, 0.5 * self.contentSize.height - 160);
        [self addChild:totalGold];
        
        
        
        // add a resume button
        
        accept= [CCMenuItemFont itemWithString:@"Accept" block:^(id sender) {
            [self selectLevelButtonPressed];
        }];
        accept.color = DEFAULT_FONT_COLOR;
        
        
        menu = [CCMenu menuWithItems:accept, nil];
        [menu alignItemsVertically];
        menu.position = ccp(0,-100);
        [self addChild:menu];

    }
    
    return self;
}


- (void)present
{
    CCMoveTo *move = [CCMoveTo actionWithDuration:0.2f position:ccp(self.contentSize.width / 2, self.contentSize.height * 0.5)];
    [self runAction:move];
    //    [missionNode updateCheckmarks];
}

- (void)selectLevelButtonPressed
{
    //remove this layer before going to the next
    self.visible = FALSE;
    [self removeFromParentAndCleanup:TRUE];
    //go to level selection layer
    [[[GameMechanics sharedGameMechanics] gameScene] goTolevelSelection];

}


@end
