//
//  SettingLayer.m
//  3213
//
//  Created by aatc on 9/4/13.
//  Copyright 2013 nchu. All rights reserved.
//

#import "SettingLayer.h"

@implementation SettingLayer

+(CCScene *) scene
{
    CCScene *scene = [CCScene node];
    SettingLayer *settingLayer = [SettingLayer node];
    [scene addChild:settingLayer];
    return scene;
}

-(id)init
{
    if ( (self = [super init]) ) {
        CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
        CCSprite *bg = [CCSprite spriteWithFile:@"" rect:CGRectMake(0, 0, 20, 20)];
        [self addChild:bg z:0];
        
    }
    return self;
}

-(void)dealloc
{
    CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
    [super dealloc];
}


@end
