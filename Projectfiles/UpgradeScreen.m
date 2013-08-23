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

#define UTIL 0
#define WEAPON 1
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
        
        
        //add buttons to go between pages
        
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
        
        //other buttons//
        
        //add a main menu button to go back to the main menu
        upgrade= [CCMenuItemFont itemWithString:@"Upgrade" block:^(id sender) {
            [self upgradeButtonPressed];
        }];
        upgrade.color = DEFAULT_FONT_COLOR;
        upgrade.position=ccp(180,-20);
        
        //add a store button to make purchases
        back= [CCMenuItemFont itemWithString:@"Back" block:^(id sender) {
            [self backButtonPressed];
        }];
        back.color = DEFAULT_FONT_COLOR;
        
        back.position=ccp(-200,-20);
        
        equip= [CCMenuItemFont itemWithString:@"Equip" block:^(id sender) {
            [self equipButtonPressed];
        }];
        equip.color = DEFAULT_FONT_COLOR;
        equip.position=ccp(180,30);
        equip.visible=FALSE;
        unequip= [CCMenuItemFont itemWithString:@"Unequip" block:^(id sender) {
            [self unequipButtonPressed];
        }];
        unequip.color = DEFAULT_FONT_COLOR;
        unequip.position=ccp(180,30);
        unequip.visible=FALSE;
        
        //add all buttons to the menu
        menu = [CCMenu menuWithItems:back,upgrade,equip,unequip, nil];
        menu.position = ccp(0,-100);
        [self addChild:menu];
        
        
        
        // add scoreboard entry for gold
        goldDisplay = [[ScoreboardEntryNode alloc] initWithfontFile:@"avenir24.fnt"];
        goldDisplay.position= ccp( 0, 0.5 * self.contentSize.height - 25);
        goldDisplay.scoreStringFormat = @"Gold: %d";
        [self addChild:goldDisplay];
        [goldDisplay setScore:[[GameMechanics sharedGameMechanics]game].gold];
        
        seedSlots= [[ScoreboardEntryNode alloc] initWithfontFile:@"avenir24.fnt"];
        seedSlots.position= ccp( 0.25 * self.contentSize.width - 25, 0.5 * self.contentSize.height - 25);
        seedSlots.scoreStringFormat = @"Seed Slot Left: %d";
        [self addChild:seedSlots];
        seedSlots.visible=FALSE;
        
        //how much description to display on screen and add the description on the screen
        countOfDescription=4;
        desciption=[[ItemDescriptionDisplayNode alloc]initWithImage:@"detail.jpg" andFont:@"avenir24.fnt" andNumberRow:countOfDescription];
        [desciption setScale:.7];
        desciption.position=ccp(0,-0.5 * self.contentSize.height+50);
        [self addChild:desciption];
        weaponSlot=[[NSMutableArray alloc]initWithCapacity:MAXSPAWNBUTTONS];
        
         [self setUpitemsWithList:[[GameMechanics sharedGameMechanics]game].utilUpgradeList];
        itemPage=UTIL;
    }
    
    return self;
}

-(void)setUpitemsWithList:(NSArray *)itemList{
    int row=0;
    int col=0;
    NSMutableArray *itemButtons=[[NSMutableArray alloc]init];
    NSMutableDictionary *itemNodes=[[NSMutableDictionary alloc]init];
    //for each player monster create a item node and place it on the screen
    for(NSInteger i =0; i<  itemList.count;i++){
        ItemNode *tempItem=[[ItemNode alloc] initWithImageFile:@"basicbarrell.png" unitName:itemList[i]];
        [itemNodes setObject:tempItem forKey:itemList[i]];
        CCMenuItemSprite *temp=[CCMenuItemSprite itemWithNormalSprite:tempItem selectedSprite:nil block:^(id sender) {
            [self selectItem:tempItem];
        }];
        temp.position=ccp(-130+col*(50+40),80-row*(50+10));
        [itemButtons addObject:temp];
        col++;
        if(col%4 ==0){
            row++;
            col=0;
        }
        tempItem.slotPriority=i;
    }
    currentItemNodes=itemNodes;
    CCMenu *itemMenu=[CCMenu menuWithArray:itemButtons];
    itemMenu.position = ccp(0,0);
    [self removeChildByTag:10];
    [self addChild:itemMenu z:1 tag:10];
    
    
}

