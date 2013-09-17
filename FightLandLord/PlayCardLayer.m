//
//  PlayCardLayer.m
//  3213
//
//  Created by aatc on 9/5/13.
//  Copyright 2013 nchu. All rights reserved.
//

#import "PlayCardLayer.h"
#import "HelloWorldLayer.h"
#import "GameLayer.h"
#import "Player.h"
#import "Card.h"
#import "ChooseSchemaLayer.h"
#import "SimpleAudioEngine.h"
#import "GameWinLayer.h"
@implementation PlayCardLayer

+(CCScene *) scene
{
    CCScene *scene = [CCScene node];
    PlayCardLayer *layer = [PlayCardLayer node];
    [scene addChild:layer];
    return scene;
}

-(void)onEnter
{
    [super onEnter];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"叫地主.wav"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"抢地主0.wav"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"抢地主1.wav"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"抢地主2.wav"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"不叫.wav"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"不抢.wav"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"明牌.wav"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"zhadan.wav"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"wangzha.wav"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"sidailiangdui.wav"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"sidaier.wav"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"shunzi.wav"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"sange.wav"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"sandaiyidui.wav"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"sandaiyi.wav"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"liandui.wav"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"jiabei.wav"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"feiji.wav"];
    for (int i = 1; i <= 15; i++) {
        [[SimpleAudioEngine sharedEngine] preloadEffect:[NSString stringWithFormat:@"%d.wav", i]];
    }
    [[CCTextureCache sharedTextureCache] addImage:@"win_words.png"];
}

