//
//  MainGameScene.m
//  3213
//
//  Created by aatc on 9/5/13.
//  Copyright 2013 nchu. All rights reserved.
//
#import "MainGameScene.h"
#import "GameLayer.h"
#import "PlayCardLayer.h"

@implementation MainGameScene


-(id)init
{
    if (self = [super init]) {
        GameLayer *gameLayer = [GameLayer node];
        PlayCardLayer *playCardLayer = [[PlayCardLayer alloc] initWith:gameLayer];
        gameLayer.tag = GAME_LAYER;
        playCardLayer.tag = PLAYCARD_LAYER;
      //  playCardLayer.gameLayer = gameLayer;
        [self addChild:playCardLayer z:2];
        [self addChild:gameLayer z:1];
        //[playCardLayer release];
        
    }
    
    return self;
}

@end
