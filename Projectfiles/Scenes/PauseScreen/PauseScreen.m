//
//  PauseScreen.m
//  _MGWU-SideScroller-Template_
//
//  Created by Benjamin Encz on 6/10/13.
//  Copyright (c) 2013 MakeGamesWithUs Inc. Free to use for all purposes.
//

#import "PauseScreen.h"
#import "GameMechanics.h"
#import "STYLES.h"

@interface PauseScreen()

- (void)resumeButtonPressed;

@end

@implementation PauseScreen

- (id)initWithGame
{
    self = [super init];
    
    if (self)
    {
        self.contentSize = [[CCDirector sharedDirector] winSize];
        // position of screen, animate to screen
        self.position = ccp(self.contentSize.width / 2, self.contentSize.height * 1.5);
        
        // add a background image node
        backgroundNode = [[CCBackgroundColorNode alloc] init];
        backgroundNode.backgroundColor = ccc4(255, 255, 255, 255);
        backgroundNode.contentSize = self.contentSize;
        [self addChild:backgroundNode];
        
        // set anchor points new, since we changed content size
        //self.anchorPoint = ccp(0.5, 0.5);
        backgroundNode.anchorPoint = ccp(0.5, 0.5);
        
        // add title label
        CCLabelTTF *storeItemLabel = [CCLabelTTF labelWithString:@"PAUSED"
                                                        fontName:DEFAULT_FONT
                                                        fontSize:32];
        storeItemLabel.color = DEFAULT_FONT_COLOR;
        storeItemLabel.position = ccp(0, 0.5 * self.contentSize.height - 25);
        [self addChild:storeItemLabel];
        
        // add a resume button
        CCSprite *resumeButtonNormal = [CCSprite spriteWithFile:@"button_playbutton.png"];
        resumeMenuItem = [[CCMenuItemSprite alloc] initWithNormalSprite:resumeButtonNormal selectedSprite:nil disabledSprite:nil target:self selector:@selector(resumeButtonPressed)];
        
        
        //add a select level button to go select a different level
        selectLevel= [CCMenuItemFont itemWithString:@"Select Level" block:^(id sender) {
            [self selectLevelButtonPressed];
        }];
        selectLevel.color = DEFAULT_FONT_COLOR;
        
        //add a main menu button to go back to the main menu
        
        mainMenu= [CCMenuItemFont itemWithString:@"Main Menu" block:^(id sender) {
            [self mainMenuButtonPressed];
        }];
        mainMenu.color = DEFAULT_FONT_COLOR;
        
        //add all the buttons to the menu
        menu = [CCMenu menuWithItems:resumeMenuItem,mainMenu, selectLevel, nil];
        [menu alignItemsVertically];
        menu.position = ccp(0,0);
        [self addChild:menu];
        
    }
    
    return self;
}

//is called when the paused button is called to move the pause layer into screen
- (void)present
{
    CCMoveTo *move = [CCMoveTo actionWithDuration:0.2f position:ccp(self.contentSize.width / 2, self.contentSize.height * 0.5)];
    [self runAction:move];
    
}


//if the resume button is pressed
- (void)resumeButtonPressed
{
    [self hideAndResume];
    [self.delegate resumeButtonPressed:self];
}

- (void)hideAndResume
{
    if (self.parent != nil)
    {
        // animate off screen
        CGPoint targetPosition = ccp(self.contentSize.width / 2, self.contentSize.height * 1.5);
        CCMoveTo *move = [CCMoveTo actionWithDuration:0.2f position:targetPosition];
        
        CCCallBlock *removeFromParent = [[CCCallBlock alloc] initWithBlock:^{
            [self removeFromParentAndCleanup:TRUE];
            // resume the game
            [[GameMechanics sharedGameMechanics] setGameState:GameStateRunning];
        }];
        
        CCSequence *hideSequence = [CCSequence actions:move, removeFromParent, nil];
        [self runAction:hideSequence];
    }
}

//
- (void)selectLevelButtonPressed
{
    //remove this layer before going to the next
    self.visible = FALSE;
     [self removeFromParentAndCleanup:TRUE];
    //go to level selection layer
    [[[GameMechanics sharedGameMechanics] gameScene] goTolevelSelection];
}



- (void)mainMenuButtonPressed
{
    //remove this layer before going to the next
    self.visible = FALSE;
     [self removeFromParentAndCleanup:TRUE];
    //go to mainmenu layer
    [[[GameMechanics sharedGameMechanics] gameScene] goToMainMenu];
}

@end
