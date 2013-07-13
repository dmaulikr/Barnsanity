//
//  WeaponNode.m
//  Veggy_V_Fruit
//
//  Created by Danny on 7/12/13.
//  Copyright (c) 2013 MakeGamesWithUs Inc. All rights reserved.
//

#import "WeaponNode.h"

@implementation WeaponNode

-(id)initWithImageFile:(NSString *)filename unitName:(NSString *) nameOfThisItem atSlotPriority:(NSInteger)priority{
    self=[super initWithFile:filename];
    if(self){
        self.nameOfItem=nameOfThisItem;
        self.slotPriority=priority;
        self.level=[[[[[[GameMechanics sharedGameMechanics] game] levelsOfEverything] objectForKey:@"Player Monsters" ] objectForKey:self.nameOfItem] integerValue];
        if(self.level>=0){
            self.ableToUse=TRUE;
        }

    }
    return self;
}




-(void)select{
    if(self.ableToUse){
        self.selected=TRUE;
    }
}

-(void)deselect{
    if(self.ableToUse){
        self.selected=FALSE;
    }
}

-(void)equipAtSlot{
    if(self.ableToUse){
        self.equiped=TRUE;
    }
}
-(void)unequip{
    if(self.ableToUse){
        self.equiped=FALSE;
    }
}



-(void)draw{
    if(!self.ableToUse ){
        [self setColor:ccc3(0,0,0)];
    }else{
        if(self.selected){
            ccColor4F rectColor = ccc4f(255, 255, 255, 255); //parameters correspond to red, green, blue, and alpha (transparancy)
            ccDrawSolidRect(ccp(0,0), ccp(self.contentSize.width,self.contentSize.height), rectColor);
        }
    }
    [super draw];
    if(self.equiped){
        [self setColor:ccc3(211,211,211)];
        
    
    }
}

@end
