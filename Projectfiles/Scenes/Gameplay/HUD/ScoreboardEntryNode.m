//
//  ScoreboardEntryNode.m
//  _MGWU-SideScroller-Template_
//
//  Created by Benjamin Encz on 5/16/13.
//  Copyright (c) 2013 MakeGamesWithUs Inc. Free to use for all purposes.
//

#import "ScoreboardEntryNode.h"

@implementation ScoreboardEntryNode

@synthesize score = _score;

- (id)initWithfontFile:(NSString *)fontFile
{
    self = [super init];
    
    if (self)
    {
        self.scoreStringFormat = @"%d";
        scoreLabel = [CCLabelBMFont labelWithString:@"" fntFile:fontFile];
        
        scoreLabel.anchorPoint = ccp(0,0.5);
        [self addChild:scoreLabel];
        

    }
    
    return self;
}

- (void)setScore:(int)score
{
    _score = score;
    
    scoreLabel.string = [NSString stringWithFormat:_scoreStringFormat, score];
}

@end
