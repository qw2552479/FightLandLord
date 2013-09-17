//
//  ChooseModelLayer.m
//  3213
//
//  Created by aatc on 9/4/13.
//  Copyright 2013 nchu. All rights reserved.
//

#import "ChooseSchemaLayer.h"
#import "HelloWorldLayer.h"
#import "SimpleAudioEngine.h"
#import "MainGameScene.h"
#import "LoadingScene.h"
@implementation ChooseSchemaLayer

+(CCScene *) scene
{
    CCScene *scene = [CCScene node];
    ChooseSchemaLayer *layer = [ChooseSchemaLayer node];
    [scene addChild:layer];
    return scene;
}

-(id)init
{
    if ((self = [super init])) {
        CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        CCSprite *backGround = [CCSprite spriteWithFile:@"choose_schema.png"];
        //backGround.anchorPoint = CGPointZero;
        backGround.position = ccp(winSize.width/2, winSize.height/2);
        [self addChild:backGround z:0];
    
//        CCLabelTTF *singleSchemaLabel = [CCLabelTTF labelWithString:@"单机模式" fontName:@"Marker Felt" fontSize:25];
//        singleSchemaLabel.position = ccp(105, 110);

     //   [self addChild:singleSchemaLabel z:2];
        CCMenuItemImage *singleSchemaImage = [CCMenuItemImage itemWithNormalImage:@"shinebg.png" selectedImage:@"shine-hd.png" block:^(id sender) {
            [[CCDirector sharedDirector] replaceScene:[LoadingScene sceneWithTargetScene:TargetSceneFirst andTargetScene:[MainGameScene node]]];
        }];
      //  singleSchemaImage.contentSize = CGSizeMake(190, 264);
      //  singleSchemaImage.position = ccp(105, 110);
       
        CCMenuItemImage *wifiSchemaImage = [CCMenuItemImage itemWithNormalImage:@"shinebg.png" selectedImage:@"shine-hd.png" block:^(id sender) {
            NSLog(@"wifiSchemaImage");
        }];
      //  wifiSchemaImage.position = ccp(205, 110);
      
        CCMenuItemImage *netSchemaImage = [CCMenuItemImage itemWithNormalImage:@"shinebg.png" selectedImage:@"shine-hd.png" block:^(id sender) {
            NSLog(@"wifiSchemaImage");
        }];
        
      //  netSchemaImage.position = ccp(305, 110);
        
        CCMenu *schemaMenu = [CCMenu menuWithItems:singleSchemaImage, wifiSchemaImage, netSchemaImage, nil];
        [self addChild:schemaMenu z:1];
        schemaMenu.position = ccp(winSize.width / 2 + 3, winSize.height / 2 + 2);
        [schemaMenu alignItemsHorizontallyWithPadding:20];
        
        CCTexture2D *back_texture = [[CCTextureCache sharedTextureCache] addImage:@"button_btreturn.png"];
        CCSpriteFrame *back_frame_normal = [CCSpriteFrame frameWithTexture:back_texture rect:CGRectMake(0, 0, (int)back_texture.contentSize.width>>1, back_texture.contentSize.height)];
        CCSpriteFrame *back_frame_selected = [CCSpriteFrame frameWithTexture:back_texture rect:CGRectMake((int)back_texture.contentSize.width>>1, 0, (int)back_texture.contentSize.width>>1, back_texture.contentSize.height)];
        CCSprite *back_normal = [CCSprite spriteWithSpriteFrame:back_frame_normal];
        CCSprite *back_selected = [CCSprite spriteWithSpriteFrame:back_frame_selected];
        CCMenuItemSprite *backItem = [CCMenuItemSprite itemWithNormalSprite:back_normal selectedSprite:back_selected block:^(id sender) {
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFadeBL transitionWithDuration:0.5 scene:[HelloWorldLayer scene]]];
        }];
   //     back.position = ccp(50, winSize.height - back.contentSize.height * 1.5);
        CCMenu *backMenu = [CCMenu menuWithItems:backItem, nil];
        [self addChild:backMenu z:2];
        backMenu.position = ccp(winSize.width - backItem.contentSize.width, winSize.height - backItem.contentSize.height);
        
        //返回按钮动画
        CCJumpBy *back_jumpBy = [CCJumpBy actionWithDuration:0.25 position:ccp(backItem.position.x, backItem.position.y) height:20 jumps:1];
        CCDelayTime *back_delay1 = [CCDelayTime actionWithDuration:0.25];
        CCSequence *back_sequence1 = [CCSequence actions:back_jumpBy, back_delay1, nil];
        CCRepeat *back_repeat = [CCRepeat actionWithAction:back_sequence1 times:2];
        CCDelayTime *back_delay2 = [CCDelayTime actionWithDuration:4.5];
        CCSequence *back_sequence2 = [CCSequence actions:back_repeat, back_delay2, nil];
        CCRepeatForever *back_repeatForever = [CCRepeatForever actionWithAction:back_sequence2];
        [backItem runAction:back_repeatForever];
        
    }
    
    return self;
}
-(void)onEnter
{
    [super onEnter];
}
-(void)dealloc
{
    CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
    [super dealloc];
}

@end
