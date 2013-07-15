//
//  WeaponNode.h
//  Veggy_V_Fruit
//
//  Created by Danny on 7/12/13.
//  Copyright (c) 2013 MakeGamesWithUs Inc. All rights reserved.
//

#import "CCSprite.h"
#import "GameMechanics.h"
@interface WeaponNode : CCSprite
{

}
@property (nonatomic, assign) BOOL ableToUse;
@property (nonatomic, assign) BOOL equiped;
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, assign) NSInteger slotPriority;
@property (nonatomic, assign) NSInteger level;

@property (nonatomic, assign) NSString *description;
@property (nonatomic, assign) NSString *nameOfItem;

-(id)initWithImageFile:(NSString *)filename unitName:(NSString *) nameOfThisItem atSlotPriority:(NSInteger)priority;

-(void)select;
-(void)deselect;
-(void)equipAtSlot;
-(void)unequip;

@end
