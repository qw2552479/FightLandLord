#import "Player.h"
#import "Card.h"
#import "SimpleAudioEngine.h"
@implementation Player
@synthesize playerInfo, playerCardsArray, lastCardsArray, playerSprite, identity, nextCardsArray;
@synthesize call, dontCall, rob, dontRob, dontPlayCard;
@synthesize refuseCallLandlord;
@synthesize leadPockerType;

+(id) playerWithParentNode:(CCNode *)parentNode andPlayerSpriteTexture:(CCTexture2D *)playerSpriteTexture
{
    return [[self alloc] initWithParentNode:parentNode andPlayerSpriteTexture:playerSpriteTexture];
}
-(id) initWithParentNode:(CCNode *)parentNode andPlayerSpriteTexture:(CCTexture2D *)playerSpriteTexture
{
    if (self = [super init]) {
        winSize = [[CCDirector sharedDirector] winSize];
        [parentNode addChild:self];
        playerSprite = [CCSprite spriteWithTexture:playerSpriteTexture];
        [self addChild:playerSprite];
        leadPockerType = NONE_CARDS;
        playerCardsArray = [[NSMutableArray alloc] init];
        lastCardsArray = [[NSMutableArray alloc] init];
        self.nextCardsArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < 4; i++) {
            CCSpriteFrame *frame = [CCSpriteFrame frameWithTextureFilename:@"对话框_提示字.png" rect:CGRectMake(i * 54, 0, 54, 18)];
            [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFrame:frame name:[NSString stringWithFormat:@"对话框_提示字_%d",i]];
        }
        CCSpriteFrame *frame = [CCSpriteFrame frameWithTextureFilename:@"对话框_不出.png" rect:CGRectMake(0, 0, 54, 18)];

        call = [CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"对话框_提示字_0"]];
        dontCall = [CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"对话框_提示字_1"]];
        rob = [CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"对话框_提示字_2"]];
        dontRob = [CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"对话框_提示字_3"]];
        dontPlayCard = [CCSprite spriteWithSpriteFrame:frame];
        
        call.visible = NO;
        dontCall.visible = NO;
        rob.visible = NO;
        dontRob.visible = NO;
        dontPlayCard.visible = NO;
        
        [self addChild:call];
        [self addChild:dontCall];
        [self addChild:rob];
        [self addChild:dontRob];
        [self addChild:dontPlayCard];
        
        CCTexture2D *texture = [[CCTextureCache sharedTextureCache] addImage:@"bigBoom.png"];
        for (int i = 0; i < 7; i++) {
            CCSpriteFrame *frame = [CCSpriteFrame frameWithTexture:texture rect:CGRectMake((i % 4) * 135, (i / 4) * 75, 135, 75)];
            [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFrame:frame name:[NSString stringWithFormat:@"bigBoomFrame_%d",i]];
        }
        CCTexture2D *texture1 = [[CCTextureCache sharedTextureCache] addImage:@"normalboom.png"];
        for (int i = 0; i < 19; i++) {
            CCSpriteFrame *frame = [CCSpriteFrame frameWithTexture:texture1 rect:CGRectMake((i % 8) * 90, (i / 8) * 100, 90, 100)];
            [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFrame:frame name:[NSString stringWithFormat:@"normalBoomFrame_%d",i]];
        }
        CCTexture2D *gasTexture = [[CCTextureCache sharedTextureCache] addImage:@"gas.png"];
        for (int i = 0; i < 3; i++) {
            CCSpriteFrame *frame = [CCSpriteFrame frameWithTexture:gasTexture rect:CGRectMake(i * 72, 0, 72, 30)];
            [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFrame:frame name:[NSString stringWithFormat:@"gasFrame_%d",i]];
        }
    }
    
    return self;
}

-(void) initPlayer
{
    leadPockerType = NONE_CARDS;
    call.visible = NO;
    dontCall.visible = NO;
    rob.visible = NO;
    dontRob.visible = NO;
    dontPlayCard.visible = NO;
    for (Card *card in playerCardsArray) {
        [card removeFromParentAndCleanup:YES];
    }
    [playerCardsArray removeAllObjects];
    [lastCardsArray removeAllObjects];
    [nextCardsArray removeAllObjects];
}

