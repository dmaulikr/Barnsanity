//
//  UpgradeScreen.m
//  Veggy_V_Fruit
//
//  Created by Danny on 7/11/13.
//  Copyright (c) 2013 MakeGamesWithUs Inc. All rights reserved.
//

#import "UpgradeScreen.h"
#import "GameMechanics.h"
#import "STYLES.h"
#import "SeedScreen.h"

@implementation UpgradeScreen
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
        CCLabelTTF *storeItemLabel = [CCLabelTTF labelWithString:@"Upgrade Store"
                                                        fontName:DEFAULT_FONT
                                                        fontSize:16];
        storeItemLabel.color = DEFAULT_FONT_COLOR;
        storeItemLabel.position = ccp(-0.25 * self.contentSize.width - 25, 0.5 * self.contentSize.height - 25);
        [self addChild:storeItemLabel];
        
        
        //add a decrease level button to decrease the level to play with
        CCSprite *previousPageImage = [CCSprite spriteWithFile:@"button_playbutton.png"];
        previousPageImage.flipX=180;
        [previousPageImage setScale:.5];
        previousPage = [CCMenuItemSprite itemWithNormalSprite:previousPageImage selectedSprite:nil block:^(id sender) {
            [self previousPageButtonPressed];
        }];
        previousPage.position=ccp(-200, 0);
        previousPage.visible=FALSE;
        
        CCSprite *nextPageImage = [CCSprite spriteWithFile:@"button_playbutton.png"];
        [nextPageImage setScale:.5];
        nextPage = [CCMenuItemSprite itemWithNormalSprite:nextPageImage selectedSprite:nil block:^(id sender) {
            [self nextPageButtonPressed];
        }];
        nextPage.position=ccp(220, 0);
        //add the increase and decrease button into the menu
        page=[CCMenu menuWithItems:previousPage, nextPage, nil];
        page.position=ccp(0,0);
        [self addChild:page];
        
        //add a main menu button to go back to the main menu
        upgrade= [CCMenuItemFont itemWithString:@"Upgrade" block:^(id sender) {
            
        }];
        upgrade.color = DEFAULT_FONT_COLOR;
        [upgrade setScale:.5];
        upgrade.position=ccp(210,0);
        
        //add a store button to make purchases
        back= [CCMenuItemFont itemWithString:@"Back" block:^(id sender) {
            [self backButtonPressed];
        }];
        back.color = DEFAULT_FONT_COLOR;
        [back setScale:.5];
        back.position=ccp(-200,0);
        
        //add all buttons to the menu
        menu = [CCMenu menuWithItems:back,upgrade, nil];
        menu.position = ccp(0,-100);
        [self addChild:menu];
        
        upgradePages=[[NSMutableArray alloc]init];
        //for the seed page
        [upgradePages addObject:[SeedScreen class]];
        currentPageNumber=0;
        [upgradePages addObject:[UtilityScreen class]];
        currentPage=[(StoreItemPage *) [upgradePages[currentPageNumber] alloc] initWithGame];
        currentPage.position=ccp(0,0);
        [self addChild:currentPage z:MAX_INT];
        
        // add scoreboard entry for points
        goldDisplay = [[ScoreboardEntryNode alloc] initWithfontFile:@"avenir24.fnt"];
        goldDisplay.position= ccp( 0.25 * self.contentSize.width - 25, 0.5 * self.contentSize.height - 25);
        goldDisplay.scoreStringFormat = @"Gold: %d";
        [self addChild:goldDisplay];
        [goldDisplay setScore:[[GameMechanics sharedGameMechanics]game].gold];
        
        countOfDescription=4;
        desciption=[[ItemDescriptionDisplayNode alloc]initWithImage:@"detail.jpg" andFont:@"avenir24.fnt" andNumberRow:countOfDescription];
        [desciption setScale:.7];
        desciption.position=ccp(0,-0.5 * self.contentSize.height+50);
        [self addChild:desciption];
    }
    
    return self;
}

//called when this layer is called
- (void)present
{
    CCMoveTo *move = [CCMoveTo actionWithDuration:0.2f position:ccp(self.contentSize.width / 2, self.contentSize.height * 0.5)];
    [self runAction:move];
    
}


-(void)nextPageButtonPressed{
    [currentPage removePage];
    currentPageNumber++;
    currentPage=[(StoreItemPage *) [upgradePages[currentPageNumber] alloc] initWithGame];
    currentPage.position=ccp(0,0);
    [self addChild:currentPage z:MAX_INT];
    
    if(currentPageNumber+1 == upgradePages.count){
        nextPage.visible=FALSE;
        previousPage.visible=TRUE;
    }else{
        nextPage.visible=TRUE;
        previousPage.visible=TRUE;
    }
    
    
    
}

-(void)previousPageButtonPressed{
    [currentPage removePage];
    currentPageNumber--;
    currentPage=[(StoreItemPage *) [upgradePages[currentPageNumber] alloc] initWithGame];
    currentPage.position=ccp(0,0);
    [self addChild:currentPage z:MAX_INT];
    
    if(currentPageNumber+1 == 1){
        previousPage.visible=FALSE;
        nextPage.visible=TRUE;
    }else{
        nextPage.visible=TRUE;
        previousPage.visible=TRUE;
    }
    
}
-(void) backButtonPressed{
    //remove this layer before going to the level selection layer
    self.visible = FALSE;
    [self removeFromParentAndCleanup:TRUE];
    //save game
    [[[GameMechanics sharedGameMechanics] game]saveGame];
    //go to level selection layer
    [[[GameMechanics sharedGameMechanics] gameScene] goTolevelSelection];
    
}


-(void) upgradeButtonPressed{
    if([currentPage upgradeSelectedItem]){
        
    }
    [goldDisplay setScore:[[GameMechanics sharedGameMechanics]game].gold];
}

-(void)showSelectedItem: (ItemNode *)item{
    selectedItem=item;
    NSMutableArray *temp=[[NSMutableArray alloc]initWithCapacity:countOfDescription];
    
    temp[0]=[NSString stringWithFormat:@"Level %d %@", selectedItem.level, selectedItem.nameOfItem];
    temp[1]=[NSString stringWithFormat:@"Cost: %d", selectedItem.price];
    temp[2]=[NSString stringWithFormat:@"Requirment: level %d %@", selectedItem.requiredLevel, selectedItem.unlockingItem];
    temp[3]=[NSString stringWithFormat:@"%@", selectedItem.levelDescription];
    [desciption setDescription:temp];
    
    if(selectedItem.ableToUpgrade){
        upgrade.visible=TRUE;
    }else{
        upgrade.visible=FALSE;
    }
}

@end