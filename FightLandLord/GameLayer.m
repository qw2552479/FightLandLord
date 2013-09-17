//
//  GameLayer.m
//  3213
//
//  Created by aatc on 9/5/13.
//  Copyright 2013 nchu. All rights reserved.

#import "GameLayer.h"
#import "HelloWorldLayer.h"
#import "Player.h"
#import "Card.h"
#import "SimpleAudioEngine.h"

@implementation GameLayer
@synthesize localPlayer, leftPlayer, rightPlayer, lastCards;
@synthesize isGameBegin;
@synthesize lastCardsOwner;
-(id)init
{
    if ((self = [super init])) {
        winSize = [[CCDirector sharedDirector] winSize];
        
        CCSprite *head_bg = [CCSprite spriteWithFile:@"ddz_game_menuback.png"];
        head_bg.position = ccp(winSize.width / 2, winSize.height - head_bg.contentSize.height / 2);
        [self addChild:head_bg z:1];
        //大扑克牌
        CCTexture2D *cardTexture = [[CCTextureCache sharedTextureCache] addImage:@"IOS扑克牌.png"];
        cardFramesArray = [[NSMutableArray alloc] initWithCapacity:56];
        CCSpriteFrame *cardFrame;
        for (int i = 0; i < 56 ; i++) {
            cardFrame = [CCSpriteFrame frameWithTexture:cardTexture rect:CGRectMake((i % 13) * CARD_WIDTH, (i / 13) * CARD_HEIGHT, CARD_WIDTH, CARD_HEIGHT)];
            [cardFramesArray addObject:cardFrame];
        }
        //小扑克牌
        CCTexture2D *cardTexture_small = [[CCTextureCache sharedTextureCache] addImage:@"IOS扑克牌小.png"];
        cardFramesArray_small = [[NSMutableArray alloc] initWithCapacity:56];
        CCSpriteFrame *cardFrame_small;
        for (int i = 0; i < 56 ; i++) {
            cardFrame_small = [CCSpriteFrame frameWithTexture:cardTexture_small rect:CGRectMake((i % 13) * CARD_WIDTH_SMALL, (i / 13) * CARD_HEIGHT_SMALL, CARD_WIDTH_SMALL, CARD_HEIGHT_SMALL)];
            [cardFramesArray_small addObject:cardFrame_small];
        }
        //背景图
        CCSprite *bg = [CCSprite spriteWithFile:@"ddz_welcome.png"];
        bg.position = ccp(winSize.width / 2, winSize.height / 2);
        [self addChild:bg z:0];
        //底部背景
        CCSprite *bottom_bg = [CCSprite spriteWithFile:@"tool.png"];
        bottom_bg.position = ccp(winSize.width / 2, bottom_bg.contentSize.height / 2);
        [self addChild:bottom_bg z:1];
        CCTexture2D *left_image_texture = [[CCTextureCache sharedTextureCache] addImage:@"left-image.png"];
        CCTexture2D *right_image_texture = [[CCTextureCache sharedTextureCache] addImage:@"right-image.png"];
        //地主纹理
        CCSpriteFrame *nomingFrame = [CCSpriteFrame frameWithTextureFilename:@"地主农民头像.png" rect:CGRectMake(0, 0, 44, 42)];
        CCSpriteFrame *dizhuFrame = [CCSpriteFrame frameWithTextureFilename:@"地主农民头像.png" rect:CGRectMake(44, 0, 44, 42)];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFrame:nomingFrame name:@"nomingFrame"];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFrame:dizhuFrame name:@"dizhuFrame"];
       // CCTexture2D *left_image_texture = [[CCTextureCache sharedTextureCache] addImage:@"left-image.png"];
        //数据初始化
        leadPockerType = NONE_CARDS;
        localPlayer = [Player playerWithParentNode:self andPlayerSpriteTexture:left_image_texture];
        leftPlayer = [Player playerWithParentNode:self andPlayerSpriteTexture:left_image_texture];
        rightPlayer = [Player playerWithParentNode:self andPlayerSpriteTexture:right_image_texture];
        lastCards = [[NSMutableArray alloc] init];
        threeCardsArray = [[NSMutableArray alloc] init];
        localPlayer.position = LOCALPLAYER_POSITION;
        leftPlayer.position = LEFTPLAYER_POSITION;
        rightPlayer.position = RIGHTPLAYER_POSITION;
        
        localPlayer.call.position = localPlayer.dontCall.position = localPlayer.rob.position = localPlayer.dontRob.position = localPlayer.dontPlayCard.position = ccp(localPlayer.position.x + 150, 50);
        leftPlayer.call.position = leftPlayer.dontCall.position = leftPlayer.rob.position = leftPlayer.dontRob.position = leftPlayer.dontPlayCard.position = ccp(100, 0);
        rightPlayer.call.position = rightPlayer.dontCall.position = rightPlayer.rob.position = rightPlayer.dontRob.position = rightPlayer.dontPlayCard.position = ccp(-100, 0);
        
        [self initCards];
        [self sortCards];        
        //开始打牌通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showThreeCardsArray) name:@"START_PLAYCARD" object:nil];
    }
    
    return self;
}