-(void) showState:(Player_state)state
{
    switch (state) {
        case CALL:
            call.visible = YES;
            dontCall.visible = NO;
            rob.visible = NO;
            dontRob.visible = NO;
            dontPlayCard.visible = NO;
            break;
        case DONT_CALL:
            call.visible = NO;
            dontCall.visible = YES;
            rob.visible = NO;
            dontRob.visible = NO;
            dontPlayCard.visible = NO;
            break;
        case ROB:
            call.visible = NO;
            dontCall.visible = NO;
            rob.visible = YES;
            dontRob.visible = NO;
            dontPlayCard.visible = NO;
            break;
        case DONT_ROB:
            call.visible = NO;
            dontCall.visible = NO;
            rob.visible = NO;
            dontRob.visible = YES;
            dontPlayCard.visible = NO;
            break;
        case DONT_PLAYCARD:
            call.visible = NO;
            dontCall.visible = NO;
            rob.visible = NO;
            dontRob.visible = NO;
            dontPlayCard.visible = YES;
            break;
        case NORMAL_STATE:
            call.visible = NO;
            dontCall.visible = NO;
            rob.visible = NO;
            dontRob.visible = NO;
            dontPlayCard.visible = NO;
            break;
        default:
            CCLOG(@"showState:state may have a value");
            break;
    }
}

-(void) sortCards
{
    [self.nextCardsArray sortUsingFunction:nextCardsArraySort context:nil];
}

