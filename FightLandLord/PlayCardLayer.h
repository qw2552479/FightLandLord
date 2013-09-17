//
//  PlayCardLayer.h
//  3213
//
//  Created by aatc on 9/5/13.
//  Copyright 2013 nchu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameData.h"

@class GameLayer;
@interface PlayCardLayer : CCLayer
{
    CGSize winSize;
    CCSprite *timeSprite;
    CCLabelBMFont *timeLabel;
    //按钮精灵
    CCSprite *callLandlordSprite_normal, *callLandlordSprite_selected;//叫地主
    CCSprite *dontCallLandlordSprite_normal, *dontCallLandlordSprite_selected;//不叫
    CCSprite *robLandlordSprite_normal, *robLandlordSprite_selected;//抢地主
    CCSprite *dontRobLandlordSprite_normal, *dontRobLandlordSprite_selected;//不抢
    CCSprite *playCardsSprite_normal, *playCardsSprite_selected;//出牌
    CCSprite *dontPlayCardsSprite_normal, *dontPlayCardsSprite_selected;//不出
    CCSprite *remindSprite_normal, *remindSprite_selected;//提示
    CCSprite *reelectSprite_normal, *reelectSprite_selected;//重选
    CCSprite *startSprite_normal, *startSprite_selected;//开始
    //标签精灵
    BOOL isMoving;
    int whosTurn;
    int time;//每轮时间
    int robLandlordCount;//抢地主次数
    int callLandlordCount;//叫地主剩余次数
    int gameMultiple;//游戏倍数
    BOOL isCallLandlording;
    BOOL isRobLandlording;
    BOOL isPlayCarding;
    int whoIsLandlord;
}

@property (nonatomic, retain) GameLayer *gameLayer;

+(CCScene *) scene;
-(id) initWith:(GameLayer *)gameLayer_;

-(void) otherButtonBegan:(UITouch *)touch andTouchPoint:(CGPoint)touchLocation;
-(void) robotButtonBegan:(UITouch *)touch andTouchPoint:(CGPoint)touchLocation;
-(void) setButtonBegan:(UITouch *)touch andTouchPoint:(CGPoint)touchLocation;
-(void) backButtonBegan:(UITouch *)touch andTouchPoint:(CGPoint)touchLocation;

@end
