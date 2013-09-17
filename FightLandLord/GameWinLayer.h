//
//  GameWinLayer.h
//  FightLandLord
//
//  Created by aatc on 9/9/13.
//  Copyright 2013 nchu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GameWinLayer : CCLayer {
    
}
//1为地主，2为农民
+(id)initWithWinnerIndentify:(int) indentify withParentNode:(CCNode *)parentNode;
-(id) initWithWinnerIndentify:(int) indentify withParentNode:(CCNode *)parentNode;

//农民胜利动画
-(void) farmerWinAnimation:(BOOL) ifIwin;
//地主胜利动画
-(void) landlordWinAnimation:(BOOL) ifIwin;

@end
