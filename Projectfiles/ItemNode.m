//
//  ItemNode.m
//  Veggy_V_Fruit
//
//  Created by Danny on 7/11/13.
//  Copyright (c) 2013 MakeGamesWithUs Inc. All rights reserved.
//

#import "ItemNode.h"


@implementation ItemNode

-(id)initWithImageFile:(NSString *)filename unitName:(NSString *) nameOfThisItem{
    self=[super initWithFile:filename];
    if(self){
        _nameOfItem=nameOfThisItem;
        notBought=[[CCSprite alloc]initWithFile:filename];
        [notBought setColor:ccc3(220,220,220)];
        notBought.position=ccp(self.position.x+self.contentSize.width/2,self.position.y+self.contentSize.height/2);
        
        [self addChild:notBought];
        notBought.visible=FALSE;
        [self reset];
//        [self setScale:.25];
    }
    return self;
}


-(void)select{
    if(self.ableToBuy){
        self.selected=TRUE;
    }
}

-(void)deselect{
    if(self.ableToBuy){
        self.selected=FALSE;
    }
}

-(void)reset{
    //check level of item
    self.level=[[[[[GameMechanics sharedGameMechanics] game] levelsOfEverything]objectForKey:_nameOfItem] integerValue];
    _unlockingItem= [[[[[[GameMechanics sharedGameMechanics]game]gameItemInfo]objectForKey:_nameOfItem]objectAtIndex:self.level+1]objectForKey:@"Required Item"] ;
    _requiredLevel=[[[[[[[GameMechanics sharedGameMechanics]game]gameItemInfo]objectForKey:_nameOfItem]objectAtIndex:self.level+1]objectForKey:@"Required Item Level"]integerValue];
    self.price=[[[[[[[GameMechanics sharedGameMechanics]game]gameItemInfo]objectForKey:_nameOfItem]objectAtIndex:self.level+1]objectForKey:@"Price"]integerValue];
//    self.itemDescription=[[[[[[GameMechanics sharedGameMechanics]game]gameItemInfo]objectForKey:_nameOfItem]objectAtIndex:self.level]objectForKey:@"Item Description"];
    self.levelDescription=[[[[[[GameMechanics sharedGameMechanics]game]gameItemInfo]objectForKey:_nameOfItem]objectAtIndex:self.level+1] objectForKey:@"Item Level Up Description"];
    
    int numberOfLevels=[[[[[GameMechanics sharedGameMechanics]game]gameItemInfo]objectForKey:_nameOfItem]count];
    //if the item level is 0 then it is already bought and is ableToBuy is true but have to check if it is able to upgrade
    if(self.level >=0){
        self.bought=TRUE;
        self.ableToBuy=TRUE;
        
        //if unlockingItem=@"----" then it is maxed level
        if(self.level != numberOfLevels-1){
            //check if the required item's level matches the required item's required level
            int levelOfRequiredItem=[[[[[GameMechanics sharedGameMechanics] game] levelsOfEverything] objectForKey:_unlockingItem] integerValue];
            if(levelOfRequiredItem >= _requiredLevel){
                //it matches the required items required level so it is able to be upgraded
                self.ableToUpgrade=TRUE;
            }else{
                //it did not match
                self.ableToUpgrade=FALSE;
            }
            
        }else{
            //it is maxed out so it cant be upgraded
            self.ableToUpgrade=FALSE;
        }
        
    }else{
        
        //the item's level is less than 0 so it has not been bought and have to check it you can buy it
        self.bought=FALSE;
        
        if(self.level != numberOfLevels-1){
            //check if required item's level matches required item's required level
            int levelOfRequiredItem=[[[[[GameMechanics sharedGameMechanics] game] levelsOfEverything] objectForKey:_unlockingItem] integerValue];
            if(levelOfRequiredItem >= _requiredLevel){
                //it matches so youre able to buy/ upgrade it
                self.ableToBuy=TRUE;
                self.ableToUpgrade=TRUE;
                notBought.visible=TRUE;
            }else{
                //it does not match so you can not buy or upgrade it
                self.ableToUpgrade=FALSE;
                self.ableToBuy=FALSE;
                notBought.visible=FALSE;
            }
        }else{
            //it is maxed out without being bought
            self.ableToUpgrade=FALSE;
            self.ableToBuy=FALSE;
            notBought.visible=FALSE;
            
        }
    }
    self.selected=FALSE;
}

-(BOOL)upgrade
{
    //if price is 0 then it cant be upgraded anymore, maxed
    if(self.price != 0){
        //get total gold
        int totalGold=[[GameMechanics sharedGameMechanics]game].gold;
        //if you have enought gold then the item is upgraded
        if(totalGold >= self.price){
            //subtract the gold
            [[[GameMechanics sharedGameMechanics]game] subtractGoldby:self.price];
            //increase level
            [[[GameMechanics sharedGameMechanics]game] increaseLevel:_nameOfItem];
            return TRUE;
        }
    }
    //if it reaches here then either there was not enough gold or its maxed
    return FALSE;
}

-(void)equipAtSlot{
    if(self.bought && self.ableToEquip){
        self.equiped=TRUE;
    }
}
-(void)unequip{
    if(self.bought && self.ableToEquip){
        self.equiped=FALSE;
    }
}

-(void)draw{
    if(!self.ableToBuy ){
        [self setColor:ccc3(0,0,0)];
    }else{
        if(self.equiped){
            
        }
        if(self.selected){
            ccColor4F rectColor = ccc4f(255, 255, 255, 255); //parameters correspond to red, green, blue, and alpha (transparancy)
            ccDrawSolidRect(ccp(0,0), ccp(self.contentSize.width,self.contentSize.height), rectColor);
        }
    }
[super draw];
}


@end
