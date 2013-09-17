//
//  LoadingScene.m
//  3213
//
//  Created by aatc on 9/4/13.
//  Copyright 2013 nchu. All rights reserved.
//

#define getWinSieze() [[CCDirector sharedDirector] winSize]

#import "LoadingScene.h"
#import "HelloWorldLayer.h"

@implementation LoadingScene

+(CCScene *) scene
{
    CCScene *scene = [CCScene node];
    LoadingScene *layer = [LoadingScene node];
    [scene addChild:layer];
    return scene;
}

+(CCScene *) sceneWithTargetScene:(TargetSceneTypes)sceneType andTargetScene:(CCScene *)targetScene
{
    return [[self alloc] initWithTargetScene:sceneType andTargetScene:targetScene];
}
-(id) initWithTargetScene:(TargetSceneTypes)sceneType andTargetScene:(CCScene *)targetScene
{
    if ((self = [super init])) {
        targetSceneType = sceneType;
        self.targetScene = targetScene;
        CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
        CGSize winSize = getWinSieze();
        
        //背景
        CCSprite *backGround = [CCSprite spriteWithFile:@"loading_bg.png"];
        //backGround.anchorPoint = CGPointZero;
        backGround.position = ccp(winSize.width/2, winSize.height/2);
        [self addChild:backGround z:0];
        //图片人物
        //进度条外框
        CCSprite *loadingBar_bg = [CCSprite spriteWithFile:@"loading_probarback.png"];
        loadingBar_bg.position = ccp(winSize.width * 0.5, winSize.height * 0.2);
        [self addChild:loadingBar_bg z:1];
        //进度条色块
        CCSprite *loadingBar = [CCSprite spriteWithFile:@"loading_probar.png"];
        CCProgressTimer *loadingBarProgress = [CCProgressTimer progressWithSprite:loadingBar];
        loadingBarProgress.position = ccp(winSize.width * 0.5, winSize.height * 0.2);

        loadingBarProgress.type = kCCProgressTimerTypeBar;
        loadingBarProgress.barChangeRate = ccp(1,0);
        loadingBarProgress.percentage = 0;
        loadingBarProgress.midpoint = ccp(0,0);
        [self addChild:loadingBarProgress z:5 tag:5];
        
        //loading 字样
        CCLabelTTF *loadTTF = [CCLabelTTF labelWithString:NSLocalizedString(@"loading...", @"") fontName:@"Marker Felt" fontSize:12];
        loadTTF.position = loadingBar_bg.position;

        [self addChild:loadTTF z:6];
        
        [self scheduleUpdate];
    }
    
    return self;
}

-(void) update:(ccTime)delta
{
    //发送正在进度条中
 //   [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTICE_PROCESSING_UPDATE" object:nil];
    
    CCProgressTimer *timer1 = (CCProgressTimer*) [self getChildByTag:5];
    //timer1.percentage += delta * 50;
    //外部已经完成耗时操作
   
    if(_finishedSigle)
    {
        if (timer1.percentage < 100)
        {
            timer1.percentage += delta * 50;
        }
        else
        {
            
            switch (targetSceneType) {
                case TargetSceneFirst:
                    [self unscheduleUpdate];
                    [[CCDirector sharedDirector] replaceScene:self.targetScene];
                    _finishedSigle = NO;
                   // [self unschedule:@selector(loadScene:)];
                    break;
                case TargetSceneSecond:
                    break;
                case TargetSceneMAX:
                    
                    break;
                    
                default:
                    break;
            }
        }
    }
    else
    {
        if((arc4random()%10) > 4)
        {
            timer1.percentage += delta * 50;
        }
        if (timer1.percentage == 100) {
            _finishedSigle = YES;
        }
    }
}

-(void) NOTICE_finisheddoSomethingTimeConsuming:(NSNotification *) notice
{
    _finishedSigle = YES;
}
-(void)dealloc
{
    CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
    self.targetScene = nil;
    [super dealloc];
}

@end
