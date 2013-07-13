//
//  ItemNode.h
//  Veggy_V_Fruit
//
//  Created by Danny on 7/11/13.
//  Copyright (c) 2013 MakeGamesWithUs Inc. All rights reserved.
//

#import "CCSprite.h"
#import "GameMechanics.h"
@interface ItemNode : CCSprite
{
    NSString *nameOfItem;
    //requirement
    NSString *unlockingItem;
    NSInteger requiredLevel;
}
@property (nonatomic, assign) BOOL ableToBuy;
@property (nonatomic, assign) BOOL bought;
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, assign) NSInteger level;
@property (nonatomic, assign) NSInteger price;
@property (nonatomic, assign) NSString *description;

-(id)initWithImageFile:(NSString *)filename unitName:(NSString *) nameOfThisItem unlockingItemName: (NSString*)nameOfUnlocking withRequiredLevel:(NSInteger) requiredLvl;

-(void) reset;
-(void)select;
-(void)deselect;
-(BOOL)upgrade;
@end
