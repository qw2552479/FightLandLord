//
//  LocalPlayer.h
//  3213
//
//  Created by aatc on 9/5/13.
//  Copyright 2013 nchu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameData.h"
@interface Player : CCNode
{
    CGSize winSize;
    CCSprite *playerSprite;//玩家图像
    NSString *playerName;//玩家名字
    NSString *identity;//玩家身份，地主，农民
    CCSprite *call, *dontCall, *rob, *dontRob, *dontPlayCard;
    PockerGroupType leadPockerType;//将打出去的牌型
}

@property (nonatomic, copy) NSString *identity;
@property (nonatomic, retain) CCSprite *playerSprite;
@property (nonatomic, retain) NSMutableArray *playerCardsArray;//玩家的牌
@property (nonatomic, retain) NSMutableArray *lastCardsArray;//玩家选中的牌,
@property (nonatomic, retain) NSMutableArray *nextCardsArray;//玩家要打的牌,只存nsnumber
@property (nonatomic, assign) PockerGroupType leadPockerType;//牌型
@property (nonatomic, retain) NSString *playerInfo;//人物信息
@property (nonatomic, retain) CCSprite *call, *dontCall, *rob, *dontRob, *dontPlayCard;//叫不叫地主状态标签
@property (nonatomic, assign) BOOL refuseCallLandlord;//拒绝叫地主


+(id) playerWithParentNode:(CCNode *)parentNode andPlayerSpriteTexture:(CCTexture2D *)playerSpriteTexture;
-(id) initWithParentNode:(CCNode *)parentNode andPlayerSpriteTexture:(CCTexture2D *)playerSpriteTexture;

-(void) playSoundByCardType:(PockerGroupType)type;
-(BOOL) isGreaterThanLastCards:(NSMutableArray *)lastCards andLastCardsType:(PockerGroupType)type;
-(void) initPlayer;
//显示状态标签
-(void) showState:(Player_state)state;
//是否符合规则
-(BOOL) isRules;

@end
