//
//  ItemDescriptionDisplayNode.m
//  Veggy_V_Fruit
//
//  Created by Danny on 7/14/13.
//  Copyright (c) 2013 MakeGamesWithUs Inc. All rights reserved.
//

#import "ItemDescriptionDisplayNode.h"

@implementation ItemDescriptionDisplayNode
-(id)initWithImage:(NSString *)fileName andFont:(NSString*) fontfile andNumberRow:(NSInteger)numRows{
    self = [super init];
    
    if (self)
    {
        CCSprite *background=[[CCSprite alloc]initWithFile:fileName];
        [background setScale:2];
        [self addChild:background];
        
        
        labels=[[NSMutableArray alloc]initWithCapacity:numRows];
        
        for(int i=0;i<numRows;i++){
            CCLabelBMFont *temp = [CCLabelBMFont labelWithString:@"" fntFile:fontfile];
            temp.anchorPoint = ccp(0,0.5);
            float deltay=(((numRows-i)/(float)numRows)*background.contentSize.height/2);
            temp.position=ccp(background.position.x-background.contentSize.width,
                              background.position.y+deltay*2-18);
            [temp setScale:2];
            [self addChild:temp z:1];
            labels[i]=temp;
        }
                
    }
    
    return self;
}

-(void)setDescription:(NSMutableArray*)descriptions{
    int count;
    if(descriptions.count<=labels.count){
        count=descriptions.count;
    }else{
        count=labels.count;
    }
    
    for(int i=0;i<count;i++){
        ((CCLabelBMFont*)labels[i]).string=descriptions[i];
    }
}


@end