-(id)initWith:(GameLayer *)gameLayer_
{
    //NSLog(@"%@",self.gameLayer);
    if ((self = [super init])) {
        CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
        //游戏信息初始化
        self.gameLayer = gameLayer_;
        robLandlordCount = 4;//如果是3或者2,继续叫地主，如果是1，直接进入打牌阶段，如果是0 重新开始
        callLandlordCount = 3;//为0重新开始游戏
        gameMultiple = 1;//游戏倍数
        isCallLandlording = NO;
        isRobLandlording = NO;
        isPlayCarding = NO;
        winSize = [[CCDirector sharedDirector] winSize];   
        //顶部背景
        CCSprite *head_bg = [CCSprite spriteWithFile:@"ddz_game_menuback.png"];
        head_bg.visible = NO;
        head_bg.position = ccp(winSize.width / 2, winSize.height - head_bg.contentSize.height / 2);
        [self addChild:head_bg z:1];
        
        CCLabelTTF *lowestMark = [CCLabelTTF labelWithString:@"底分1" fontName:@"" fontSize:14];
        lowestMark.position = ccp(winSize.width / 2, winSize.height - lowestMark.contentSize.height / 2);
        [self addChild:lowestMark];
        //back button
        for (int i = 0; i < 2; i++) {
            CCSpriteFrame *frame = [CCSpriteFrame frameWithTextureFilename:@"TOP按钮离开.png" rect:CGRectMake(i * 33, 0, 33, 33)];
            [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFrame:frame name:[NSString stringWithFormat:@"back_%d",i]];
        }
        CCSprite *backSprite_normal = [CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"back_0"]];
        CCSprite *backSprite_selected = [CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"back_1"]];
       // CCSprite *backSprite_disabled = [CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"back_2"]];
       // [self addChild:backSprite_disabled z:3];
        [self addChild:backSprite_normal z:3];
        [self addChild:backSprite_selected z:3];
        backSprite_normal.tag = BACK_BUTTON_TAG;
        backSprite_selected.tag = BACK_BUTTON_TAG + 1;
        backSprite_selected.visible = NO;
        backSprite_normal.position = backSprite_selected.position = ccp(380, head_bg.position.y);
        //托管按钮
        for (int i = 0; i < 2; i++) {
            CCSpriteFrame *frame = [CCSpriteFrame frameWithTextureFilename:@"TOP按钮托管.png" rect:CGRectMake(i * 33, 0, 33, 33)];
            [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFrame:frame name:[NSString stringWithFormat:@"robot_%d",i]];
        }
        CCSprite *robotSprite_normal = [CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"robot_0"]];
        CCSprite *robotSprite_selected = [CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"robot_1"]];

        [self addChild:robotSprite_normal z:3];
        [self addChild:robotSprite_selected z:3];
        robotSprite_normal.tag = ROBOT_BUTTON_TAG;
        robotSprite_selected.tag = ROBOT_BUTTON_TAG + 1;
        robotSprite_selected.visible = NO;
        robotSprite_normal.position = robotSprite_selected.position = ccp(100, head_bg.position.y);
        //other button
        for (int i = 0; i < 2; i++) {
            CCSpriteFrame *frame = [CCSpriteFrame frameWithTextureFilename:@"TOP按钮里换桌.png" rect:CGRectMake(i * 33, 0, 33, 33)];
            [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFrame:frame name:[NSString stringWithFormat:@"other_%d",i]];
        }
        CCSprite *otherSprite_normal = [CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"other_0"]];
        CCSprite *otherSprite_selected = [CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"other_1"]];
        
        [self addChild:otherSprite_normal z:3];
        [self addChild:otherSprite_selected z:3];
        otherSprite_normal.tag = OTHER_BUTTON_TAG;
        otherSprite_selected.tag = OTHER_BUTTON_TAG + 1;
        otherSprite_selected.visible = NO;
        otherSprite_normal.position = otherSprite_selected.position = ccp(340, head_bg.position.y);
        //set button
        for (int i = 0; i < 2; i++) {
            CCSpriteFrame *frame = [CCSpriteFrame frameWithTextureFilename:@"TOP按钮设置.png" rect:CGRectMake(i * 33, 0, 33, 33)];
            [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFrame:frame name:[NSString stringWithFormat:@"set_%d",i]];
        }
        CCSprite *setSprite_normal = [CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"set_0"]];
        CCSprite *setSprite_selected = [CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"set_1"]];
        
        [self addChild:setSprite_normal z:3];
        [self addChild:setSprite_selected z:3];
        setSprite_normal.tag = SET_BUTTON_TAG;
        setSprite_selected.tag = SET_BUTTON_TAG + 1;
        setSprite_selected.visible = NO;
        setSprite_normal.position = setSprite_selected.position = ccp(140, head_bg.position.y);
        //开始菜单
        //叫地主菜单(叫地主，不叫)
        for (int i = 0; i < 2; i++) {
            CCSpriteFrame *frame = [CCSpriteFrame frameWithTextureFilename:@"Btn_叫地主.png" rect:CGRectMake(i * 70, 0, 70, 35)];
            [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFrame:frame name:[NSString stringWithFormat:@"callLandlord_%d",i]];
        }
        callLandlordSprite_normal = [CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"callLandlord_0"]];
        callLandlordSprite_selected = [CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"callLandlord_1"]];
        [self addChild:callLandlordSprite_normal z:3];
        [self addChild:callLandlordSprite_selected z:3];
        callLandlordSprite_selected.visible = NO;
        callLandlordSprite_normal.visible = NO;
      //  callLandlordSprite_normal.position = callLandlordSprite_selected.position = ccp(140, winSize.height / 2 - 20);
        
        for (int i = 0; i < 2; i++) {
            CCSpriteFrame *frame = [CCSpriteFrame frameWithTextureFilename:@"Btn_不叫.png" rect:CGRectMake(i * 70, 0, 70, 35)];
            [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFrame:frame name:[NSString stringWithFormat:@"dontCallLandlord_%d",i]];
        }
        dontCallLandlordSprite_normal = [CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"dontCallLandlord_0"]];
        dontCallLandlordSprite_selected = [CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"dontCallLandlord_1"]];
        [self addChild:dontCallLandlordSprite_normal z:3];
        [self addChild:dontCallLandlordSprite_selected z:3];
        dontCallLandlordSprite_selected.visible = NO;
        dontCallLandlordSprite_normal.visible = NO;
        //抢地主 (抢地主不抢)
        for (int i = 0; i < 2; i++) {
            CCSpriteFrame *frame = [CCSpriteFrame frameWithTextureFilename:@"Btn_抢地主.png" rect:CGRectMake(i * 70, 0, 70, 35)];
            [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFrame:frame name:[NSString stringWithFormat:@"robLandlord_%d",i]];
        }
        robLandlordSprite_normal = [CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"robLandlord_0"]];
        robLandlordSprite_selected = [CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"robLandlord_1"]];
        [self addChild:robLandlordSprite_normal z:3];
        [self addChild:robLandlordSprite_selected z:3];
        robLandlordSprite_normal.visible = NO;
        robLandlordSprite_selected.visible = NO;
   
        for (int i = 0; i < 2; i++) {
            CCSpriteFrame *frame = [CCSpriteFrame frameWithTextureFilename:@"Btn_不抢.png" rect:CGRectMake(i * 70, 0, 70, 35)];
            [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFrame:frame name:[NSString stringWithFormat:@"dontRobLandlord_%d",i]];
        }
        dontRobLandlordSprite_normal = [CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"dontRobLandlord_0"]];
        dontRobLandlordSprite_selected = [CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"dontRobLandlord_1"]];
        [self addChild:dontRobLandlordSprite_normal z:3];
        [self addChild:dontRobLandlordSprite_selected z:3];
        dontRobLandlordSprite_normal.visible = NO;
        dontRobLandlordSprite_selected.visible = NO;
