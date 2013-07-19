//
//  LoseScreen.m
//  Veggy_V_Fruit
//
//  Created by Danny on 7/10/13.
//  Copyright (c) 2013 MakeGamesWithUs Inc. All rights reserved.
//

#import "LoseScreen.h"
#import "GameMechanics.h"
#import "STYLES.h"



@implementation LoseScreen

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
        CCLabelTTF *storeItemLabel = [CCLabelTTF labelWithString:@"Defeat"
                                                        fontName:DEFAULT_FONT
                                                        fontSize:32];
        storeItemLabel.color = DEFAULT_FONT_COLOR;
        storeItemLabel.position = ccp(0, 0.5 * self.contentSize.height - 25);
        [self addChild:storeItemLabel];
        
        NSString *goldLost;
        if([[GameMechanics sharedGameMechanics]game ].gameplayLevel>5){
            goldLost=[NSString stringWithFormat:@"Total Gold Lost: %d",    [[GameMechanics sharedGameMechanics]game].gold/4 ];
        }else{
            goldLost=[NSString stringWithFormat:@"Total Gold Lost: 0"];

        }
        CCLabelTTF *lostGold = [CCLabelTTF labelWithString:goldLost
                                               fontName:DEFAULT_FONT
                                               fontSize:16];
        lostGold.color = DEFAULT_FONT_COLOR;
        lostGold.position = ccp(-self.contentSize.width/2+80, 0.5 * self.contentSize.height - 45);
        [self addChild:lostGold];
        
        NSString *totalGold=[NSString stringWithFormat:@"Total Gold: %d",    [[GameMechanics sharedGameMechanics]game].gold ];
        CCLabelTTF *goldtotal = [CCLabelTTF labelWithString:totalGold
                                                           fontName:DEFAULT_FONT
                                                           fontSize:16];
        goldtotal.color = DEFAULT_FONT_COLOR;
        goldtotal.position = ccp(-self.contentSize.width/2+80, 0.5 * self.contentSize.height - 65);
        [self addChild:goldtotal];

        
        
        // add a resume button
        
        selectLevel= [CCMenuItemFont itemWithString:@"Select Level" block:^(id sender) {
            [self selectLevelButtonPressed];
        }];
        selectLevel.color = DEFAULT_FONT_COLOR;
        

        
        menu = [CCMenu menuWithItems:selectLevel, nil];
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