-(void) showThreeCardsArray
{
    //最后3张
    Card *card;
    for (int i = 0; i < 3; i++) {
        card = [threeCardsArray objectAtIndex:i];
        card.visible = YES;
        card.scale = 0.4;
        card.position = ccp((winSize.width) / 2 + CARD_OFFSET * (i - 1) * 2, winSize.height - TOP_HEIGHT / 2 + 2);
    }
}

//初始化游戏层
-(void) initGameLayer
{
    [localPlayer initPlayer];
    [leftPlayer initPlayer];
    [rightPlayer initPlayer];
    for (Card *card in threeCardsArray) {
        [card removeFromParentAndCleanup:YES];
    }
    lastCardsOwner = 0;//当前场上牌的拥有者 1:自己 2:右选手 3:左选手
    leadPockerType = NONE_CARDS;//当前场上的牌的牌型
    [lastCards removeAllObjects];
    isGameBegin = YES;
}

//出牌 1:自己出牌 2:右边玩家出牌 3:左边玩家出牌
-(BOOL) playCards:(int)who
{
    //1
    //打牌前将之前的移空
    [localPlayer.nextCardsArray removeAllObjects];
    NSMutableArray *cardTodelete = [NSMutableArray array];
    for (Card *card in localPlayer.playerCardsArray) {
        if (card.isChoosed == YES) {
            [cardTodelete addObject:card];
            [self.localPlayer.nextCardsArray addObject:[NSNumber numberWithInt:card.value]];
            [localPlayer.lastCardsArray addObject:[NSNumber numberWithInt:card.value]];
        }
    }
    if ([self.localPlayer isRules]) {
        if (lastCards.count == 0) {
            NSLog(@"上一轮没有牌");
            NSLog(@"出牌");
            //将牌移除处理
            [self.localPlayer playSoundByCardType:self.localPlayer.leadPockerType];//播放音效
            [self removeCards:who andCardsToDeleteArray:cardTodelete];
            [self.localPlayer.nextCardsArray removeAllObjects];
            leadPockerType = self.localPlayer.leadPockerType;
            lastCardsOwner = 1;
            return YES;
        } else {
            NSLog(@"与上一轮牌比较大小");
            if (lastCardsOwner == 1) {
                NSLog(@"上一轮是自己牌");
                NSLog(@"出牌");
                [self.localPlayer playSoundByCardType:self.localPlayer.leadPockerType];//播放音效
                [self removeCards:who andCardsToDeleteArray:cardTodelete];
                [self.localPlayer.nextCardsArray removeAllObjects];
                //赋予当前纸牌类型
                leadPockerType = self.localPlayer.leadPockerType;
                return YES;
            }
            if ([self.localPlayer isGreaterThanLastCards:lastCards andLastCardsType:leadPockerType]) {
                NSLog(@"比上一轮牌大");
                NSLog(@"出牌");
                [self.localPlayer playSoundByCardType:self.localPlayer.leadPockerType];//播放音效
                [self removeCards:who andCardsToDeleteArray:cardTodelete];
                [self.localPlayer.nextCardsArray removeAllObjects];
                //赋予当前纸牌类型
                leadPockerType = self.localPlayer.leadPockerType;
                lastCardsOwner = 1;
                return YES;
            } else {
                NSLog(@"比上一轮牌小");
                [localPlayer.nextCardsArray removeAllObjects];
                return NO;
            }
        }
    } else {
        //将未打出的牌置为原位
        NSLog(@"牌不符合规则，归位");
        for (Card *card in cardTodelete) {
            card.isChoosed = NO;
            card.position = ccp(card.position.x, BOTTOM_HEIGHT);
        }
        [cardTodelete removeAllObjects];
        //不符合规则动画
        [self cardsDidntFollowTheRuleAnimation];
        //将下一组牌清空
        [localPlayer.nextCardsArray removeAllObjects];
        return NO;
    }
    
}
//不符合规则动画
-(void) cardsDidntFollowTheRuleAnimation
{
    CCSprite *tips = [CCSprite spriteWithFile:@"game_tips_error.png"];
    tips.position = ccp(winSize.width / 2, winSize.height / 2 - 80);
    tips.visible = NO;
    [self addChild:tips z:100];
    CCShow *show = [CCShow action];
    CCFadeIn *fadeIn = [CCFadeIn actionWithDuration:0.75];
    CCDelayTime *delay = [CCDelayTime actionWithDuration:1.0];
    CCHide *hide = [CCHide action];
    CCCallBlock *block = [CCCallBlock actionWithBlock:^{
        [tips removeFromParent];
    }];
    CCSequence *s = [CCSequence actions:show, fadeIn, delay, hide, block, nil];
    [tips runAction:s];
}
//正确出牌后，处理牌组
-(void) removeCards:(int)who andCardsToDeleteArray:(NSMutableArray *)cardTodelete
{
    winSize = [[CCDirector sharedDirector] winSize];
    //将之前场上的牌清除
    for (Card *card in lastCards) {
        [card removeFromParentAndCleanup:YES];
    }
    [lastCards removeAllObjects];
    //将要删除的牌移到当前场上的牌
    for (Card *card in cardTodelete) {
        [localPlayer.playerCardsArray removeObject:card];
        [lastCards addObject:card];
    }
    [cardTodelete removeAllObjects];
    [self sortCards];
    [self drawCards];
    //将打出的牌改变位置
    for (int i = 0; i < lastCards.count; i++) {
        Card *card = [lastCards objectAtIndex:i];
        card.position = ccp((winSize.width - CARD_OFFSET * (lastCards.count - 1)) / 2 + CARD_OFFSET * i / 2, winSize.height / 2 - 20);
        card.zOrder = i + 1;
        card.scale = 0.5;
    }
}

