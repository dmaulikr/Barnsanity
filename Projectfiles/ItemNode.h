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
}
@property (nonatomic, assign) BOOL ableToBuy;
@property (nonatomic, assign) BOOL ableToUpgrade;
@property (nonatomic, assign) BOOL bought;
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, assign) NSInteger level;
@property (nonatomic, assign) NSInteger price;
@property (nonatomic, assign) NSString *nameOfItem;
@property (nonatomic, assign) NSString *unlockingItem;
@property (nonatomic, assign) NSInteger requiredLevel;
@property (nonatomic, assign) NSString *itemDescription;
@property (nonatomic, assign) NSString *levelDescription;

-(id)initWithImageFile:(NSString *)filename unitName:(NSString *) nameOfThisItem;

-(void) reset;
-(void)select;
-(void)deselect;
-(BOOL)upgrade;
@end