//        //出牌菜单(出牌，提示，重选，不出)
        for (int i = 0; i < 2; i++) {
            CCSpriteFrame *frame = [CCSpriteFrame frameWithTextureFilename:@"1game_bt_outcard3.png" rect:CGRectMake(i * 69, 0, 69, 34)];
            [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFrame:frame name:[NSString stringWithFormat:@"playCard_%d",i]];
        }
        playCardsSprite_normal = [CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"playCard_0"]];
        playCardsSprite_selected = [CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"playCard_1"]];
        
        [self addChild:playCardsSprite_normal z:3];
        [self addChild:playCardsSprite_selected z:3];
        playCardsSprite_selected.visible = NO;
        playCardsSprite_normal.visible = NO;
        
        for (int i = 0; i < 2; i++) {
            CCSpriteFrame *frame = [CCSpriteFrame frameWithTextureFilename:@"1game_bt_outcard0.png" rect:CGRectMake(i * 69, 0, 69, 34)];
            [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFrame:frame name:[NSString stringWithFormat:@"dontPlayCard_%d",i]];
        }
        dontPlayCardsSprite_normal = [CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"dontPlayCard_0"]];
        dontPlayCardsSprite_selected = [CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"dontPlayCard_1"]];
        
        [self addChild:dontPlayCardsSprite_normal z:3];
        [self addChild:dontPlayCardsSprite_selected z:3];
        dontPlayCardsSprite_normal.visible = NO;
        dontPlayCardsSprite_selected.visible = NO;
        //开始按钮
        for (int i = 0; i < 2; i++) {
            CCSpriteFrame *frame = [CCSpriteFrame frameWithTextureFilename:@"IOSBtn_开始.png" rect:CGRectMake(i * 90, 0, 90, 51)];
            [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFrame:frame name:[NSString stringWithFormat:@"IOSBtn_开始_%d",i]];
        }
        startSprite_normal = [CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"IOSBtn_开始_0"]];
        startSprite_selected = [CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"IOSBtn_开始_1"]];
        
        [self addChild:startSprite_normal z:3];
        [self addChild:startSprite_selected z:3];
        startSprite_normal.visible = YES;
        startSprite_selected.visible = NO;
        startSprite_normal.position = startSprite_selected.position = ccp(winSize.width / 2, winSize.height / 2);
//        CCMenu *playCardMenu = [CCMenu menuWithItems: nil];
        self.touchEnabled = YES;
        //计时器
        timeSprite = [CCSprite spriteWithFile:@"计时器.png"];
        timeSprite.visible = NO;
        [self addChild:timeSprite z:4];
        timeLabel = [CCLabelBMFont labelWithString:@"20" fntFile:@"bitmapfont.fnt"];
        timeLabel.visible =NO;
        timeLabel.scale = 0.3;
        [self addChild:timeLabel z:4];
        
        [self schedule:@selector(isWin:) interval:0.1];
        //发牌结束通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(randWhoFirstRobLandlord) name:@"CARDS_DEALS_OVER" object:nil];
    }
    return self;
}

-(void) isWin:(ccTime)delta
{
    if (!isPlayCarding) {
        return;
    }
    if (self.gameLayer.localPlayer.playerCardsArray.count <= 0) {
        if (whoIsLandlord == 1) {
            
        } else {
            
        }
    } else if (self.gameLayer.leftPlayer.playerCardsArray.count <= 0) {
        if (whoIsLandlord == 2) {
            
        } else {
            
        }
    } else if (self.gameLayer.rightPlayer.playerCardsArray.count <= 0) {
        if (whoIsLandlord == 3) {
            
        } else {
            
        }
    }
}
-(void) initPlayCardLayer
{
    robLandlordCount = 4;//如果是3或者2,继续叫地主，如果是1，直接进入打牌阶段，如果是0 重新开始
    callLandlordCount = 3;
    gameMultiple = 1;
    isCallLandlording = NO;
    isRobLandlording = NO;
    isPlayCarding = NO;
    whosTurn = 0;
    whoIsLandlord = 0;
    timeLabel.visible = NO;
    timeSprite.visible = NO;
}
//重选开始游戏
-(void) reStartGame
{
    [self unscheduleAllSelectors];
    [self initPlayCardLayer];
    [self.gameLayer initGameLayer];
    [self.gameLayer initCards];
    [self.gameLayer sortCards];
    [self.gameLayer startAnimation];
}

