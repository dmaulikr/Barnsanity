//
//  MainMenuLayer.m
//  _MGWU-SideScroller-Template_
//
//  Created by Benjamin Encz on 5/15/13.
//  Copyright (c) 2013 MakeGamesWithUs Inc. Free to use for all purposes.
//

#import "MainMenuLayer.h"
#import "GameplayLayer.h"
#import "Leaderboard.h"
#import "STYLES.h"
#import "GameMechanics.h"

#define TITLE_LABEL @"Endless Runner Demo Game"
#define TITLE_AS_SPRITE TRUE

@interface MainMenuLayer ()

@end

@implementation MainMenuLayer


-(id) init
{
	if (self = [super init])
    {
        
        // set background color
        CCLayerColor* colorLayer = [CCLayerColor layerWithColor:SCREEN_BG_COLOR_TRANSPARENT];
        [self addChild:colorLayer z:0];
        
        //setup the start menu title
            // OPTION 1: Title as Text
            CCLabelTTF *tempStartTitleLabel = [CCLabelTTF labelWithString:@"Barnsanity"
                                                                 fontName:@"Arial"
                                                                 fontSize:40];
            tempStartTitleLabel.color = DEFAULT_FONT_COLOR;
            startTitleLabel = tempStartTitleLabel;
        
        
        CGPoint screenCenter = [CCDirector sharedDirector].screenCenter;
        CGSize screenSize = [CCDirector sharedDirector].screenSize;
        
        // place the startTitleLabel off-screen, later we will animate it on screen
        startTitleLabel.position = ccp (screenCenter.x, screenSize.height + 100);
        
        // this will be the point, we will animate the title to
        startTitleLabelTargetPoint = ccp(screenCenter.x, screenSize.height - 80);
        
		[self addChild:startTitleLabel];
        
        /* add a load button to load previous game */
        continueButton= [CCMenuItemFont itemWithString:@"Play" block:^(id sender) {
            [self continueButtonPressed];
        }];
        continueButton.color = DEFAULT_FONT_COLOR;
        

        
        //add all buttons into the menu
        startMenu = [CCMenu menuWithItems:continueButton, nil];
        startMenu.position = ccp(screenCenter.x, screenCenter.y - 50);
        [startMenu alignItemsVertically];
        [self addChild: startMenu];
        
        
	}
    
	return self;
}

- (void)continueButtonPressed
{
    //if there is a game saved it will return true and it will load that game, else you cannot load a previous game
    [[[GameMechanics sharedGameMechanics] game] loadGame];
        //remove this layer before going to the level selection layer
        self.visible = FALSE;
        [self removeFromParentAndCleanup:TRUE];
        
        //go to level selection layer
        [[[GameMechanics sharedGameMechanics] gameScene] goTolevelSelection];
    
}





#pragma mark - Scene Lifecyle

/**
 This method is called when the scene becomes visible. You should add any code, that shall be executed once
 the scene is visible, to this method.
 */
-(void)onEnterTransitionDidFinish
{
    [super onEnterTransitionDidFinish];
    
    // animate the title on to screen
    CCMoveTo *move = [CCMoveTo actionWithDuration:1.f position:startTitleLabelTargetPoint];
    id easeMove = [CCEaseBackInOut actionWithAction:move];
    [startTitleLabel runAction: easeMove];
    
}

@end
