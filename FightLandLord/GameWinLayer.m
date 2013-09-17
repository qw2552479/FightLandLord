//
//  GameWinLayer.m
//  FightLandLord
//
//  Created by aatc on 9/9/13.
//  Copyright 2013 nchu. All rights reserved.
//

#import "GameWinLayer.h"


@implementation GameWinLayer
//1为地主，2为农民
+(id)initWithWinnerIndentify:(int)indentify withParentNode:(CCNode *)parentNode
{
    return [[self alloc] initWithWinnerIndentify:indentify withParentNode:parentNode];
}
-(id) initWithWinnerIndentify:(int)indentify withParentNode:(CCNode *)parentNode
{
    if (self = [super init]) {
        [parentNode addChild:self z:101];
        if (indentify == 1) {
            [self scheduleOnce:@selector(farmerWinAnimation) delay:0];
        } else {
            [self scheduleOnce:@selector(landlordWinAnimation) delay:0];
        }
    }
    
    return self;
}

//农民胜利动画 135X52
-(void) farmerWinAnimation:(BOOL) ifIwin
{
    if (ifIwin) {
        CCSprite *wordSprite = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] textureForKey:@"win_words.png"] rect:CGRectMake(0, 52, 135, 52)];
        [self addChild:wordSprite];
        
    } else {
        CCSprite *wordSprite = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] textureForKey:@"win_words.png"] rect:CGRectMake(0, 156, 135, 52)];
        [self addChild:wordSprite];
    }
}
//地主胜利动画
-(void) landlordWinAnimation:(BOOL) ifIwin
{
    if (ifIwin) {
        CCSprite *wordSprite = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] textureForKey:@"win_words.png"] rect:CGRectMake(0, 0, 135, 52)];
        [self addChild:wordSprite];
    } else {
        CCSprite *wordSprite = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] textureForKey:@"win_words.png"] rect:CGRectMake(0, 104, 135, 52)];
        [self addChild:wordSprite];
    }
     
}


@end