NSInteger nextCardsArraySort(id num1, id num2, void *context)
{
    int v1 = [num1 intValue] % 13;
    int v2 = [num2 intValue] % 13;
    switch ([num1 intValue]) {
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
    switch ([num2 intValue]) {
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
//2：对子 3：三张 4：炸弹
-(BOOL) isSame:(NSMutableArray *)nextPockers num:(int)amount
{
    bool IsSame1 = false;
    bool IsSame2 = false;
    for (int i = 0; i < amount - 1; i++) //从大到小比较相邻牌是否相同
    {
        if (([[nextPockers objectAtIndex:i] intValue] % 13) == ([[nextPockers objectAtIndex:(i + 1)] intValue] % 13))
        {
            IsSame1 = true;
        }
        else
        {
            IsSame1 = false;
            break;
        }
    }
    for (int i = nextPockers.count - 1; i > nextPockers.count - amount; i--)  //从小到大比较相邻牌是否相同
    {
        if (([[nextPockers objectAtIndex:i] intValue] % 13) == ([[nextPockers objectAtIndex:(i - 1)] intValue] % 13))
        {
            IsSame2 = true;
        }
        else
        {
            IsSame2 = false;
            break;
        }
    }
    if (IsSame1 || IsSame2)
    {
        return true;
    }
    else
    {
        return false;
    }
    return YES;
}
//飞机
-(void) sameThreeSort:(NSMutableArray *)nextPockers
{
    NSNumber *FourPoker = nil;  //如果把4张当三张出并且带4张的另外一张,就需要特殊处理,这里记录出现这种情况的牌的点数.
    BOOL FindedThree = NO;  //已找到三张相同的牌
    NSMutableArray *tempPokerGroup = [NSMutableArray array];  //记录三张相同的牌
    int count = 0; //记录在连续三张牌前面的翅膀的张数
    int Four = 0; // 记录是否连续出现三三相同,如果出现这种情况则表明出现把4张牌(炸弹)当中的三张和其他牌配成飞机带翅膀,并且翅膀中有炸弹牌的点数.
    // 比如有如下牌组: 998887777666 玩家要出的牌实际上应该为 888777666带997,但是经过从大到小的排序后变成了998887777666 一不美观,二不容易比较.
    for (int i = 2; i < nextPockers.count; i++)  //直接从2开始循环,因为PG[0],PG[1]的引用已经存储在其他变量中,直接比较即可
    {
        if (([[nextPockers objectAtIndex:i] intValue] % 13) == ([[nextPockers objectAtIndex:i - 2] intValue] % 13) && ([[nextPockers objectAtIndex:i] intValue] % 13) == ([[nextPockers objectAtIndex:i - 1] intValue] % 13))// 比较PG[i]与PG[i-1],PG[i]与PG[i-2]是否同时相等,如果相等则说明这是三张相同牌
        {
            if (Four >= 1) //默认的Four为0,所以第一次运行时这里为false,直接执行else
                //一旦连续出现两个三三相等,就会执行这里的if
            {
                FourPoker = [nextPockers objectAtIndex:i]; //当找到四张牌时,记录下4张牌的点数

                for (int k = i; k > 0; k--) //把四张牌中的一张移动到最前面.
                {
                    [nextPockers exchangeObjectAtIndex:k withObjectAtIndex:k-1];
                }
                count++; //由于此时已经找到三张牌,下面为count赋值的程序不会执行,所以这里要手动+1
            }
            else
            {
                Four++; //记录本次循环,因为本次循环找到了三三相等的牌,如果连续两次找到三三相等的牌则说明找到四张牌(炸弹)
                [tempPokerGroup addObject:[nextPockers objectAtIndex:i]]; //把本次循环的PG[i]记录下来,即记录下三张牌的点数
            }
            FindedThree = true; //标记已找到三张牌
        }
        else
        {
            Four = 0; //没有找到时,连续找到三张牌的标志Four归零
            if (!FindedThree) //只有没有找到三张牌时才让count增加.如果已经找到三张牌,则不再为count赋值.
            {
                count = i - 1;
            }
        }
    }
    for (NSNumber *number in tempPokerGroup)  //迭代所有的三张牌点数
    {
        for (int i = 0; i < nextPockers.count; i++)  //把所有的三张牌往前移动
        {
            if ([[nextPockers objectAtIndex:i] intValue] == [number intValue])  //当PG[i]等于三张牌的点数时
            {
                if ([[nextPockers objectAtIndex:i] intValue] == [FourPoker intValue]) //由于上面已经把4张牌中的一张放到的最前面,这张牌也会与tempPoker相匹配所以这里进行处理
                    // 当第一次遇到四张牌的点数时,把记录四张牌的FourPoker赋值为null,并中断本次循环.由于FourPoker已经为Null,所以下次再次遇到四张牌的点数时会按照正常情况执行.
                {
                    FourPoker = nil;
                    continue;
                }
                [nextPockers exchangeObjectAtIndex:i withObjectAtIndex:i-count];
            }
        }
    }
}
//三连
-(BOOL) isThreeLinkPokers:(NSMutableArray *)nextPockers
{
    bool IsThreeLinkPokers = false;
    int HowMuchLinkThree = 0;  //飞机的数量
    [self sameThreeSort:nextPockers]; //排序,把飞机放在前面
    for (int i = 2; i < nextPockers.count; i++)  //得到牌组中有几个飞机
    {
        if (([[nextPockers objectAtIndex:i] intValue] % 13) == ([[nextPockers objectAtIndex:i - 1] intValue] % 13) && ([[nextPockers objectAtIndex:i] intValue] % 13) == ([[nextPockers objectAtIndex:i - 2] intValue] % 13))
        {
            HowMuchLinkThree++;
        }
    }
    if (HowMuchLinkThree > 0)  //当牌组里面有三个时
    {
        if (HowMuchLinkThree > 1)  //当牌组为飞机时
        {
            for (int i = 0; i < HowMuchLinkThree * 3 - 3; i += 3) //判断飞机之间的点数是否相差1
            {
                if (([[nextPockers objectAtIndex:i] intValue] % 13) != 1 && ([[nextPockers objectAtIndex:i] intValue] % 13) - 1 == ([[nextPockers objectAtIndex:i + 3] intValue] % 13)) //2点不能当飞机出
                {
                    IsThreeLinkPokers = true;
                }
                else
                {
                    IsThreeLinkPokers = false;
                    break;
                }
            }
        }
        else
        {
            IsThreeLinkPokers = true; //牌组为普通三个,直接返回true
        }
    }
    else
    {
        IsThreeLinkPokers = false;
    }
    if (HowMuchLinkThree == 4)
    {
        leadPockerType = FOUR_LIAN_PLANE;
    }
    if (HowMuchLinkThree == 3 && nextPockers.count == 12)
    {
        leadPockerType = THREE_LIAN_PLANE_CHIBANG;
    }
    return IsThreeLinkPokers;
}
//顺子
-(BOOL) isStraight:(NSMutableArray *)nextPockers
{
    bool IsStraight = false;
    for (NSNumber *number in nextPockers)//不能包含2、小王、大王
    {
        if (([number intValue] % 13) == 1 || ([number intValue] % 13) == 52 || ([number intValue] % 13) == 53)
        {
            IsStraight = false;
            return IsStraight;
        }
    }
    for (int i = 0; i < nextPockers.count - 1; i++)
    {
        if (([[nextPockers objectAtIndex:i] intValue] % 13) - 1 == ([[nextPockers objectAtIndex:i + 1] intValue] % 13))
        {
            IsStraight = true;
        }
        else
        {
            IsStraight = false;
            break;
        }
    }
    return IsStraight;
}
//连对
-(BOOL) isLinkPair:(NSMutableArray *)nextPockers
{
    bool IsLinkPair = false;
    for (NSNumber *number in nextPockers) //不能包含2、小王、大王
    {
        if (([number intValue] % 13) == 1 || ([number intValue] % 13) == 52 || ([number intValue] % 13) == 53)
        {
            IsLinkPair = false;
            return IsLinkPair;
        }
    }
    for (int i = 0; i < nextPockers.count - 2; i += 2)  //首先比较是否都为对子，再比较第一个对子的点数-1是否等于第二个对子，最后检察最小的两个是否为对子（这里的for循环无法检测到最小的两个，所以需要拿出来单独检查）
    {
        if (([[nextPockers objectAtIndex:i] intValue] % 13) == ([[nextPockers objectAtIndex:i + 1] intValue] % 13) && ([[nextPockers objectAtIndex:i] intValue] % 13) - 1 == ([[nextPockers objectAtIndex:i + 2] intValue] % 13) && ([[nextPockers objectAtIndex:i + 2] intValue] % 13) == ([[nextPockers objectAtIndex:i + 3] intValue] % 13))
        {
            IsLinkPair = true;
        }
        else
        {
            IsLinkPair = false;
            break;
        }
    }
    return IsLinkPair;
}
//判断是否比最近的一次牌大 // 自己的下一手牌存的是nsnumber，lastCards存的是card
-(BOOL) isGreaterThanLastCards:(NSMutableArray *)lastCards andLastCardsType:(PockerGroupType)type
{
    Card *card = [lastCards objectAtIndex:0];
    int nextCardsvalue = card.value;
    int lastCardsValue = [[nextCardsArray objectAtIndex:0] intValue];
    bool IsGreater = NO;
    if (leadPockerType != type && leadPockerType != BOOM && leadPockerType != SHUANGWANG)
    {
        IsGreater = NO;
    }
    else
    {
        if (leadPockerType == BOOM && type == BOOM) //LPRP都为炸弹
        {
            if (lastCardsValue > nextCardsvalue) //比较大小
            {
                IsGreater = YES;
            }
            else
            {
                IsGreater = NO;
            }
        }
        else
        {
            if (leadPockerType == BOOM) //只有LP为炸弹
            {
                IsGreater = YES;
            }
            else
            {
                if (leadPockerType == SHUANGWANG) //LP为双王
                {
                    IsGreater = YES;
                }
                else
                {
                    if (lastCardsValue > nextCardsvalue) //LP为普通牌组
                    {
                        IsGreater = YES;
                    }
                    else
                    {
                        IsGreater = NO;
                    }
                }
            }
        }
    }
    return IsGreater;
}
//-----------
//判断要出的牌是否符合规则
-(BOOL)isRules
{
    bool isRule = false;
    [self sortCards];
    NSLog(@"%@",self.nextCardsArray);
    switch (self.nextCardsArray.count)
    {
        case 0:
            isRule = false;
            break;
        case 1:
            isRule = true;
            leadPockerType = SINGLE;
            break;
        case 2:
            if ([self isSame:self.nextCardsArray num:2])
            {
                isRule = true;
                leadPockerType = DUIZI;
            }
            else
            {
                if ([[self.nextCardsArray objectAtIndex:0] intValue] == 53 && [[self.nextCardsArray objectAtIndex:1] intValue] == 52)
                {
                    leadPockerType = SHUANGWANG;
                    isRule = true;
                }
                else
                {
                    isRule = false;
                }
            }
            break;
        case 3:
            if ([self isSame:self.nextCardsArray num:3])
            {
                leadPockerType = SANZHANG;
                isRule = true;
            }
            else
            {
                isRule = false;
            }
            break;
        case 4:
            if ([self isSame:self.nextCardsArray num:4])
            {
                leadPockerType = BOOM;
                isRule = true;
            }
            else
            {
                if ([self isThreeLinkPokers:self.nextCardsArray])
                {
                    leadPockerType = THREE_DAI_ONE;
                    isRule = true;
                }
                else
                {
                    isRule = false;
                }
            }
            break;
        case 5:
            if ([self isStraight:self.nextCardsArray])
            {
                leadPockerType = FIVE_SHUNZI;
                isRule = true;
            }
            else
            {
                isRule = false;
            }
            break;
        case 6:
            if ([self isStraight:self.nextCardsArray])
            {
                leadPockerType = SIX_SHUNZI;
                isRule = true;
            }
            else
            {
                if ([self isLinkPair:self.nextCardsArray])
                {
                    leadPockerType = THREE_LIANDUI;
                    isRule = true;
                }
                else
                {
                    if ([self isSame:self.nextCardsArray num:4])
                    {
                        leadPockerType = FOUR_DAI_TWO;
                        isRule = true;
                    }
                    else
                    {
                        if ([self isThreeLinkPokers:self.nextCardsArray])
                        {
                            leadPockerType = DOUBLE_LIAN_PLANE;
                            isRule = true;
                        }
                        else
                        {
                            isRule = false;
                        }
                    }
                }
            }
            break;
        case 7:
            if ([self isStraight:self.nextCardsArray])
            {
                leadPockerType = SEVEN_SHUNZI;
                isRule = true;
            }
            else
            {
                isRule = false;
            }
            break;
        case 8:
            if ([self isStraight:self.nextCardsArray])
            {
                leadPockerType = EIGHT_SHUNZI;
                isRule = true;
            }
            else
            {
                if ([self isLinkPair:self.nextCardsArray])
                {
                    leadPockerType = FOUR_LIANDUI;
                    isRule = true;
                }
                else
                {
                    if ([self isThreeLinkPokers:self.nextCardsArray])
                    {
                        leadPockerType = DOUBLE_LIAN_PLANE_CHIBANG;
                        isRule = YES;
                    }
                    else
                    {
                        isRule = NO;
                    }
                }
            }
            break;
        case 9:
            if ([self isStraight:self.nextCardsArray])
            {
                leadPockerType = NINE_SHUNZI;
                isRule = YES;
            }
            else
            {
                if ([self isThreeLinkPokers:self.nextCardsArray])
                {
                    leadPockerType = THREE_LIAN_PLANE;
                    isRule = YES;
                }
                else
                {
                    isRule = NO;
                }
            }
            break;
        case 10:
            if ([self isStraight:self.nextCardsArray])
            {
                leadPockerType = TEN_SHUNZI;
                isRule = true;
            }
            else
            {
                if ([self isLinkPair:self.nextCardsArray])
                {
                    leadPockerType = FIVE_LIANDUI;
                    isRule = true;
                }
                else
                {
                    isRule = false;
                }
            }
            break;
        case 11:
            if ([self isStraight:self.nextCardsArray])
            {
                leadPockerType = ELEVEN_SHUNZI;
                isRule = true;
            }
            else
            {
                isRule = false;
            }
            break;
        case 12:
            if ([self isStraight:self.nextCardsArray])
            {
                leadPockerType = TWELVE_SHUNZI;
                isRule = true;
            }
            else
            {
                if ([self isLinkPair:self.nextCardsArray])
                {
                    leadPockerType = SIX_LIANDUI;
                    isRule = true;
                }
                else
                {
                    if ([self isThreeLinkPokers:self.nextCardsArray])
                    {
                        //12有三连飞机带翅膀和四连飞机两种情况,所以在IsThreeLinkPokers中做了特殊处理,此处不用给type赋值.
                        isRule = true;
                    }
                    else
                    {
                        isRule = false;
                    }
                }
            }
            break;
        case 13:
            isRule = false;
            break;
        case 14:
            if ([self isLinkPair:self.nextCardsArray])
            {
                leadPockerType = SEVEN_LIANDUI;
                isRule = true;
            }
            else
            {
                isRule = false;
            }
            break;
        case 15:
            if ([self isThreeLinkPokers:self.nextCardsArray])
            {
                leadPockerType = FIVE_LIAN_PLANE;
                isRule = true;
            }
            else
            {
                isRule = false;
            }
            break;
        case 16:
            if ([self isLinkPair:self.nextCardsArray])
            {
                leadPockerType = EIGHT_LIANDUI;
                isRule = true;
            }
            else
            {
                if ([self isThreeLinkPokers:self.nextCardsArray])
                {
                    leadPockerType = FOUR_LIAN_PLANE_CHIBANG;
                    isRule = true;
                }
                else
                {
                    isRule = false;
                }
            }
            break;
        case 17:
            isRule = false;
            break;
        case 18:
            if ([self isLinkPair:self.nextCardsArray])
            {
                leadPockerType = SIX_LIANDUI;
                isRule = true;
            }
            else
            {
                if ([self isThreeLinkPokers:self.nextCardsArray])
                {
                    leadPockerType = SIX_LIAN_PLANE;
                    isRule = true;
                }
                else
                {
                    isRule = false;
                }
            }
            break;
        case 19:
            isRule = false;
            break;
        case 20:
            if ([self isLinkPair:self.nextCardsArray])
            {
                leadPockerType = TEN_LIANDUI;
                isRule = true;
            }
            else
            {
                if ([self isThreeLinkPokers:self.nextCardsArray])
                {
                    leadPockerType = FIVE_LIAN_PLANE_CHIBANG;
                    isRule = true;
                }
                else
                {
                    isRule = false;
                }
            }
            break;
    }
    return isRule;
}
//出牌音效及动画
-(void) playSoundByCardType:(PockerGroupType)type
{
    int value;
    switch (type) {
        case SINGLE:
            value = [[self.nextCardsArray objectAtIndex:0] intValue];
            //52 53大小王
            if (value == 52) {
                [[SimpleAudioEngine sharedEngine] playEffect:@"14.wav"];
            } else if (value == 53) {
                [[SimpleAudioEngine sharedEngine] playEffect:@"15.wav"];
            } else {
                value = value % 13 + 1;
                [[SimpleAudioEngine sharedEngine] playEffect:[NSString stringWithFormat:@"%d.wav", value]];
            }
            break;
        case DUIZI:
            value = [[self.nextCardsArray objectAtIndex:0] intValue] % 13 + 1;
            [[SimpleAudioEngine sharedEngine] playEffect:[NSString stringWithFormat:@"dui%d.wav", value]];
            break;
        case SHUANGWANG:
            [[SimpleAudioEngine sharedEngine] playEffect:@"wangzha.wav"];
            [self bigBoomAnimation];
            break;
        case SANZHANG:
            [[SimpleAudioEngine sharedEngine] playEffect:@"sange.wav"];
            break;
        case THREE_DAI_ONE:
            [[SimpleAudioEngine sharedEngine] playEffect:@"sandaiyi.wav"];
            break;
        case BOOM:
            [[SimpleAudioEngine sharedEngine] playEffect:@"zhadan.wav"];
            [self normalBoomAnimation];
            break;
            //顺子
        case FIVE_SHUNZI:
        case SIX_SHUNZI:
        case SEVEN_SHUNZI:
        case EIGHT_SHUNZI:
        case NINE_SHUNZI:
        case TEN_SHUNZI:
        case ELEVEN_SHUNZI:
        case TWELVE_SHUNZI:
            [[SimpleAudioEngine sharedEngine] playEffect:@"shunzi.wav"];
            [self shunziAnimation];
            break;
            //连对---------
        case THREE_LIANDUI:
        case FOUR_LIANDUI:
        case FIVE_LIANDUI:
        case SIX_LIANDUI:
        case SEVEN_LIANDUI:
        case EIGHT_LIANDUI:
        case NINE_LIANDUI:
        case TEN_LIANDUI:
            [[SimpleAudioEngine sharedEngine] playEffect:@"liandui.wav"];
            break;
        case FOUR_DAI_TWO:
            [[SimpleAudioEngine sharedEngine] playEffect:@"sidaier.wav"];
            break;
        case DOUBLE_LIAN_PLANE:
        case DOUBLE_LIAN_PLANE_CHIBANG:
        case THREE_LIAN_PLANE:
        case THREE_LIAN_PLANE_CHIBANG:
        case FOUR_LIAN_PLANE:
        case FOUR_LIAN_PLANE_CHIBANG:
        case FIVE_LIAN_PLANE:
        case FIVE_LIAN_PLANE_CHIBANG:
        case SIX_LIAN_PLANE:
            [[SimpleAudioEngine sharedEngine] playEffect:@"feiji.wav"];
            break;
        default:
            break;
    }
    //最后一张牌报警
    if (playerCardsArray.count == 1) {
        [[SimpleAudioEngine sharedEngine] playEffect:@"baojing1.wav"];
    }
}
//普通炸弹动画
-(void) normalBoomAnimation
{
    //炸弹爆炸动画
    CCSprite *tips = [CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"normalBoomFrame_0"]];
    tips.position = ccp(winSize.width / 2, winSize.height / 2);
    tips.visible = NO;
    [[self parent] addChild:tips z:100];
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < 19; i++) {
        CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"normalBoomFrame_%d",i]];
        [array addObject:frame];
    }
    CCAnimation *animation = [CCAnimation animationWithSpriteFrames:array delay:0.075];
    CCAnimate *animate = [CCAnimate actionWithAnimation:animation];
    CCShow *show = [CCShow action];
    CCCallBlock *block = [CCCallBlock actionWithBlock:^{
        [tips removeFromParent];
    }];
    CCSequence *s = [CCSequence actions:show, animate, block, nil];
    //飞机精灵gasFrame_
    CCSprite *plane = [CCSprite spriteWithFile:@"green_plane.png"];
    [[self parent] addChild:plane z:100];
    
    //飞机尾气精灵
    CCSprite *gas = [CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"gasFrame_0"]];
    [plane addChild:gas];
    gas.position = ccp(plane.contentSize.width + gas.contentSize.width / 2, plane.contentSize.height / 2);
    NSMutableArray *gasArray = [NSMutableArray array];
    for (int i = 0; i < 3; i++) {
        [gasArray addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"gasFrame_%d", i]]];
    }
    CCAnimation *gasAnimation = [CCAnimation animationWithSpriteFrames:gasArray delay:1.1];
    CCAnimate *gasAnimate = [CCAnimate actionWithAnimation:gasAnimation];
    CCSequence *gasSequence = [CCSequence actions:[CCShow action], gasAnimate, nil];
    [gas runAction:gasSequence];

    plane.position = ccp(winSize.width + plane.contentSize.width / 2, winSize.height - plane.contentSize.height / 2);
    //飞机开到场中间ccp(plane.contentSize.width, winSize.height / 3 * 2)
    [[SimpleAudioEngine sharedEngine] playEffect:@"common_plane.wav"];
    CCMoveTo *planeMoveTo = [CCMoveTo actionWithDuration:1.0 position:ccp(plane.contentSize.width / 2, winSize.height - plane.contentSize.height / 2)];
    //炸弹动画
    CCSprite *boom = [CCSprite spriteWithFile:@"boom.png"];
    [[self parent] addChild:boom z:99];
    boom.position = ccp(winSize.width / 2, winSize.height - plane.contentSize.height / 2);
    boom.visible = NO;
    CCMoveTo *boomMoveTo = [CCMoveTo actionWithDuration:0.5 position:ccp(boom.position.x, winSize.height / 3 * 2)];
    CCCallBlock *boomBlock = [CCCallBlock actionWithBlock:^{
        [[SimpleAudioEngine sharedEngine] playEffect:@"common_bomb.wav"];
        [boom removeFromParentAndCleanup:YES];
        [tips runAction:s];
    }];
    CCSequence *boomSequence = [CCSequence actions:[CCDelayTime actionWithDuration:0.5f],[CCShow action],boomMoveTo, [CCHide action], boomBlock, nil];
    CCCallBlock *planeBlock2 = [CCCallBlock actionWithBlock:^{
        [gas removeFromParentAndCleanup:YES];
        [plane removeFromParentAndCleanup:YES];
    }];
    CCSequence *planeSequence = [CCSequence actions:[CCShow action], planeMoveTo, [CCHide action], planeBlock2, nil];
    [boom runAction:boomSequence];
    [plane runAction:planeSequence];
}
//王炸动画
-(void) bigBoomAnimation
{
    CCSprite *tips = [CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"bigBoomFrame_0"]];
    tips.position = ccp(winSize.width / 2, winSize.height / 2);
    tips.visible = NO;
    [[self parent] addChild:tips z:100];
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < 7; i++) {
        CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"bigBoomFrame_%d",i]];
        [array addObject:frame];
    }
    CCAnimation *animation = [CCAnimation animationWithSpriteFrames:array delay:0.075];
    CCAnimate *animate = [CCAnimate actionWithAnimation:animation];
    CCShow *show = [CCShow action];
    CCCallBlock *block = [CCCallBlock actionWithBlock:^{
        [tips removeFromParent];
    }];
    CCSequence *s = [CCSequence actions:show, animate, block, nil];
    [tips runAction:s];
}
//连对动画
-(void) lianDuiAnimation
{
    CCSprite *tips = [CCSprite spriteWithFile:@"顺子连对.png" rect:CGRectMake(100, 0, 100, 60)];
    tips.position = ccp(winSize.width / 2, winSize.height / 2 - 20);
    tips.visible = NO;
    [[self parent] addChild:tips z:100];
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
//顺子动画
-(void) shunziAnimation
{
    CCSprite *tips = [CCSprite spriteWithFile:@"顺子连对.png" rect:CGRectMake(0, 0, 100, 60)];
    tips.position = ccp(winSize.width / 2, winSize.height / 2 - 20);
    tips.visible = NO;
    [[self parent] addChild:tips z:100];
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
//不符合规则动画
-(void) zhadanAnimation
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
-(void)dealloc
{
    self.identity = nil;
    self.playerSprite = nil;
    self.playerCardsArray = nil;
    self.lastCardsArray = nil;
    self.playerInfo = nil;
    self.call = nil;
    self.dontCall = nil;
    self.rob = nil;
    self.dontRob = nil;
    self.dontPlayCard = nil;
    self.nextCardsArray = nil;
    [[CCTextureCache sharedTextureCache] removeUnusedTextures];
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeUnusedSpriteFrames];
    [super dealloc];
}

@end
