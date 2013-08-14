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

        
        // add a resume button
        
        selectLevel= [CCMenuItemFont itemWithString:@"Select Level" block:^(id sender) {
            [self selectLevelButtonPressed];
        }];
        selectLevel.color = DEFAULT_FONT_COLOR;
        
        
        menu = [CCMenu menuWithItems:selectLevel, nil];
        [menu alignItemsVertically];
        menu.position = ccp(0,-100);
        [self addChild:menu];

        NSMutableArray *tips=[[NSMutableArray alloc]init];
        [tips addObject:@"Tip: No Lead Is Safe! Keep Planting!"];
        [tips addObject:@"Tip: Quantity is better than quality!"];
        [tips addObject:@"Tip: While planting, in plant form, your units take 1.5X more damage"];
        [tips addObject:@"Tip: Don't shoot aimlessly, take down high priority units first(ie corn and tomato)"];
        [tips addObject:@"Tip: The key to success is to find balance between shooting and planting"];
        [tips addObject:@"Tip: You will only gain 30% of your total possible gold when playing repeated levels"];
        [tips addObject:@"Tip: Diversify your army!"];
        [tips addObject:@"Tip: Keep up-to-date with your upgrades"];
        [tips addObject:@"Tip: Keep looking around the map, Don't stay in one place too long."];
        [tips addObject:@"Tip: United we stand, divided we fall. Group your army as much as possible!"];
        [tips addObject:@"Tip: Different units have different plant time. Be aware of it!"];
        [tips addObject:@"Tip: When your barn is under-attack, plant within your barn! They will be safe from all damages while they are planting."];
        
        [tips addObject:@"Tip: Use bomb wisely!"];
        [tips addObject:@"Tip: Don't forget you have one bomb! Use it!"];
        [tips addObject:@"Tip: Use bomb offensively to give yourself an edge in big battles"];
        tipCount=15;
        NSString *tipForTheLost;
        if([[GameMechanics sharedGameMechanics]game].maxGamePlayLevel >=10){
            tipForTheLost=tips[rand()%tipCount];
        }else{
            tipForTheLost=tips[rand()%tipCount-3];
        }
        CCLabelTTF *tip = [CCLabelTTF labelWithString:tipForTheLost
                                                        fontName:DEFAULT_FONT
                                                        fontSize:12];
        tip.color = DEFAULT_FONT_COLOR;
        tip.position = ccp(10, 0.5 * self.contentSize.height - 50);
        [self addChild:tip];

        
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
