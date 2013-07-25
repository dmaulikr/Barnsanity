//
//  TutorialDisplayNode.m
//  Veggy_V_Fruit
//
//  Created by Danny on 7/19/13.
//  Copyright (c) 2013 MakeGamesWithUs Inc. All rights reserved.
//

#import "TutorialDisplayNode.h"

@implementation TutorialDisplayNode
-(id)initWithImage:(NSString *)fileName andFont:(NSString*) fontfile{
    self = [super initWithFile:fileName];
    
    if (self)
    {
            labels = [CCLabelBMFont labelWithString:@"" fntFile:fontfile];
            labels.anchorPoint = ccp(0,0.5);
            labels.position=ccp(self.position.x+2,
                              self.position.y+self.contentSize.height/2);
        [labels setScale:.93];
            [self addChild:labels];
        [self setScale:1.1];
        
    }
    return self;
}

-(void)setDescription:(NSString *)descriptions{
    labels.string=[NSString stringWithFormat:descriptions];
}
@end
