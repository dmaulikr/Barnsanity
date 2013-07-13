//
//  EquipScreen.m
//  Veggy_V_Fruit
//
//  Created by Danny on 7/10/13.
//  Copyright (c) 2013 MakeGamesWithUs Inc. All rights reserved.
//

#import "EquipScreen.h"
#import "GameMechanics.h"
#import "STYLES.h"
#import "MonsterButtonCache.h"
#import "SpawnMonsterButton.h"

#define MAXSLOTS 4;
@implementation EquipScreen
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
        backgroundNode.backgroundColor = ccc4(100, 100, 100, 100);
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
        storeItemLabel.position = ccp(0, 0.5 * self.contentSize.height - 25);
        [self addChild:storeItemLabel];
        
        //add a main menu button to go back to the main menu
        equip= [CCMenuItemFont itemWithString:@"Equip" block:^(id sender) {
            
        }];
        equip.color = DEFAULT_FONT_COLOR;
        [equip setScale:.5];
        equip.position=ccp(210,0);
        
        unequip= [CCMenuItemFont itemWithString:@"Unequip" block:^(id sender) {
            
        }];
        unequip.color = DEFAULT_FONT_COLOR;
        [unequip setScale:.5];
        unequip.position=ccp(210,0);
        unequip.visible=FALSE;
        
        //add a store button to make purchases
        back= [CCMenuItemFont itemWithString:@"Back" block:^(id sender) {
            [self backButtonPressed];
        }];
        back.color = DEFAULT_FONT_COLOR;
        [back setScale:.5];
        back.position=ccp(-200,0);
        
        //add all buttons to the menu
        menu = [CCMenu menuWithItems:back,equip,unequip, nil];
        menu.position = ccp(0,-100);
        [self addChild:menu];
        
        itemNodes=[[NSMutableArray alloc] init];
        itemButtons=[[NSMutableArray alloc] init];
        [self setUpitems];
        weapon=[CCMenu menuWithArray:itemButtons ];
        weapon.position = ccp(0,0);
        [self addChild:weapon];
        
        SpawnMonsterButton *buttonInUse;
        WeaponNode *weapons;
        CCARRAY_FOREACH([[MonsterButtonCache sharedMonsterButtonCache]children],buttonInUse){
            CCARRAY_FOREACH(itemNodes,weapons){
                if(buttonInUse.nameOfMonster == weapons.nameOfItem){
                    [weapons equipAtSlot];
                    break;
                }
            }
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

-(void)setUpitems{
    NSString *previous=nil;
    NSArray *playerMonsterList=[[NSArray alloc]initWithObjects:@"Orange",@"Apple",@"Strawberry",@"Cherry",@"Mango",@"Banana",@"Coconut",@"Grape",@"Pineapple",@"Watermelon",nil];
    for(NSInteger i =0; i<  playerMonsterList.count;i++){
        
        [itemNodes addObject:[[WeaponNode alloc] initWithImageFile:@"basicbarrell.png" unitName:playerMonsterList[i] atSlotPriority:i]];
        previous=playerMonsterList[i];
    }
    int row=0;
    int col=0;
    CCSprite *tempImage=[[CCSprite alloc] initWithFile:@"button_topdown-button.png"];
    for(int i=0;i<itemNodes.count;i++){
        
        CCMenuItemSprite *temp=[CCMenuItemSprite itemWithNormalSprite:itemNodes[i] selectedSprite:nil block:^(id sender) {
            [self selectItem:itemNodes[i]];
        }];
        temp.position=ccp(-130+col*(50+40),80-row*(50+10));
        [itemButtons addObject:temp];
        col++;
        if(col%4 ==0){
            row++;
            col=0;
        }
    }
}

-(void) backButtonPressed{
    //remove this layer before going to the level selection layer
    self.visible = FALSE;
    [self removeFromParentAndCleanup:TRUE];
    
    //go to level selection layer
    [[[GameMechanics sharedGameMechanics] gameScene] goTolevelSelection];
    
}


-(void) equipButtonPressed{

}

-(void)showDescriptionOfSelectedItem: (WeaponNode *)item{
    
}




-(void)selectItem:(WeaponNode *)itemSelected{
    if(itemSelected.ableToUse){
        [selectedItem deselect];
        selectedItem=itemSelected;
        [selectedItem select];
        [self showDescriptionOfSelectedItem:itemSelected];
    }
    if(itemSelected.equiped){
        equip.visible=FALSE;
        unequip.visible=TRUE;
    }else{
        equip.visible=TRUE;
        unequip.visible=FALSE;
    }
}


@end