#pragma mark - game control
-(void) randWhoFirstRobLandlord
{
    isCallLandlording = YES;
    whosTurn = arc4random() % 3 + 1;
    [self showCallLandlordButton];
    [self startTime:5];
    [self schedule:@selector(updateTimeLabelBY20Seconds:) interval:1.0f];
}
//ccp((winSize.width - CARD_OFFSET * (localPlayer.lastCardsArray.count - 1)) / 2 + CARD_OFFSET * i, winSize.height / 2 - 20);
-(void) startTime:(int)timeMax
{
    time = timeMax;
    [timeLabel setString:[NSString stringWithFormat:@"%i",time]];
    timeSprite.visible = YES;
    timeLabel.visible = YES;
    switch (whosTurn) {
        case 1://自己            
            timeSprite.position = ccp(winSize.width / 2, winSize.height / 2);
            [self.gameLayer.localPlayer showState:NORMAL_STATE];
            break;
        case 2://右边
            timeSprite.position = ccp(winSize.width / 3 * 2, winSize.height / 3 * 2);
            [self.gameLayer.rightPlayer showState:NORMAL_STATE];
            break;
        case 3://左边
            timeSprite.position = ccp(winSize.width / 3, winSize.height / 3 * 2);
            [self.gameLayer.leftPlayer showState:NORMAL_STATE];
            break;
        default:
            CCLOG(@"startTime: whosTurn should have value between 1-3");
            break;
    }
    timeLabel.position = timeSprite.position;
}
-(void) showCallLandlordButton//显示叫地主按钮320
{
    if (whosTurn == 1 && isCallLandlording) {
        callLandlordSprite_selected.position = callLandlordSprite_normal.position = ccp(185, winSize.height / 3 + 15);
        callLandlordSprite_normal.visible = YES;
        dontCallLandlordSprite_selected.position = dontCallLandlordSprite_normal.position = ccp(295, winSize.height / 3 + 15);
        dontCallLandlordSprite_normal.visible = YES;
    } else {
        callLandlordSprite_selected.position = callLandlordSprite_normal.position = ccp(-180, -winSize.height / 3 + 15);
        callLandlordSprite_normal.visible = NO;
        dontCallLandlordSprite_selected.position = dontCallLandlordSprite_normal.position = ccp(-290, winSize.height / 3 + 15);
        dontCallLandlordSprite_normal.visible = NO;
    }
}
-(void) showRobLandlordButton//显示抢地主按钮
{
    if (whosTurn == 1 && isRobLandlording) {
        robLandlordSprite_selected.position = robLandlordSprite_normal.position = ccp(185, winSize.height / 3 + 15);
        robLandlordSprite_normal.visible = YES;
        dontRobLandlordSprite_selected.position = dontRobLandlordSprite_normal.position = ccp(295, winSize.height / 3 + 15);
        dontRobLandlordSprite_normal.visible = YES;
    } else {
        robLandlordSprite_selected.position = robLandlordSprite_normal.position = ccp(-180, -winSize.height / 3 + 15);
        robLandlordSprite_normal.visible = NO;
        dontRobLandlordSprite_selected.position = dontRobLandlordSprite_normal.position = ccp(-295, -winSize.height / 3 + 15);
        dontRobLandlordSprite_normal.visible = NO;
    }
}

