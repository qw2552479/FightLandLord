//
//  AI.h
//  FightLandLord
//
//  Created by aatc on 9/9/13.
//  Copyright (c) 2013 nchu. All rights reserved.
//
/*
 初始倍数15倍，倍数每抢一次X2，15 30 60 120
叫牌原则：
 火箭：8分
 炸弹：6分
 大王：4分
 小王：3分
 一个2：2分
 大于等于7分能叫就叫
 大于等于5分倍数在60倍或之下可以叫
 大于等于3分倍数在30倍下可以叫
 小于3分不叫
牌张分类原则：
 1.确定火箭 大小王
 2.确定炸弹 4444
 3.确定3条 333
 4.确定3顺 3顺数量尽可能大 444555666
 5.确定单顺 先去除2 王 以及炸弹，如果有单顺，提取，将剩余牌与三条组合（不包含三顺），最后将连牌，三条和剩下的牌组合
 6.确定双顺 两单顺能完全重合，则组成双顺，其次在除炸弹，三顺，三条，单顺之外的牌检测是否包含双顺
 7.确定对子
 8.确定单排
 */
#import <Foundation/Foundation.h>

@interface AI : NSObject
{
    int count;//手数:出完牌所需次数
    int identify;//AI的身份
    NSMutableArray *AICardsArray;//电脑的牌
}

@end
