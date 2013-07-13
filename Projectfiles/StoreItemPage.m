//
//  StoreItemPage.m
//  Veggy_V_Fruit
//
//  Created by Danny on 7/12/13.
//  Copyright (c) 2013 MakeGamesWithUs Inc. All rights reserved.
//

#import "StoreItemPage.h"
#import "GameMechanics.h"
#import "STYLES.h"
#import "UpgradeScreen.h"

@implementation StoreItemPage
- (id)initWithGame
{
    self = [super init];
    
    if (self)
    {
        self.contentSize = [[CCDirector sharedDirector] winSize];
        // position of screen, animate to screen
        self.position = ccp(self.contentSize.width / 2, self.contentSize.height * .5);
        
        CCLayerColor* colorLayer = [CCLayerColor layerWithColor:SCREEN_BG_COLOR_TRANSPARENT];
        [self addChild:colorLayer z:0];
        
        itemNodes=[[NSMutableArray alloc] init];
        itemButtons=[[NSMutableArray alloc] init];
        [self setUpitems];
        menu=[CCMenu menuWithArray:itemButtons ];
        menu.position = ccp(0,0);
        [self addChild:menu];
    }
    
    return self;
}

-(void)setUpitems{
    @throw @"-(void)setUpItems is to be implemented in subclasses";
}

-(void)selectItem:(ItemNode *)itemSelected{
    if(itemSelected.ableToBuy){
        [selectedItem deselect];
        selectedItem=itemSelected;
        [selectedItem select];
        [(UpgradeScreen *)[self parent] showDescriptionOfSelectedItem:selectedItem] ;
    }
}

-(void)upgradeSelectedItem{
    if(![selectedItem upgrade]){
        
    }else{
        ItemNode *temp;
        for(int i =0; i<itemNodes.count;i++){
            temp=itemNodes[i];
            [temp reset];
         }
    }
}

-(void)removePage{
    self.visible=FALSE;
    [self removeFromParent];
}
@end