-(void)nextPageButtonPressed{
    [self setUpitemsWithList:[[GameMechanics sharedGameMechanics]game].playerMonsterList];
    itemPage=WEAPON;
    //enable all the seed itemsNodes equipable
    NSMutableArray *itemNodes=[currentItemNodes allValues];
    for(int i=0; i<itemNodes.count;i++){
        ItemNode *tempItemNode=itemNodes[i];
        tempItemNode.ableToEquip=TRUE;
        tempItemNode.equiped=FALSE;
    }
    //load all the already equiped
    countOfEquiped=0;
    NSMutableArray *currentButtonSlots=[[GameMechanics sharedGameMechanics]game].seedsUsed;
    for(int i=0; i< MAXSPAWNBUTTONS;i++){
        
        if(![currentButtonSlots[i]isEqual: @""]){
            ItemNode *tempNode=[currentItemNodes objectForKey:currentButtonSlots[i]];
            weaponSlot[i]=tempNode.nameOfItem;
            [tempNode equipAtSlot];
            countOfEquiped++;
        }else{
            weaponSlot[i]=@"";
        }
    }
    previousPage.visible=TRUE;
    nextPage.visible=FALSE;
    NSMutableArray *temp=[[NSMutableArray alloc]initWithCapacity:countOfDescription];
    temp[0]=@"";
    temp[1]=@"";
    temp[2]=@"";
    temp[3]=@"";
    [desciption setDescription:temp];
    seedSlots.visible=TRUE;
    [seedSlots setScore:MAXSPAWNBUTTONS-countOfEquiped];
}