-(void) showPlayCardsButton//显示打牌按钮,出牌，不出，提示，重选
{
    if (whosTurn == 1 && isPlayCarding) {
        playCardsSprite_normal.position = playCardsSprite_selected.position = ccp(185, winSize.height / 3 + 30);
        playCardsSprite_normal.visible = YES;
        dontPlayCardsSprite_normal.position = dontPlayCardsSprite_selected.position = ccp(295, winSize.height / 3 + 30);
        dontPlayCardsSprite_normal.visible = YES;
    } else {
        playCardsSprite_normal.position = playCardsSprite_normal.position = ccp(-winSize.width * 2, -winSize.height * 2);
        playCardsSprite_normal.visible = playCardsSprite_normal.visible = NO;
        dontPlayCardsSprite_normal.position = dontPlayCardsSprite_selected.position = ccp(-winSize.width * 2, -winSize.height * 2);
        dontPlayCardsSprite_normal.visible = dontPlayCardsSprite_selected.visible = NO;
    }
}
//抢地主或者叫地主是20秒
-(void) updateTimeLabelBY20Seconds:(ccTime)delta
{
    if (isCallLandlording) {
        [self showCallLandlordButton];
        time -= (int)delta;
        [timeLabel setString:[NSString stringWithFormat:@"%i",time]];
        if (whosTurn != 1) {
            int rand = arc4random() % 5;
            if (rand == 1) {
                //[self callLandlord:YES];
                return;
            }
        }
        if (time <= 0) {
            [self callLandlord:NO];
        }
        return;
    }
    if (isRobLandlording) {
        switch (whosTurn) {
            case 1:
                if (self.gameLayer.localPlayer.refuseCallLandlord == YES) {
                    [self robLandlord:NO];
                }
                break;
            case 2:
                if (self.gameLayer.rightPlayer.refuseCallLandlord == YES) {
                    [self robLandlord:NO];
                }
                break;
            case 3:
                if (self.gameLayer.leftPlayer.refuseCallLandlord == YES) {
                    [self robLandlord:NO];
                }
                break;
            default:
                break;
        }
        time -= (int)delta;
        [timeLabel setString:[NSString stringWithFormat:@"%i",time]];
        [self showRobLandlordButton];
        if (whosTurn != 1) {
            int rand = arc4random() % 5 ;
            if (rand == 1) {
                [self robLandlord:YES];
                return;
            }
        }
        if (time <= 0) {
            [self robLandlord:NO];
            return;
        }
    }
}
//出牌30秒
-(void) updateTimeLabelBY30Seconds:(ccTime)delta
{
    [self showPlayCardsButton];
    time -= (int)delta;
    [timeLabel setString:[NSString stringWithFormat:@"%i",time]];
    if (time <= 0) {
        [self startTime:PLAYCARDS_LANDLORD_TIME];
        [self playCard:NO];
    }
}
#pragma mark - touchDispatcher
-(void) registerWithTouchDispatcher
{
	[[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:INT_MIN+1 swallowsTouches:YES];
}

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    if (CGRectContainsPoint(startSprite_normal.boundingBox, touchLocation)) {//开始
        startSprite_normal.visible = NO;
        startSprite_selected.visible = NO;
        startSprite_selected.position = startSprite_normal.position = ccp(-winSize.width, -winSize.height);
        [self.gameLayer startAnimation];
    }
    if (!self.gameLayer.isGameBegin) {
        return NO;
    }
    
    [self callLandlordButtonBegan:touch andTouchPoint:touchLocation];//叫地主
    [self robLandlordButtonBegan:touch andTouchPoint:touchLocation];//抢地主
    [self setButtonBegan:touch andTouchPoint:touchLocation];
    [self robotButtonBegan:touch andTouchPoint:touchLocation];
    [self otherButtonBegan:touch andTouchPoint:touchLocation];
    [self backButtonBegan:touch andTouchPoint:touchLocation];
    [self playCardBegan:touch andTouchPoint:touchLocation];
    
    NSLog(@"touchLoaction : %f, %f", touchLocation.x, touchLocation.y);

    for (Card *card in self.gameLayer.localPlayer.playerCardsArray) {
        CGRect rect;
        if ([card isEqual:[self.gameLayer.localPlayer.playerCardsArray lastObject]]) {
            rect = card.boundingBox;
        } else {
            rect = CGRectMake(card.boundingBox.origin.x, card.boundingBox.origin.y, CARD_OFFSET, card.boundingBox.size.height);
        }
        if (CGRectContainsPoint(rect, touchLocation)) {
            if (card.isChoosed == NO) {
                card.position = ccp(card.position.x, card.position.y + card.contentSize.height / 5);
                card.isChoosed = YES;
            } else {
                card.position = ccp(card.position.x, card.position.y - card.contentSize.height / 5);
                card.isChoosed = NO;
            }
            
        }
    }
    return YES;
}

-(void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
//    CGPoint touchLoaction = [self convertTouchToNodeSpace:touch];
//    NSLog(@"touchLoaction : %f, %f", touchLoaction.x, touchLoaction.y);
//    for (Card *card in self.gameLayer.localPlayer.playerCardsArray) {
//        CGRect rect;
//        if ([card isEqual:[self.gameLayer.localPlayer.playerCardsArray lastObject]]) {
//            rect = card.boundingBox;
//        } else {
//            rect = CGRectMake(card.boundingBox.origin.x, card.boundingBox.origin.y, CARD_OFFSET, card.boundingBox.size.height);
//        }
//        if (CGRectContainsPoint(rect, touchLoaction)) {
//            if (card.isChoosed == NO) {
//                card.position = ccp(card.position.x, card.position.y + card.contentSize.height / 5);
//                card.isChoosed = YES;
//            } else {
//                card.position = ccp(card.position.x, card.position.y - card.contentSize.height / 5);
//                card.isChoosed = NO;
//            }
//        }
//    }
}

