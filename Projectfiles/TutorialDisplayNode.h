//
//  TutorialDisplayNode.h
//  Veggy_V_Fruit
//
//  Created by Danny on 7/19/13.
//  Copyright (c) 2013 MakeGamesWithUs Inc. All rights reserved.
//

#import "CCSprite.h"

@interface TutorialDisplayNode : CCSprite
{
    CCLabelBMFont *labels;
    
}

-(id)initWithImage:(NSString *)fileName andFont:(NSString*) fontfile;
-(void)setDescription:(NSString *)descriptions;
@end
