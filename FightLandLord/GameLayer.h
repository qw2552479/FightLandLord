#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameData.h"
@class Player;
@interface GameLayer : CCLayer {
    CGSize winSize;
    Player *localPlayer;//自己
    Player *leftPlayer;//左边对手
    Player *rightPlayer;//右边对手
    NSMutableArray *cardFramesArray;//大卡片的frame
    NSMutableArray *cardFramesArray_small;//小卡片的frame
    NSMutableArray *threeCardsArray;
    NSMutableArray *lastCards;//当前场上最大的牌
    int lastCardsOwner;//当前场上牌的拥有者 1:自己 2:右选手 3:左选手
    PockerGroupType leadPockerType;//当前场上的牌的牌型
    int a[54];
    BOOL isGameBegin;//游戏是否开始
}

@property (nonatomic, retain) Player *localPlayer;
@property (nonatomic, retain) Player *leftPlayer;
@property (nonatomic, retain) Player *rightPlayer;
@property (nonatomic, retain) NSMutableArray *lastCards;
@property (nonatomic, assign) BOOL isGameBegin;
@property (nonatomic, readonly) int lastCardsOwner;

-(void) initGameLayer;
-(void) initCards;
-(void) sortCards;
-(void) startAnimation;
-(void) drawCards;
-(BOOL) playCards:(int)who;

@end
