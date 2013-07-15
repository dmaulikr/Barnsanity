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
        CCLabelTTF *storeItemLabel = [CCLabelTTF labelWithString:@"Equip"
                                                        fontName:DEFAULT_FONT
                                                        fontSize:16];
        storeItemLabel.color = DEFAULT_FONT_COLOR;
        storeItemLabel.position = ccp(0, 0.5 * self.contentSize.height - 25);
        [self addChild:storeItemLabel];
        
        //add a main menu button to go back to the main menu
        equip= [CCMenuItemFont itemWithString:@"Equip" block:^(id sender) {
            [self equipButtonPressed];
        }];
        equip.color = DEFAULT_FONT_COLOR;
        [equip setScale:.5];
        equip.position=ccp(210,0);
        equip.visible=FALSE;
        unequip= [CCMenuItemFont itemWithString:@"Unequip" block:^(id sender) {
            [self unequipButtonPressed];
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
        
        countOfDescription=2;
        desciption=[[ItemDescriptionDisplayNode alloc]initWithImage:@"detail.png" andFont:@"avenir24.fnt" andNumberRow:countOfDescription];
        [desciption setScale:.7];
        desciption.position=ccp(0,-0.5 * self.contentSize.height+50);
        [self addChild:desciption];
        
        itemNodes=[[NSMutableDictionary alloc] init];
        itemButtons=[[NSMutableArray alloc] init];
        [self setUpitems];
        weapon=[CCMenu menuWithArray:itemButtons ];
        weapon.position = ccp(0,0);
        [self addChild:weapon];
        countOfEquiped=0;
        weaponSlot=[[NSMutableArray alloc]initWithCapacity:MAXSPAWNBUTTONS];
        NSMutableArray *currentButtonSlots=[[GameMechanics sharedGameMechanics]game].seedsUsed;
        for(int i=0; i< MAXSPAWNBUTTONS;i++){
            
            if(![currentButtonSlots[i]isEqual: @""]){
                WeaponNode *tempNode=[itemNodes objectForKey:currentButtonSlots[i]];
                weaponSlot[i]=tempNode.nameOfItem;
                [tempNode equipAtSlot];
                countOfEquiped++;
            }else{
                weaponSlot[i]=@"";
            }
        }
        
        
        
    }
    
    return self;
}



-(void)setUpitems{
    int row=0;
    int col=0;
    NSArray *playerMonsterList=[[NSArray alloc]initWithObjects:@"Orange",@"Apple",@"Strawberry",@"Cherry",@"Mango",@"Banana",@"Coconut",@"Grape",@"Pineapple",@"Watermelon",nil];
    for(NSInteger i =0; i<  playerMonsterList.count;i++){
        WeaponNode *tempNode=[[WeaponNode alloc] initWithImageFile:@"basicbarrell.png" unitName:playerMonsterList[i] atSlotPriority:i];
        [itemNodes setObject:tempNode forKey:playerMonsterList[i]];
        
        
        CCMenuItemSprite *temp=[CCMenuItemSprite itemWithNormalSprite:tempNode selectedSprite:nil block:^(id sender) {
            [self selectItem:tempNode];
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
    //must equip at least one weapon before leaving
    if(countOfEquiped>0)
    {
        //sort the weapon slot according to the node's priority
        NSMutableArray *savingSlot=[[NSMutableArray alloc] initWithCapacity:MAXSPAWNBUTTONS];
        for(int i=0;i<MAXSPAWNBUTTONS;i++){
            WeaponNode *nodeWithMinPriority=nil;
            WeaponNode *currentNode=nil;
            int minPriority=MAX_INT;
            int minPriorityIndexLocation=-1;
            for(int j=0;j<MAXSPAWNBUTTONS;j++){
                if(![weaponSlot[j] isEqual:@""]){
                    currentNode=[itemNodes objectForKey:weaponSlot[j]];
                    if(currentNode.slotPriority < minPriority){
                        nodeWithMinPriority=currentNode;
                        minPriority=currentNode.slotPriority;
                        minPriorityIndexLocation=j;
                    }
                }
            }
            if(nodeWithMinPriority==nil){
                savingSlot[i]=@"";
            }else{
                weaponSlot[minPriorityIndexLocation]=@"";
                savingSlot[i]=nodeWithMinPriority.nameOfItem;
            }
        }
        
        //send the seeds chosen to the game class
        [[GameMechanics sharedGameMechanics]game].seedsUsed=savingSlot;
        //save the game
        [[[GameMechanics sharedGameMechanics]game]saveGame];
        //remove this layer before going to the level selection layer
        self.visible = FALSE;
        [self removeFromParentAndCleanup:TRUE];
        
        //go to level selection layer
        [[[GameMechanics sharedGameMechanics] gameScene] goTolevelSelection];
    }
    
}


-(void) equipButtonPressed{
    
    //if the number of slot for weapon is less than the max number of spawn button you can have, equip the weapon
    if(countOfEquiped < MAXSPAWNBUTTONS){
        for(int i=0;i<MAXSPAWNBUTTONS;i++){
            //insert it at the first open slot
            if([weaponSlot[i]isEqual:@""]){
                countOfEquiped++;
                weaponSlot[i]=selectedItem.nameOfItem;
                [selectedItem equipAtSlot];
                [ self selectItem:selectedItem];
                break;
            }
        }
    }
    
}


-(void) unequipButtonPressed{
    if(countOfEquiped > 0){
        for(int i=0;i<MAXSPAWNBUTTONS;i++){
            if([weaponSlot[i]isEqual:selectedItem.nameOfItem]){
                countOfEquiped--;
                weaponSlot[i]=@"";
                [selectedItem unequip];
                [ self selectItem:selectedItem];
                break;
            }
        }
    }
}

-(void)showDescriptionOfSelectedItem: (WeaponNode *)item{
    NSMutableArray *temp=[[NSMutableArray alloc]initWithCapacity:countOfDescription];
    
    temp[0]=[NSString stringWithFormat:@"Level %d %@", item.level, item.nameOfItem];
    temp[1]=[NSString stringWithFormat:@"%@", item.description];
    [desciption setDescription:temp];
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