-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    [self buttonEnded:touch andTouchPoint:touchLocation];
}
//抢地主/不抢
-(void) robLandlordButtonBegan:(UITouch *)touch andTouchPoint:(CGPoint)touchLocation
{
    //抢地主了
    if (CGRectContainsPoint(robLandlordSprite_normal.boundingBox, touchLocation)) {
        [self robLandlord:YES];
    } else if (CGRectContainsPoint(dontRobLandlordSprite_normal.boundingBox, touchLocation)) {
        [self robLandlord:NO];
    }
}
-(void) robLandlord:(BOOL)yesOrNo
{
    robLandlordCount--;//抢地主次数减一，开始有4次，每次不叫，不抢，抢，叫都减一
    //抢地主了
    if (yesOrNo) {
        switch (gameMultiple) {
            case 1:
                [[SimpleAudioEngine sharedEngine] playEffect:@"抢地主0.wav"];
                break;
            case 2:
                [[SimpleAudioEngine sharedEngine] playEffect:@"抢地主1.wav"];
                break;
            case 4:
                [[SimpleAudioEngine sharedEngine] playEffect:@"抢地主2.wav"];
                break;
                
            default:
                break;
        }
        gameMultiple *= 2;//倍数x2
        whoIsLandlord = whosTurn;//当前轮次人为暂时地主
        robLandlordSprite_normal.visible = NO;
        robLandlordSprite_selected.visible = YES;
        if (robLandlordCount <= 0 && !isPlayCarding) {//抢地主次数为0,直接进入打牌阶段
            [self startPlayCard];
            return;
        }
        switch (whosTurn) {
            case 1:
                [self.gameLayer.localPlayer showState:ROB];
                break;
            case 2:
                [self.gameLayer.rightPlayer showState:ROB];
                break;
            case 3:
                [self.gameLayer.leftPlayer showState:ROB];
                break;
            default:
                break;
        }
        whosTurn = whosTurn % 3 + 1;//轮到下一个人
        [self showRobLandlordButton];
        [self startTime:ROB_LANDLORD_TIME];
    } else if (!yesOrNo) {
        [[SimpleAudioEngine sharedEngine] playEffect:@"不抢.wav"];
        dontCallLandlordSprite_normal.visible = NO;
        dontCallLandlordSprite_selected.visible = YES;
        switch (whosTurn) {
            case 1:
                [self.gameLayer.localPlayer showState:DONT_ROB];
                break;
            case 2:
                [self.gameLayer.rightPlayer showState:DONT_ROB];
                break;
            case 3:
                [self.gameLayer.leftPlayer showState:DONT_ROB];
                break;
            default:
                break;
        }
        if (robLandlordCount <= 0 && !isPlayCarding) {//抢地主次数为0,直接进入打牌阶段
            [self startPlayCard];
            return;
        }
        whosTurn = whosTurn % 3 + 1;
        [self showRobLandlordButton];
        [self startTime:ROB_LANDLORD_TIME];
        return;
    }
}
//开始打牌
-(void) startPlayCard
{
    [self showCallLandlordButton];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"START_PLAYCARD" object:nil];
    isCallLandlording = NO;
    isRobLandlording = NO;
    isPlayCarding = YES;
    switch (whoIsLandlord) {
        case 1:
            [self.gameLayer.localPlayer.playerSprite setTexture:[[CCTextureCache sharedTextureCache] addImage:@"地主头像.png"]];
            break;
        case 2:
            [self.gameLayer.rightPlayer.playerSprite setTexture:[[CCTextureCache sharedTextureCache] addImage:@"地主头像.png"]];
            break;
        case 3:
            [self.gameLayer.leftPlayer.playerSprite setTexture:[[CCTextureCache sharedTextureCache] addImage:@"地主头像.png"]];
            break;
        default:
            CCLOG(@"isRobLandlording : error");
            break;
    }
    [self.gameLayer.localPlayer showState:NORMAL_STATE];
    [self.gameLayer.rightPlayer showState:NORMAL_STATE];
    [self.gameLayer.leftPlayer showState:NORMAL_STATE];
    whosTurn = whoIsLandlord;
    [self startTime:PLAYCARDS_LANDLORD_TIME];
    [self unschedule:@selector(updateTimeLabelBY20Seconds:)];
    [self schedule:@selector(updateTimeLabelBY30Seconds:) interval:1.0f];
}
//叫地主/不叫
-(void) callLandlordButtonBegan:(UITouch *)touch andTouchPoint:(CGPoint)touchLocation
{
    //叫地主了
    if (CGRectContainsPoint(callLandlordSprite_normal.boundingBox, touchLocation)) {
        [self callLandlord:YES];
    } else if (CGRectContainsPoint(dontCallLandlordSprite_normal.boundingBox, touchLocation)) {
        [self callLandlord:NO];
    }
}
-(void) callLandlord:(BOOL)yesOrNo
{
    robLandlordCount--;//抢地主次数减一，开始有4次，每次不叫，不抢，抢，叫都减一
    //叫地主了
    if (yesOrNo) {
        [[SimpleAudioEngine sharedEngine] playEffect:@"叫地主.wav"];
        whoIsLandlord = whosTurn;
        callLandlordSprite_normal.visible = NO;
        callLandlordSprite_selected.visible = YES;
        isCallLandlording = NO;
        isRobLandlording = YES;//进入抢地主阶段
        if (callLandlordCount == 1 && !isPlayCarding) {//进入打牌阶段
            [self startPlayCard];
            return;
        }
        switch (whosTurn) {
            case 1:
                [self.gameLayer.localPlayer showState:CALL];
                break;
            case 2:
                [self.gameLayer.rightPlayer showState:CALL];
                break;
            case 3:
                [self.gameLayer.leftPlayer showState:CALL];
                break;
                
            default:
                break;
        }
        whosTurn = whosTurn % 3 + 1;//轮到下一个人
        [self showCallLandlordButton];
        [self startTime:CALL_LANDLORD_TIME];
    } else if (!yesOrNo) {
        [[SimpleAudioEngine sharedEngine] playEffect:@"不叫.wav"];
        dontCallLandlordSprite_normal.visible = NO;
        dontCallLandlordSprite_selected.visible = YES;
        switch (whosTurn) {
            case 1:
                [self.gameLayer.localPlayer showState:DONT_CALL];
                self.gameLayer.localPlayer.refuseCallLandlord = YES;
                break;
            case 2:
                [self.gameLayer.rightPlayer showState:DONT_CALL];
                self.gameLayer.rightPlayer.refuseCallLandlord = YES;
                break;
            case 3:
                [self.gameLayer.leftPlayer showState:DONT_CALL];
                self.gameLayer.leftPlayer.refuseCallLandlord = YES;
                break;
            default:
                break;
        }
        whosTurn = whosTurn % 3 + 1;
        [self showCallLandlordButton];
        [self startTime:CALL_LANDLORD_TIME];
        callLandlordCount--;//叫地主机会减一，到0说明没人叫地主.
        if (callLandlordCount == 0) {//重新开始
            NSLog(@"重新开始");
            [self reStartGame];
        }
    }
}
//出牌
-(void) playCardBegan:(UITouch *)touch andTouchPoint:(CGPoint)touchLocation
{
    if (CGRectContainsPoint(playCardsSprite_normal.boundingBox, touchLocation)) {//出牌
        [self playCard:YES];
    } else if (CGRectContainsPoint(dontPlayCardsSprite_normal.boundingBox, touchLocation)) {//不出
        [self playCard:NO];
    }
}
-(void) playCard:(BOOL)yesOrNo
{
    if (!isPlayCarding) {
        return;
    }
    if (yesOrNo) {
        //出牌成功
        if ([self.gameLayer playCards:whosTurn]) {
            whosTurn = whosTurn % 3 + 1;
            [self showPlayCardsButton];
            [self startTime:PLAYCARDS_LANDLORD_TIME];
        }
    } else {
        whosTurn = whosTurn % 3 + 1;
      //  [self.gameLayer.lastCards removeAllObjects];
        [self showPlayCardsButton];
        [self startTime:PLAYCARDS_LANDLORD_TIME];
    }
    //如果当前最大牌是自己，则移除当前最大牌
    if (self.gameLayer.lastCardsOwner == whosTurn) {
        for (Card *card in self.gameLayer.lastCards) {
            [self.gameLayer removeChild:card cleanup:YES];
        }
        [self.gameLayer.lastCards removeAllObjects];
    }
}
//其他按钮
-(void)otherButtonBegan:(UITouch *)touch andTouchPoint:(CGPoint)touchLocation
{
    CCSprite *otherSprite_normal = (CCSprite *)[self getChildByTag:OTHER_BUTTON_TAG];
    CCSprite *otherSprite_selected = (CCSprite *)[self getChildByTag:OTHER_BUTTON_TAG + 1];
    if (CGRectContainsPoint(otherSprite_normal.boundingBox, touchLocation)) {
        otherSprite_normal.visible = NO;
        otherSprite_selected.visible = YES;
    }
}
//托管按钮
-(void)robotButtonBegan:(UITouch *)touch andTouchPoint:(CGPoint)touchLocation
{
    CCSprite *robotSprite_normal = (CCSprite *)[self getChildByTag:ROBOT_BUTTON_TAG];
    CCSprite *robotsetSprite_selected = (CCSprite *)[self getChildByTag:ROBOT_BUTTON_TAG + 1];
    if (CGRectContainsPoint(robotSprite_normal.boundingBox, touchLocation)) {
        robotSprite_normal.visible = NO;
        robotsetSprite_selected.visible = YES;
    }
}