-(void)previousPageButtonPressed{
    if(countOfEquiped>0)
    {
        //must equip at least one weapon before leaving
        
        //sort the weapon slot according to the node's priority
        NSMutableArray *savingSlot=[[NSMutableArray alloc] initWithCapacity:MAXSPAWNBUTTONS];
        for(int i=0;i<MAXSPAWNBUTTONS;i++){
            ItemNode *nodeWithMinPriority=nil;
            ItemNode *currentNode=nil;
            int minPriority=MAX_INT;
            int minPriorityIndexLocation=-1;
            for(int j=0;j<MAXSPAWNBUTTONS;j++){
                if(![weaponSlot[j] isEqual:@""]){
                    currentNode=[currentItemNodes objectForKey:weaponSlot[j]];
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
        [[[GameMechanics sharedGameMechanics]game]saveGame];
        itemPage=UTIL;
        [self setUpitemsWithList:[[GameMechanics sharedGameMechanics]game].utilUpgradeList];
        previousPage.visible=FALSE;
        nextPage.visible=TRUE;
        NSMutableArray *temp=[[NSMutableArray alloc]initWithCapacity:countOfDescription];
        temp[0]=@"";
        temp[1]=@"";
        temp[2]=@"";
        temp[3]=@"";
        [desciption setDescription:temp];
        equip.visible=FALSE;
        unequip.visible=FALSE;
        seedSlots.visible=FALSE;
        
    }else{
        NSMutableArray *temp=[[NSMutableArray alloc]initWithCapacity:countOfDescription];
        temp[0]=[NSString stringWithFormat:@"Must Equip At Least One Weapon"];
        temp[1]=@"";
        temp[2]=@"";
        temp[3]=@"";
        [desciption setDescription:temp];
    }
    

}
-(void) backButtonPressed{
    if(itemPage==UTIL){
        //remove this layer before going to the level selection layer
        self.visible = FALSE;
        [self removeFromParentAndCleanup:TRUE];
        [[[GameMechanics sharedGameMechanics]game]saveGame];
        //go to level selection layer
        [[[GameMechanics sharedGameMechanics] gameScene] goTolevelSelection];
    }else if(countOfEquiped>0)
    {
        //must equip at least one weapon before leaving

        //sort the weapon slot according to the node's priority
        NSMutableArray *savingSlot=[[NSMutableArray alloc] initWithCapacity:MAXSPAWNBUTTONS];
        for(int i=0;i<MAXSPAWNBUTTONS;i++){
            ItemNode *nodeWithMinPriority=nil;
            ItemNode *currentNode=nil;
            int minPriority=MAX_INT;
            int minPriorityIndexLocation=-1;
            for(int j=0;j<MAXSPAWNBUTTONS;j++){
                if(![weaponSlot[j] isEqual:@""]){
                    currentNode=[currentItemNodes objectForKey:weaponSlot[j]];
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
        

        //remove this layer before going to the level selection layer
        self.visible = FALSE;
        [self removeFromParentAndCleanup:TRUE];
        [[[GameMechanics sharedGameMechanics]game]saveGame];
        //go to level selection layer
        [[[GameMechanics sharedGameMechanics] gameScene] goTolevelSelection];
    }else{
        NSMutableArray *temp=[[NSMutableArray alloc]initWithCapacity:countOfDescription];
        temp[0]=[NSString stringWithFormat:@"Must Equip At Least One Weapon"];
        temp[1]=@"";
        temp[2]=@"";
        temp[3]=@"";
        [desciption setDescription:temp];
    }
}


-(void) upgradeButtonPressed{
    if([selectedItem upgrade]){
        ItemNode *temp;
        NSMutableArray *itemNodes=[currentItemNodes allValues];
        for(int i =0; i<itemNodes.count;i++){
            temp=itemNodes[i];
            [temp reset];
            [self selectItem:selectedItem];
        }
    }else{
        NSMutableArray *temp=[[NSMutableArray alloc]initWithCapacity:countOfDescription];
        temp[0]=[NSString stringWithFormat:@"Not Enough Gold"];
        temp[1]=@"";
        temp[2]=@"";
        temp[3]=@"";
        [desciption setDescription:temp];
    }
    [goldDisplay setScore:[[GameMechanics sharedGameMechanics]game].gold];
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
    [seedSlots setScore:MAXSPAWNBUTTONS-countOfEquiped];
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
    [seedSlots setScore:MAXSPAWNBUTTONS-countOfEquiped];
}


-(void)selectItem:(ItemNode *)itemSelected{
    if(itemSelected.ableToBuy){
        [selectedItem deselect];
        selectedItem=itemSelected;
        [selectedItem select];
        [self showSelectedItem:selectedItem] ;
    }
    
    if(!selectedItem.ableToEquip || !selectedItem.bought){
        equip.visible=FALSE;
        unequip.visible=FALSE;
    }else if(selectedItem.ableToEquip && selectedItem.equiped){
        equip.visible=FALSE;
        unequip.visible=TRUE;
    }else if(!selectedItem.equiped && countOfEquiped==MAXSPAWNBUTTONS){
        equip.visible=FALSE;
        unequip.visible=FALSE;
    }else if(!selectedItem.ableToEquip || !selectedItem.bought){
        equip.visible=FALSE;
        unequip.visible=FALSE;
    }else if(selectedItem.ableToEquip && !selectedItem.equiped && countOfEquiped<MAXSPAWNBUTTONS){
        equip.visible=TRUE;
        unequip.visible=FALSE;
    }
}

-(void)showSelectedItem: (ItemNode *)item{
    NSMutableArray *temp=[[NSMutableArray alloc]initWithCapacity:countOfDescription];
    if(!item.maxed){
    temp[0]=[NSString stringWithFormat:@"Level %d %@", selectedItem.level+1, selectedItem.nameOfItem];
    temp[1]=[NSString stringWithFormat:@"Cost: %d", selectedItem.price];
    temp[2]=[NSString stringWithFormat:@"%@", selectedItem.levelDescription];

    if(selectedItem.ableToUpgrade){
        upgrade.visible=TRUE;
        temp[3]=[NSString stringWithFormat:@""];

    }else{
        upgrade.visible=FALSE;
        temp[3]=[NSString stringWithFormat:@"Requirment: level %d %@", selectedItem.requiredLevel, selectedItem.unlockingItem];
    }
    }else{
        temp[0]=[NSString stringWithFormat:@"Maxed %@", selectedItem.nameOfItem];
         temp[1]=[NSString stringWithFormat:@""];
         temp[2]=[NSString stringWithFormat:@""];
         temp[3]=[NSString stringWithFormat:@""];
         upgrade.visible=FALSE;
        
    }
    [desciption setDescription:temp];
    
    
}

@end