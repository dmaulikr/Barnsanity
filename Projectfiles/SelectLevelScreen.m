//
//  SelectLevelScreen.m
//  Veggy_V_Fruit
//
//  Created by Danny on 7/10/13.
//  Copyright (c) 2013 MakeGamesWithUs Inc. All rights reserved.
//

#import "SelectLevelScreen.h"
#import "GameMechanics.h"
#import "STYLES.h"
#import "ScoreboardEntryNode.h"



@implementation SelectLevelScreen

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
        CCLabelTTF *storeItemLabel = [CCLabelTTF labelWithString:@"Select Level"
                                                        fontName:DEFAULT_FONT
                                                        fontSize:32];
        storeItemLabel.color = DEFAULT_FONT_COLOR;
        storeItemLabel.position = ccp(0, 0.5 * self.contentSize.height - 25);
        [self addChild:storeItemLabel];
        
        
        
        // add scoreboard entry for points
        ScoreboardEntryNode *goldDisplay = [[ScoreboardEntryNode alloc] initWithfontFile:@"avenir24.fnt"];
        goldDisplay.position= ccp( 0.25 * self.contentSize.width - 25, 0.5 * self.contentSize.height - 25);
        goldDisplay.scoreStringFormat = @"Gold: %d";
        [self addChild:goldDisplay];
        [goldDisplay setScore:[[GameMechanics sharedGameMechanics]game].gold];
        
        // add scoreboard entry for points
        ScoreboardEntryNode *scoreDisplay = [[ScoreboardEntryNode alloc] initWithfontFile:@"avenir24.fnt"];
        scoreDisplay.position=ccp(-0.25 * self.contentSize.width - 100, 0.5 * self.contentSize.height - 25);
        scoreDisplay.scoreStringFormat = @"Score: %d";
        [self addChild:scoreDisplay];
        [scoreDisplay setScore:[[GameMechanics sharedGameMechanics]game].score];
        
        
        
        // add a play button to play the level
        playLevel= [CCMenuItemFont itemWithString:@"Play" block:^(id sender) {
            [self playButtonPressed];
        }];
        playLevel.color = DEFAULT_FONT_COLOR;
        playLevel.position=ccp(-150,0);
        
        store= [CCMenuItemFont itemWithString:@"Store" block:^(id sender) {
            [self storeButtonPressed];
        }];
        store.color = DEFAULT_FONT_COLOR;
        store.position=ccp(0,0);
        
        option= [CCMenuItemFont itemWithString:@"Option" block:^(id sender) {
            [self optionPressed];
        }];
        option.color = DEFAULT_FONT_COLOR;
        option.position=ccp(150,0);
        //add all buttons to the menu
        menu = [CCMenu menuWithItems:playLevel,store,option, nil];
        menu.position = ccp(0,-100);
        [self addChild:menu];
        
        //find the max level allowed (max level is the level the the player has not beaten yet)
        maxLevelToPlay=[[GameMechanics sharedGameMechanics]game].maxGamePlayLevel;
        //levelToPlay is the level the player chooses to play in can range from 0 to maxLevelToPlay
        levelToPlay=maxLevelToPlay;
        
        //shows to the player which level they are selecting
        level = [CCLabelBMFont labelWithString:@"" fntFile:@"avenir24.fnt"];
        level.string=[NSString stringWithFormat:@"%d", levelToPlay];
        level.anchorPoint=ccp(0,0.5);
        level.position = ccp(-5, 0);
        [level setScale:3];
        [self addChild:level];
        
        //add a decrease level button to decrease the level to play with
        CCSprite *decreaseButton = [CCSprite spriteWithFile:@"button_playbutton.png"];
        decreaseButton.flipX=180;
        CCSprite *decreaseButtonPressed = [CCSprite spriteWithFile:@"button_playbutton.png"];
        decreaseButtonPressed.flipX=180;
        decreaseLevel = [CCMenuItemSprite itemWithNormalSprite:decreaseButton selectedSprite:decreaseButtonPressed block:^(id sender) {
            [self decreaseLevelToPlay];
        }];
        decreaseLevel.position=ccp(-80, 0);
        
        //add a increase level button to increase the level to play with
        CCSprite *increaseButton = [CCSprite spriteWithFile:@"button_playbutton.png"];
        CCSprite *increaseButtonPressed = [CCSprite spriteWithFile:@"button_playbutton.png"];
        increaseLevel= [CCMenuItemSprite itemWithNormalSprite:increaseButton selectedSprite:increaseButtonPressed block:^(id sender) {
            [self increaseLevelToPlay];
        }];
        increaseLevel.position=ccp(80, 0);
        
        //add the increase and decrease button into the menu
        levelSelection=[CCMenu menuWithItems:decreaseLevel, increaseLevel, nil];
        levelSelection.position=ccp(0,0);
        [self addChild:levelSelection];
        
        //        //volume control button
        //        CCSprite *volume = [CCSprite spriteWithFile:@"view.png"];
        //        volumeControl = [CCMenuItemSprite itemWithNormalSprite:volume selectedSprite:volume block:^(id sender) {
        //            [self volumeControl];
        //        }];
        
        requiredLevel = [CCLabelTTF labelWithString:@"Required Game Level 5"
                                           fontName:DEFAULT_FONT
                                           fontSize:14];
        requiredLevel.color = DEFAULT_FONT_COLOR;
        requiredLevel.position = ccp(0, -0.5 * self.contentSize.height + 30);
        [self addChild:requiredLevel];
        requiredLevel.visible=FALSE;
        if([[GameMechanics sharedGameMechanics]game].activateStoreTutorial){
            [store runAction:[CCRepeatForever actionWithAction:[CCBlink actionWithDuration:2.0f blinks:1]]];
        }
    }
    
    return self;
}

