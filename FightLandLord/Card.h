//
//  Card.h
//  3213
//
//  Created by aatc on 9/5/13.
//  Copyright 2013 nchu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Card : CCSprite
{
    int value;//所代表的纸牌
    BOOL isChoosed;
}

@property (nonatomic, assign) int value;
@property (nonatomic, assign) BOOL isChoosed;

@end