-(void) drawCards
{
    winSize = [[CCDirector sharedDirector] winSize];
    Card *card;
    for (int i = 0; i < leftPlayer.playerCardsArray.count; i++) {
        card = [leftPlayer.playerCardsArray objectAtIndex:i];
        card.position = ccp(85 + CARD_WIDTH_SMALL * (i % 2), winSize.height - 70 - CARD_HEIGHT_SMALL * 2 / 3 * (i / 2));
        card.zOrder = i + 1;
    }
    
    for (int i = 0; i < rightPlayer.playerCardsArray.count; i++) {
        card = [rightPlayer.playerCardsArray objectAtIndex:i];
        card.position = ccp(385 + CARD_WIDTH_SMALL * (i % 2), winSize.height - 70 - CARD_HEIGHT_SMALL * 2 / 3 * (i / 2));
        card.zOrder = i + 1;
    }
    //自己卡牌位置ccp(35, 80)
    for (int i = 0; i < localPlayer.playerCardsArray.count; i++) {
        card = [localPlayer.playerCardsArray objectAtIndex:i];
        //卡片的位置
        card.position = ccp((winSize.width - CARD_OFFSET * (localPlayer.playerCardsArray.count - 1)) / 2 + CARD_OFFSET * i, BOTTOM_HEIGHT);
        card.zOrder = i + 1;
    }
}