-(void)setButtonBegan:(UITouch *)touch andTouchPoint:(CGPoint)touchLocation
{
    CCSprite *setSprite_normal = (CCSprite *)[self getChildByTag:SET_BUTTON_TAG];
    CCSprite *setSprite_selected = (CCSprite *)[self getChildByTag:SET_BUTTON_TAG + 1];
    if (CGRectContainsPoint(setSprite_normal.boundingBox, touchLocation)) {
        setSprite_normal.visible = NO;
        setSprite_selected.visible = YES;
    }
}

-(void)backButtonBegan:(UITouch *)touch andTouchPoint:(CGPoint)touchLocation
{
    CCSprite *backSprite_normal = (CCSprite *)[self getChildByTag:BACK_BUTTON_TAG];
    CCSprite *backSprite_selected = (CCSprite *)[self getChildByTag:BACK_BUTTON_TAG + 1];
    if (CGRectContainsPoint(backSprite_normal.boundingBox, touchLocation)) {
        backSprite_normal.visible = NO;
        backSprite_selected.visible = YES;
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[ChooseSchemaLayer scene]]];
    }
}

-(void)buttonEnded:(UITouch *)touch andTouchPoint:(CGPoint)touchLocation
{
    CCSprite *otherSprite_normal = (CCSprite *)[self getChildByTag:OTHER_BUTTON_TAG];
    CCSprite *otherSprite_selected = (CCSprite *)[self getChildByTag:OTHER_BUTTON_TAG + 1];
    CCSprite *robotSprite_normal = (CCSprite *)[self getChildByTag:ROBOT_BUTTON_TAG];
    CCSprite *robotsetSprite_selected = (CCSprite *)[self getChildByTag:ROBOT_BUTTON_TAG + 1];
    CCSprite *setSprite_normal = (CCSprite *)[self getChildByTag:SET_BUTTON_TAG];
    CCSprite *setSprite_selected = (CCSprite *)[self getChildByTag:SET_BUTTON_TAG +1];
    CCSprite *backSprite_normal = (CCSprite *)[self getChildByTag:BACK_BUTTON_TAG];
    CCSprite *backSprite_selected = (CCSprite *)[self getChildByTag:BACK_BUTTON_TAG + 1];
  
    if (CGRectContainsPoint(otherSprite_normal.boundingBox, touchLocation)) {
        otherSprite_normal.visible = YES;
        otherSprite_selected.visible = NO;
    }
    
    if (CGRectContainsPoint(robotSprite_normal.boundingBox, touchLocation)) {
        robotSprite_normal.visible = YES;
        robotsetSprite_selected.visible = NO;
    }
    if (CGRectContainsPoint(setSprite_normal.boundingBox, touchLocation)) {
        setSprite_normal.visible = YES;
        setSprite_selected.visible = NO;
    }
    if (CGRectContainsPoint(backSprite_normal.boundingBox, touchLocation)) {
        backSprite_normal.visible = YES;
        backSprite_selected.visible = NO;
    }
    if (CGRectContainsPoint(backSprite_normal.boundingBox, touchLocation)) {
        playCardsSprite_normal.visible = YES;
        playCardsSprite_selected.visible = NO;
    }
    if (CGRectContainsPoint(backSprite_normal.boundingBox, touchLocation)) {
        callLandlordSprite_normal.visible = YES;
        callLandlordSprite_selected.visible = NO;
    }
    if (CGRectContainsPoint(backSprite_normal.boundingBox, touchLocation)) {
        dontCallLandlordSprite_normal.visible = YES;
        dontCallLandlordSprite_selected.visible = NO;
    }
    if (CGRectContainsPoint(backSprite_normal.boundingBox, touchLocation)) {
        robLandlordSprite_normal.visible = YES;
        robLandlordSprite_selected.visible = NO;
    }
    if (CGRectContainsPoint(backSprite_normal.boundingBox, touchLocation)) {
        dontRobLandlordSprite_normal.visible = YES;
        dontRobLandlordSprite_selected.visible = NO;
    }
}
-(void)dealloc
{
    CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeUnusedSpriteFrames];
    self.gameLayer = nil;
    [super dealloc];
}
@end
