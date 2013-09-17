//
//  GameData.h
//  FightLandLord
//
//  Created by aatc on 9/8/13.
//  Copyright (c) 2013 nchu. All rights reserved.
//

#ifndef FightLandLord_GameData_h
#define FightLandLord_GameData_h
typedef enum {
    CALL,
    DONT_CALL,
    ROB,
    DONT_ROB,
    DONT_PLAYCARD,
    NORMAL_STATE,
} Player_state;

typedef enum {
    SINGLE = 1,//单张 = 1,
    DUIZI = 2, //对子 = 2,
    SHUANGWANG = 3,                                             //双王 = 2,
    SANZHANG = 4, //三张相同 = 3,
    THREE_DAI_ONE = 5,//三带一                                     //三带一 = 4,
    BOOM = 6,//炸弹     //炸弹 = 4,
    FIVE_SHUNZI = 7, //五张顺子 = 7,                                //五张顺子 = 5,
    SIX_SHUNZI = 8,// 六张顺子 = 8,                                 //六张顺子 = 6,
    THREE_LIANDUI = 9,//三连对 = 9,                                //三连对 = 6,
    FOUR_DAI_TWO = 10,//四带二 = 10,5555+22                        //四带二 = 6,
    DOUBLE_LIAN_PLANE = 11,//二连飞机 = 11,333+444                  //二连飞机 = 6,
    SEVEN_SHUNZI = 12,//七张顺子 = 12,                              //七张顺子 = 7,
    FOUR_LIANDUI = 13,//四连对 = 13,                               //四连对 = 8,
    EIGHT_SHUNZI = 14,//八张顺子 = 14,                              //八张顺子 = 8,
    DOUBLE_LIAN_PLANE_CHIBANG = 15,//飞机带翅膀 = 15,   333444+23            //飞机带翅膀 = 8,
    NINE_SHUNZI = 16, //九张顺子 = 16,                                 //九张顺子 = 9,
    THREE_LIAN_PLANE = 17,//三连飞机 = 17,                               //三连飞机 = 9,
    FIVE_LIANDUI = 18,//五连对 = 18,                                     //五连对 = 10,
    TEN_SHUNZI = 19,//十张顺子 = 19,                                    //十张顺子 = 10,
    ELEVEN_SHUNZI = 20,//十一张顺子 = 20,                                //十一张顺子 = 11,
    TWELVE_SHUNZI = 21,//十二张顺子 = 21,                                //十二张顺子 = 12,
    FOUR_LIAN_PLANE = 22, //四连飞机 = 22,                                 //四连飞机 = 12,
    THREE_LIAN_PLANE_CHIBANG = 23, //三连飞机带翅膀 = 23,                  //三连飞机带翅膀 = 12,
    SIX_LIANDUI = 24,//六连对 = 24,                                     //六连对 = 12,
    //没有13                                           ////没有13
    SEVEN_LIANDUI = 25, //七连对 = 25,                                    //七连对 = 14,
    FIVE_LIAN_PLANE = 26,//五连飞机 = 26,                                 //五连飞机 = 15,
    EIGHT_LIANDUI = 27,//八连对 = 27,                                     //八连对 = 16,
    FOUR_LIAN_PLANE_CHIBANG = 28, //四连飞机带翅膀 = 28,                    //四连飞机带翅膀 = 16,
    //没有17                                           //没有17
    NINE_LIANDUI = 29,//九连对 = 29,                                     //九连对 = 18,
    SIX_LIAN_PLANE = 30,//六连飞机 = 30,                                  //六连飞机 = 18,
    //没有19//没有19
    TEN_LIANDUI = 31,//十连对 = 31, //十连对 = 20,
    FIVE_LIAN_PLANE_CHIBANG = 32,//五连飞机带翅膀 = 32 EG:333444555666777+JQKA2
    //    THREE_DAI_PAIR = 33,     //EG:333 + 66    5
    //    DOUBLE_LIAN_PLANE_CHIBANG_PAIR = 34,//EG:333444 + 6677     10
    //    THREE_LIAN_PLANE_CHIBANG_PAIR = 35,// EG:333444555 + 667788 15
    NONE_CARDS = 0,
} PockerGroupType;

typedef enum {
    PLAYCARD_LAYER = 100,
    GAME_LAYER = 101
} LayerTag;

#define CARD_WIDTH_SMALL 14
#define CARD_HEIGHT_SMALL 19
#define CARD_WIDTH 59
#define CARD_HEIGHT 72
#define BOTTOM_HEIGHT 65
#define TOP_HEIGHT 43
#define CARD_OFFSET 18

#define LOCALPLAYER_POSITION ccp(35, 80)
#define LEFTPLAYER_POSITION ccp(35, 250)
#define RIGHTPLAYER_POSITION ccp(450, 250)

#define CALL_LANDLORD_TIME 5
#define ROB_LANDLORD_TIME 5
#define PLAYCARDS_LANDLORD_TIME 5

#define BACK_BUTTON_TAG 10//返回按钮标记
#define ROBOT_BUTTON_TAG 20//托管按钮标记
#define OTHER_BUTTON_TAG 30//其他按钮标记
#define SET_BUTTON_TAG 40//设置按钮标记
#define PLAYCARD_BUTTON_TAG 50//设置按钮标记
#endif