-(void) startAnimation
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"GameStart.wav"];
    winSize = [[CCDirector sharedDirector] winSize];
    Card *card;
    for (int i = 0; i < leftPlayer.playerCardsArray.count; i++) {
        card = [leftPlayer.playerCardsArray objectAtIndex:i];
        card.position = ccp(85 + CARD_WIDTH_SMALL * (i % 2), winSize.height - 70 - CARD_HEIGHT_SMALL * 2 / 3 * (i / 2));
        card.visible = NO;
        card.zOrder = i + 1;
    }
    
    for (int i = 0; i < rightPlayer.playerCardsArray.count; i++) {
        card = [rightPlayer.playerCardsArray objectAtIndex:i];
        card.position = ccp(385 + CARD_WIDTH_SMALL * (i % 2), winSize.height - 70 - CARD_HEIGHT_SMALL * 2 / 3 * (i / 2));
        card.visible = NO;
        card.zOrder = i + 1;
    }
    //自己卡牌位置ccp(35, 80)
    //   CGPoint localPosition = LOCALPLAYER_POSITION;
    for (int i = 0; i < localPlayer.playerCardsArray.count; i++) {
        card = [localPlayer.playerCardsArray objectAtIndex:i];
        //卡片的位置
        card.position = ccp((winSize.width - CARD_OFFSET * (localPlayer.playerCardsArray.count - 1)) / 2 + CARD_OFFSET * i, BOTTOM_HEIGHT);
        card.visible = NO;
        card.zOrder = i + 1;
    }
    //    剩余3张牌位置
    for (int i = 0; i < lastCards.count; i++) {
        card = [lastCards objectAtIndex:i];
        card.position = ccp(winSize.width / 2 + CARD_WIDTH * (i - 1), winSize.height / 2 + card.contentSize.height / 2 + 10);
        card.visible = NO;
        card.zOrder = i + 1;
    }
    q = 0;
    x = 0;
    z = 0;
    [self drawLocalCardsAnimation];
    [self drawLeftCardsAnimation];
    [self drawRightCardsAnimation];
    
}

int q = 0;
-(void)drawLocalCardsAnimation
{
    if (q >+ localPlayer.playerCardsArray.count - 1) {
        isGameBegin = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CARDS_DEALS_OVER" object:nil];
        return;
    }
    Card *card = [localPlayer.playerCardsArray objectAtIndex:q];
    CCCallFunc *fun1 = [CCCallFunc actionWithTarget:self selector:@selector(drawLocalCardsAnimation)];
    CCSequence *s = [CCSequence actions:[CCHide action], [CCDelayTime actionWithDuration:0.2f], [CCShow action], fun1, nil];
    [card runAction:s];
    [[SimpleAudioEngine sharedEngine] playEffect:@"DISPATCH_CARD.wav"];
    q++;
}
int z;
-(void)drawRightCardsAnimation
{
    if (z >+ rightPlayer.playerCardsArray.count - 1) {
        return;
    }
    Card *card = [rightPlayer.playerCardsArray objectAtIndex:z];
    CCCallFunc *fun1 = [CCCallFunc actionWithTarget:self selector:@selector(drawRightCardsAnimation)];
    CCSequence *s = [CCSequence actions:[CCHide action], [CCDelayTime actionWithDuration:0.2f], [CCShow action], fun1, nil];
    [card runAction:s];
    z++;
}
int x;
-(void)drawLeftCardsAnimation
{
    if (x >+ leftPlayer.playerCardsArray.count - 1) {
        return;
    }
    Card *card = [leftPlayer.playerCardsArray objectAtIndex:x];
    CCCallFunc *fun1 = [CCCallFunc actionWithTarget:self selector:@selector(drawLeftCardsAnimation)];
    CCSequence *s = [CCSequence actions:[CCHide action], [CCDelayTime actionWithDuration:0.2f], [CCShow action], fun1, nil];
    [card runAction:s];
    x++;
}

