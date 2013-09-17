//
//  LoadingScene.h
//  3213
//
//  Created by aatc on 9/4/13.
//  Copyright 2013 nchu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
typedef enum
{
    TargetSceneINVALID = 0,
    TargetSceneFirst,
    TargetSceneSecond,
    TargetSceneMAX,
} TargetSceneTypes;

@interface LoadingScene : CCLayer {
    
    TargetSceneTypes targetSceneType;
    BOOL _finishedSigle;
}

@property (nonatomic, retain) CCScene *targetScene;

+(CCScene *) sceneWithTargetScene:(TargetSceneTypes)sceneType andTargetScene:(CCScene *)targetScene;
-(id) initWithTargetScene:(TargetSceneTypes)sceneType andTargetScene:(CCScene *)targetScene;

@end