//called when this layer is called
- (void)present
{
    CCMoveTo *move = [CCMoveTo actionWithDuration:0.2f position:ccp(self.contentSize.width / 2, self.contentSize.height * 0.5)];
    [self runAction:move];
    
}

- (void)playButtonPressed
{
    if(![[GameMechanics sharedGameMechanics]game].activateStoreTutorial){
        //remove this layer before going to the next
        self.visible = FALSE;
        [self removeFromParentAndCleanup:TRUE];
        
        //set the level the player wants to play with
        [[GameMechanics sharedGameMechanics]game].gameplayLevel=levelToPlay;
        //start the level
        [[[GameMechanics sharedGameMechanics] gameScene] startGame];
    }
}

- (void)mainMenuButtonPressed
{
    //remove this layer before going to the next
    self.visible = FALSE;
    [self removeFromParentAndCleanup:TRUE];
    //go to mainmenu layer
    [[[GameMechanics sharedGameMechanics] gameScene] goToMainMenu];
}

-(void) optionButtonPressed{
    
}

-(void)decreaseLevelToPlay{
    //levelToPlay cannot go below level 0
    if(levelToPlay >0){
        levelToPlay--;
    }
    level.string=[NSString stringWithFormat:@"%d", levelToPlay];
}

-(void)increaseLevelToPlay{
    //levelToPlay cannot go beyond maxLevelToPlay
    if(levelToPlay < maxLevelToPlay){
        levelToPlay++;
    }
    level.string=[NSString stringWithFormat:@"%d", levelToPlay];
}

-(void)storeButtonPressed{
        if(maxLevelToPlay>=5){
    if([[GameMechanics sharedGameMechanics]game].activateStoreTutorial){
        //remove this layer before going to the next
        self.visible = FALSE;
        [self removeFromParentAndCleanup:TRUE];
        //go to store layer
        [[[GameMechanics sharedGameMechanics] gameScene] shopTutorial];
    }else{
        //remove this layer before going to the next
        self.visible = FALSE;
        [self removeFromParentAndCleanup:TRUE];
        //go to store layer
        [[[GameMechanics sharedGameMechanics] gameScene] goToStore];
    }
        }else{
            requiredLevel.visible=TRUE;
        }
}

-(void)optionPressed{
    if(![[GameMechanics sharedGameMechanics]game].activateStoreTutorial){
        self.visible = FALSE;
        [self removeFromParentAndCleanup:TRUE];
        //go to store layer
        [[[GameMechanics sharedGameMechanics] gameScene] goToOption];
    }
}



@end
