//
//  ConfirmScreen.m
//  Veggy_V_Fruit
//
//  Created by Danny on 7/21/13.
//  Copyright (c) 2013 MakeGamesWithUs Inc. All rights reserved.
//

#import "ConfirmScreen.h"
#import "GameplayLayer.h"
#import "Leaderboard.h"
#import "STYLES.h"
#import "GameMechanics.h"

@implementation ConfirmScreen

-(id) init
{
	if (self = [super init])
    {
        
        // set background color
        CCBackgroundColorNode *backgroundNode = [[CCBackgroundColorNode alloc] init];
        backgroundNode.backgroundColor = ccc4(150, 150, 150, 150);
        backgroundNode.contentSize = self.contentSize;
        [self addChild:backgroundNode];
        

        CCLabelTTF *worldSize;
        CCLabelTTF *worldSizeWarning;
        
        startNewGame = [CCLabelTTF labelWithString:@"Are You Sure?"
                                                        fontName:DEFAULT_FONT
                                                        fontSize:38];
        startNewGame.color = DEFAULT_FONT_COLOR;
        startNewGame.position =ccp(0.5 * self.contentSize.width, self.contentSize.height - 25);
        [self addChild:startNewGame];
        
        newGameWarning= [CCLabelTTF labelWithString:@"Warning: Starting a new game will \noverwrite any previously loaded game! \nTHERE IS NO GOING BACK! \nTap CONFIRM to continue!"
                                           fontName:DEFAULT_FONT
                                           fontSize:20];
        newGameWarning.color = DEFAULT_FONT_COLOR;
        newGameWarning.position =ccp(0.5 * self.contentSize.width, self.contentSize.height - startNewGame.contentSize.height-40);
        [self addChild:newGameWarning];
        
        worldSize= [CCLabelTTF labelWithString:@"Size of World"
                                      fontName:DEFAULT_FONT
                                      fontSize:38];
        worldSize.color = DEFAULT_FONT_COLOR;
        worldSize.position =ccp(0.5 * self.contentSize.width, self.contentSize.height - 25);
        [self addChild:worldSize];
        worldSize.visible=FALSE;
        
        worldSizeWarning= [CCLabelTTF labelWithString:@"Warning: Entire world is extremely difficult! \nNot recommended for new players.\nPLAY AT YOUR OWN RISK!"
                                             fontName:DEFAULT_FONT
                                             fontSize:20];
        worldSizeWarning.color = DEFAULT_FONT_COLOR;
        worldSizeWarning.position = ccp(0.5 * self.contentSize.width, self.contentSize.height - startNewGame.contentSize.height-40);
        [self addChild:worldSizeWarning];
        worldSizeWarning.visible=FALSE;
        
        CGPoint screenCenter = [CCDirector sharedDirector].screenCenter;
        CGSize screenSize = [CCDirector sharedDirector].screenSize;
        
        CCMenuItemFont *confirm;
        CCMenuItemFont *back;
        CCMenuItemFont *wholeWorld;
        CCMenuItemFont *halfWorld;
        /* add a load button to load previous game */
        confirm= [CCMenuItemFont itemWithString:@"Confirm" block:^(id sender) {
            confirmMenu.visible=FALSE;
            startNewGame.visible=FALSE;
            newGameWarning.visible=FALSE;
            worldSize.visible=TRUE;
            worldSizeWarning.visible=TRUE;
            sizeMenu.visible=TRUE;
        }];
        confirm.color = DEFAULT_FONT_COLOR;
        
        //add a new game button to start a new game
        back= [CCMenuItemFont itemWithString:@"Back" block:^(id sender) {
            [self backButtonPressed];
        }];
        back.color = DEFAULT_FONT_COLOR;
        back.position=ccp(0,-70);
        
        wholeWorld= [CCMenuItemFont itemWithString:@"Entire" block:^(id sender) {
            [self entireButtonPressed];
        }];
        wholeWorld.color = DEFAULT_FONT_COLOR;
        wholeWorld.position=ccp(100,0);
        //add a new game button to start a new game
        halfWorld= [CCMenuItemFont itemWithString:@"Half" block:^(id sender) {
            [self halfButtonPressed];
        }];
        halfWorld.color = DEFAULT_FONT_COLOR;
        halfWorld.position=ccp(-100,0);
        
        backWorld= [CCMenuItemFont itemWithString:@"Back" block:^(id sender) {
            [self backButtonPressed];
        }];
        backWorld.color = DEFAULT_FONT_COLOR;
        backWorld.position=ccp(0,-70);
        
        //add all buttons into the menu
        confirmMenu = [CCMenu menuWithItems:confirm,back, nil];
//        confirmMenu.position = ccp(screenCenter.x, screenCenter.y - 50);
        confirmMenu.position=ccp(0.5 * self.contentSize.width, 0.5*self.contentSize.height -25);
        [self addChild: confirmMenu];
        
        sizeMenu = [CCMenu menuWithItems:wholeWorld,halfWorld,backWorld, nil];
//        sizeMenu.position = ccp(screenCenter.x, screenCenter.y - 50);
        sizeMenu.position=ccp(0.5 * self.contentSize.width, 0.5*self.contentSize.height -25);
        sizeMenu.visible=FALSE;
        [self addChild: sizeMenu];
        
	}
    
	return self;
}

- (void)backButtonPressed
{

        //remove this layer before going to the level selection layer
        self.visible = FALSE;
        [self removeFromParentAndCleanup:TRUE];
        
        //go to level selection layer
        [[[GameMechanics sharedGameMechanics] gameScene] goToMainMenu];
    
}

- (void)entireButtonPressed
{
    //remove this layer before going to the level selection layer
    self.visible = FALSE;
    [self removeFromParentAndCleanup:TRUE];
    //set the world to hard
    [[GameMechanics sharedGameMechanics] game].difficulty=HARD;
    //load a new game
    [[[GameMechanics sharedGameMechanics] game] newGame];
    //go to the level selection layer
    [[[GameMechanics sharedGameMechanics] gameScene] goTolevelSelection];
}

- (void) halfButtonPressed
{
    //remove this layer before going to the level selection layer
    self.visible = FALSE;
    [self removeFromParentAndCleanup:TRUE];
    //set the world to hard
    [[GameMechanics sharedGameMechanics] game].difficulty=EASY;
    //load a new game
    [[[GameMechanics sharedGameMechanics] game] newGame];
    //go to the level selection layer
    [[[GameMechanics sharedGameMechanics] gameScene] goTolevelSelection];
}


@end
