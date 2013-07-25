//
//  QuitConfirmScreen.m
//  Veggy_V_Fruit
//
//  Created by Danny on 7/22/13.
//  Copyright (c) 2013 MakeGamesWithUs Inc. All rights reserved.
//

#import "SelectConfirmScreen.h"
#import "STYLES.h"
#import "GameMechanics.h"

@implementation SelectConfirmScreen
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
        CCLabelTTF *storeItemLabel = [CCLabelTTF labelWithString:@"Are You Sure You Want To Quit?"
                                                        fontName:DEFAULT_FONT
                                                        fontSize:32];
        storeItemLabel.color = DEFAULT_FONT_COLOR;
        storeItemLabel.position = ccp(-0.25 * self.contentSize.width - 25, 0.5 * self.contentSize.height - 25);
        [self addChild:storeItemLabel];
        
        // add a play button to play the level
        yes= [CCMenuItemFont itemWithString:@"Play" block:^(id sender) {
        }];
        yes.color = DEFAULT_FONT_COLOR;
        yes.position=ccp(-150,0);
        //add an equip button to equip the weapon you want to use
        no= [CCMenuItemFont itemWithString:@"Yes" block:^(id sender) {
        }];
        no.color = DEFAULT_FONT_COLOR;
        no.position=ccp(150,0);
        
        //add all buttons to the menu
        menu = [CCMenu menuWithItems:yes,no, nil];
        menu.position = ccp(0,-100);
        [self addChild:menu];


    }
    
    return self;
}


@end
