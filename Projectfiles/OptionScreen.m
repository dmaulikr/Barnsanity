//
//  OptionScreen.m
//  Veggy_V_Fruit
//
//  Created by Danny on 7/25/13.
//  Copyright (c) 2013 MakeGamesWithUs Inc. All rights reserved.
//

#import "OptionScreen.h"
#import "GameMechanics.h"
#import "STYLES.h"
#import "PopupProvider.h"
#import "StyleManager.h"

@implementation OptionScreen
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
        backgroundNode.backgroundColor = ccc4(255, 255, 255, 255);
        backgroundNode.contentSize = self.contentSize;
        [self addChild:backgroundNode];
        
        // set anchor points new, since we changed content size
        //self.anchorPoint = ccp(0.5, 0.5);
        backgroundNode.anchorPoint = ccp(0.5, 0.5);
        
        // add title label
        CCLabelTTF *storeItemLabel = [CCLabelTTF labelWithString:@"Option"
                                                        fontName:DEFAULT_FONT
                                                        fontSize:32];
        storeItemLabel.color = DEFAULT_FONT_COLOR;
        storeItemLabel.position = ccp(0, 0.5 * self.contentSize.height - 25);
        [self addChild:storeItemLabel];
        
        back= [CCMenuItemFont itemWithString:@"Back" block:^(id sender) {
            [self backButtonPressed];
        }];
        back.color = DEFAULT_FONT_COLOR;
        back.position=ccp(-100,0);
        
            resetGame= [CCMenuItemFont itemWithString:@"Reset Game" block:^(id sender) {
            [self resetGameButtonPressed];
        }];
        resetGame.color = DEFAULT_FONT_COLOR;
        resetGame.position=ccp(100,0);
        //add all buttons to the menu
        menu = [CCMenu menuWithItems:back,resetGame, nil];
        menu.position = ccp(0,0);
        [self addChild:menu];
        disableMenuButtons=FALSE;
            }
    
    return self;
}
-(void)backButtonPressed{
    if(!disableMenuButtons){
    //remove this layer before going to the next
    self.visible = FALSE;
    [self removeFromParentAndCleanup:TRUE];
    //go to store layer
    [[[GameMechanics sharedGameMechanics] gameScene] goTolevelSelection];
    }
}
-(void)resetGameButtonPressed{
    if(!disableMenuButtons){
        [self presentGoOnPopUp];
    }
}

- (void)presentGoOnPopUp
{
    CCScale9Sprite *backgroundImage = [StyleManager goOnPopUpBackground];
    goOnPopUp = [PopupProvider presentPopUpWithContentString:nil backgroundImage:backgroundImage target:self selector:@selector(goOnPopUpButtonClicked:) buttonTitles:@[@"Yes", @"No"]];
    disableMenuButtons=TRUE;
    back.visible=FALSE;
    resetGame.visible=FALSE;
}

- (void)goOnPopUpButtonClicked:(CCControlButton *)sender
{
    disableMenuButtons=FALSE;
    back.visible=TRUE;
    resetGame.visible=TRUE;
    [goOnPopUp dismiss];
    if (sender.tag == 0)
    {
        //remove this layer before going to the next
        self.visible = FALSE;
        [self removeFromParentAndCleanup:TRUE];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:0]forKey:@"Game Exist"];
        
        //go to store layer
        [[[GameMechanics sharedGameMechanics] gameScene] goToMainMenu];
    }
    
}

@end