-(void)initCards
{
    Card *card;
    for (int i = 0; i < 54 ; i++) {
        a[i] = i;
    }
    for (int i = 0; i < 54; i++) {
        int index = arc4random() % 54;
        int temp = a[i];
        a[i] = a[index];
        a[index] = temp;
    }
    //自己的牌
    for (int i = 0; i < 17; i++) {
        card = [Card spriteWithSpriteFrame:[cardFramesArray objectAtIndex:a[i]]];
        card.value = a[i];
        card.isChoosed = false;
        card.visible = NO;
        [localPlayer.playerCardsArray addObject:card];
        [self addChild:card z:1];
    }
    //左
    for (int i = 0; i < 17; i++) {
        card = [Card spriteWithSpriteFrame:[cardFramesArray_small objectAtIndex:54]];
        card.value = a[i+17];
        card.isChoosed = false;
        card.visible = NO;
        [leftPlayer.playerCardsArray addObject:card];
        [self addChild:card z:1];
    }
    //右
    for (int i = 0; i < 17; i++) {
        card = [Card spriteWithSpriteFrame:[cardFramesArray_small objectAtIndex:54]];
        card.value = a[i+34];
        card.isChoosed = false;
        card.visible = NO;
        [rightPlayer.playerCardsArray addObject:card];
        [self addChild:card z:1];
    }
    //最后3张
    for (int i = 0; i < 3; i++) {
        card = [Card spriteWithSpriteFrame:[cardFramesArray objectAtIndex:a[i+51]]];
        card.value = a[i+51];
        card.isChoosed = false;
        card.visible = NO;
        [threeCardsArray addObject:card];
        [self addChild:card z:2];
    }
}

-(void) sortCards
{
  //  localPlayerCardArray = localPlayer.playerCardsArray;
    [localPlayer.playerCardsArray sortUsingFunction:intSort context:nil];
    [leftPlayer.playerCardsArray sortUsingFunction:intSort context:nil];
    [rightPlayer.playerCardsArray sortUsingFunction:intSort context:nil];
    [threeCardsArray sortUsingFunction:intSort context:nil];
}

NSInteger intSort(id num1, id num2, void *context)
{
    Card *card1 = (Card *)num1;
    Card *card2 = (Card *)num2;
    int v1 = [card1 value] % 13;
    int v2 = [card2 value] % 13;
    switch ([card1 value]) {
        case 0://方片A
            v1 = 1001;
            break;
        case 1://方片2
            v1 = 2001;
            break;
        case 13://梅花A
            v1 = 1002;
            break;
        case 14://梅花2
            v1 = 2002;
            break;
        case 26://红桃A
            v1 = 1003;
            break;
        case 27://红桃2
            v1 = 2003;
            break;
        case 39://黑桃A
            v1 = 1004;
            break;
        case 40://黑桃2
            v1 = 2004;
            break;
        case 52://小王
            v1 = 3001;
            break;
        case 53://大王
            v1 = 3002;
            break;
        default:
            break;
    }
    switch ([card2 value]) {
        case 0://方片A
            v2 = 1001;
            break;
        case 1://方片2
            v2 = 2001;
            break;
        case 13://梅花A
            v2 = 1002;
            break;
        case 14://梅花2
            v2 = 2002;
            break;
        case 26://红桃A
            v2 = 1003;
            break;
        case 27://红桃2
            v2 = 2003;
            break;
        case 39://黑桃A
            v2 = 1004;
            break;
        case 40://黑桃2
            v2 = 2004;
            break;
        case 52://小王
            v2 = 3001;
            break;
        case 53://大王
            v2 = 3002;
            break;
        default:
            break;
    }
    
    if (v1 < v2)
        return NSOrderedDescending;
    else if (v1 > v2)
        return NSOrderedAscending;
    else
        return NSOrderedSame;
}

-(void)dealloc
{
    [[CCTextureCache sharedTextureCache] removeUnusedTextures];
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeUnusedSpriteFrames];
    self.localPlayer = nil;
    self.leftPlayer = nil;
    self.rightPlayer = nil;
    self.lastCards = nil;
    [threeCardsArray release];
    threeCardsArray = nil;
    [cardFramesArray release];
    cardFramesArray = nil;
    [cardFramesArray_small release];
    cardFramesArray_small = nil;
    
    [super dealloc];
}

@end
