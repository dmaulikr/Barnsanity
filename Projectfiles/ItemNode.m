//
//  ItemNode.m
//  Veggy_V_Fruit
//
//  Created by Danny on 7/11/13.
//  Copyright (c) 2013 MakeGamesWithUs Inc. All rights reserved.
//

#import "ItemNode.h"


@implementation ItemNode

-(id)initWithImageFile:(NSString *)filename unitName:(NSString *) nameOfThisItem unlockingItemName: (NSString*)nameOfUnlocking withRequiredLevel:(NSInteger*) requiredLvl{
    self=[super initWithFile:filename];
    if(self){
        nameOfItem=nameOfThisItem;
        unlockingItem=nameOfUnlocking;
        requiredLevel=requiredLvl;
        [self reset];
//        [self setScale:.25];
    }
    return self;
}

-(void)reset
{

    @throw @"- (void)reset has to be implemented in Subclass.";

    
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

-(BOOL)upgrade
{
    
    @throw @"- (BOOL)upgrade has to be implemented in Subclass.";
    
    
}

-(void)draw{
    if(!self.ableToBuy ){
        [self setColor:ccc3(0,0,0)];
    }else{
        if(!self.bought){
            [self setColor:ccc3(211,211,211)];
        }
        if(self.selected){
            ccColor4F rectColor = ccc4f(255, 255, 255, 255); //parameters correspond to red, green, blue, and alpha (transparancy)
            ccDrawSolidRect(ccp(0,0), ccp(self.contentSize.width,self.contentSize.height), rectColor);
        }
    }
[super draw];
}


@end
