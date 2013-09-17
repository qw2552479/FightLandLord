//
//  HelloWorldLayer.m
//  3213
//
//  Created by aatc on 9/3/13.
//  Copyright nchu 2013. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"
#import "LoadingScene.h"
#import "ChooseSchemaLayer.h"
#import "MainGameScene.h"
#pragma mark - HelloWorldLayer

// HelloWorldLayer implementation
@implementation HelloWorldLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
        CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
        // CCTexture2D *bgTexture2D = [CCTexture2D alloc]
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        CCSprite *backGround = [CCSprite spriteWithFile:@"ddz_game_bg.png" rect:CGRectMake(0, 0, winSize.width, winSize.height)];
        //backGround.anchorPoint = CGPointZero;
        backGround.position = ccp(winSize.width/2, winSize.height/2);
        [self addChild:backGround z:0];
        
        CCLabelTTF *ttf = [CCLabelTTF labelWithString:@"斗地主" fontName:@"MicrosoftYaHei" fontSize:14];
        ttf.position = ccp(winSize.width - 50, winSize.height - 50);
        [self addChild:ttf];
        //350 47
        CCTexture2D *start_texture = [[CCTextureCache sharedTextureCache] addImage:@"ddz_main_bt_startgame.png"];
        CCSpriteFrame *start_frame_normal = [CCSpriteFrame frameWithTexture:start_texture rect:CGRectMake(0, 0, 175, 47)];
        CCSpriteFrame *start_frame_pressed = [CCSpriteFrame frameWithTexture:start_texture rect:CGRectMake(175, 0, 175, 47)];
        CCSprite *start_normal = [CCSprite spriteWithSpriteFrame:start_frame_normal];
        CCSprite *start_pressed = [CCSprite spriteWithSpriteFrame:start_frame_pressed];
        CCMenuItemSprite *start_menu = [CCMenuItemSprite itemWithNormalSprite:start_normal selectedSprite:start_pressed target:self selector:@selector(startGame)];
        
        CCTexture2D *help_texture = [[CCTextureCache sharedTextureCache] addImage:@"ddz_main_bt_help.png"];
        CCSpriteFrame *help_frame_normal = [CCSpriteFrame frameWithTexture:help_texture rect:CGRectMake(0, 0, 175, 47)];
        CCSpriteFrame *help_frame_pressed = [CCSpriteFrame frameWithTexture:help_texture rect:CGRectMake(175, 0, 175, 47)];
        CCSprite *help_normal = [CCSprite spriteWithSpriteFrame:help_frame_normal];
        CCSprite *help_pressed = [CCSprite spriteWithSpriteFrame:help_frame_pressed];
        CCMenuItemSprite *help_menu = [CCMenuItemSprite itemWithNormalSprite:help_normal selectedSprite:help_pressed target:self selector:@selector(showHelp)];
        
        CCTexture2D *set_texture = [[CCTextureCache sharedTextureCache] addImage:@"ddz_main_bt_option.png"];
        CCSpriteFrame *set_frame_normal = [CCSpriteFrame frameWithTexture:set_texture rect:CGRectMake(0, 0, 175, 47)];
        CCSpriteFrame *set_frame_pressed = [CCSpriteFrame frameWithTexture:set_texture rect:CGRectMake(175, 0, 175, 47)];
        CCSprite *set_normal = [CCSprite spriteWithSpriteFrame:set_frame_normal];
        CCSprite *set_pressed = [CCSprite spriteWithSpriteFrame:set_frame_pressed];
        CCMenuItemSprite *set_menu = [CCMenuItemSprite itemWithNormalSprite:set_normal selectedSprite:set_pressed target:self selector:@selector(showSettingLayer)];
        
        start_menu.tag = 1;
        help_menu.tag = 2;
        set_menu.tag = 3;
        
        CCMenu *menu = [CCMenu menuWithItems:start_menu, help_menu, set_menu, nil];
       
        menu.position = ccp(winSize.width + menu.contentSize.width, winSize.height  / 2 - 50);
        [self addChild:menu];
        
        [menu alignItemsVerticallyWithPadding:0];
        
        CCSprite *start_logo_bg = [CCSprite spriteWithFile:@"start_logo_bg.png"];
        start_logo_bg.scale = 1.2;
        [self addChild:start_logo_bg z:1];
        start_logo_bg.position = ccp(winSize.width / 2, winSize.height + start_logo_bg.contentSize.height / 2);

        CCMoveTo *bg_moveto = [CCMoveTo actionWithDuration:2.f position:ccp(winSize.width / 2, winSize.height - start_logo_bg.contentSize.height + 25)];
        CCEaseBackOut *ease = [CCEaseBackOut actionWithAction:bg_moveto];

        CCCallBlock *bgBlock = [CCCallBlock actionWithBlock:^{
            CCMoveTo *menuMoveTo = [CCMoveTo actionWithDuration:1 position:ccp(winSize.width / 2 , winSize.height / 2 - 50)];
            CCEaseBackOut *back = [CCEaseBackOut actionWithAction:menuMoveTo];
            [menu runAction:back];
        }];
        CCSequence *bg_sequence = [CCSequence actions:ease, bgBlock, nil];
        [start_logo_bg runAction:bg_sequence];

	}
	return self;
}

-(void) onEnter
{
    [super onEnter];
    
  //  [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"ddz_sound_background.wav"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"GAME_CONCLUDE.wav"];
}

-(void)onExit
{
    [super onExit];
    //[[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
}

-(void) startGame
{
    NSLog(@"start");
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFadeTR transitionWithDuration:0.75 scene:[ChooseSchemaLayer scene]]];
    [[SimpleAudioEngine sharedEngine] playEffect:@"GAME_CONCLUDE.wav"];
}

-(void) showHelp
{
    [[CCDirector sharedDirector] replaceScene:[MainGameScene node]];
}
-(void) showSettingLayer
{
    //[[CCDirector sharedDirector] replaceScene:[LoadingScene sceneWithTargetScene:TargetSceneFirst andTargetScene:[HelloWorldLayer scene]]];
    [[SimpleAudioEngine sharedEngine] playEffect:@"GAME_CONCLUDE.wav"];
}

-(void)test
{
    [[CCDirector sharedDirector] replaceScene:[LoadingScene sceneWithTargetScene:TargetSceneFirst andTargetScene:[MainGameScene node]]];
}
// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
    [[CCTextureCache sharedTextureCache] removeUnusedTextures];
    CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
	[super dealloc];
}

#pragma mark GameKit delegate

-(void) achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}
@end
