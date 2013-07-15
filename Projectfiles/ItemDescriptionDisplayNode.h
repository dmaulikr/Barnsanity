//
//  ItemDescriptionDisplayNode.h
//  Veggy_V_Fruit
//
//  Created by Danny on 7/14/13.
//  Copyright (c) 2013 MakeGamesWithUs Inc. All rights reserved.
//

#import "CCNode.h"

@interface ItemDescriptionDisplayNode : CCNode
{
    NSMutableArray *labels;

}

-(id)initWithImage:(NSString *)fileName andFont:(NSString*) fontfile andNumberRow:(NSInteger)numRows;
-(void)setDescription:(NSMutableArray*)descriptions;
@end
