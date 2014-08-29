//
//  GetPhyAdvise.m
//  Amoy Baby Care
//
//  Created by CHEN WEIBIN on 14-8-29.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import "GetPhyAdvise.h"

@implementation GetPhyAdvise

+(NSArray*)getHeight{
    NSDictionary *dict1=[[NSDictionary alloc]initWithObjectsAndKeys:@"幼儿期孩子的体型由婴儿期的肥墩型向瘦长型转变，四肢的增长逐渐快于躯干的增长。",@"content", nil];
    NSDictionary *dict2=[[NSDictionary alloc]initWithObjectsAndKeys:@"宝宝长得过快可能会导致青春期提前到来，到了成年时身高反而不理想。",@"content", nil];
    NSDictionary *dict3=[[NSDictionary alloc]initWithObjectsAndKeys:@"0-3岁的孩子身高体重发育有一定的范围，低于或高于正常范围都不是好事。正常才是好的。",@"content", nil];
    NSDictionary *dict4=[[NSDictionary alloc]initWithObjectsAndKeys:@"身高主要受遗传、种族和环境的影响较为明显。",@"content", nil];
    NSDictionary *dict5=[[NSDictionary alloc]initWithObjectsAndKeys:@"体格发育有头尾规律，即：婴幼儿期头部发育领先，随着年龄的增长，头增长不多而四肢、躯干增长速度加快。",@"content", nil];
    NSArray *arr = [NSArray arrayWithObjects:dict1,dict5,dict2,dict3,dict4,nil];
    return arr;
}

+(NSArray*)getWeight{
    NSDictionary *dict1=[[NSDictionary alloc]initWithObjectsAndKeys:@"大多数足月宝宝出生时的体重在2.5~4千克之间。出生后几天会出现生理性体重下降，下降值不超过出生体重的10%，不过别担心，宝宝会在出生后7~10天恢复到出生体重。",@"content", nil];
    NSDictionary *dict2=[[NSDictionary alloc]initWithObjectsAndKeys:@"随着吃奶量的增加，宝宝的体重从第4、5天开始回升，第二周即可恢复到出生时的体重。",@"content", nil];
    NSDictionary *dict3=[[NSDictionary alloc]initWithObjectsAndKeys:@"小儿生长发育总的特点为：出生后头2年身高、体重增长较快，2岁至青春期以前有较为稳定的增加。",@"content", nil];
    NSDictionary *dict4=[[NSDictionary alloc]initWithObjectsAndKeys:@"1岁后小儿生长明显相对1岁前的生长速度减慢，1～3岁小儿平均每个月体重增长约150克。",@"content", nil];
    NSDictionary *dict5=[[NSDictionary alloc]initWithObjectsAndKeys:@"0-3岁的孩子身高体重发育有一定的范围，低于或高于正常范围都不是好事。正常才是好的。",@"content", nil];
    NSArray *arr = [NSArray arrayWithObjects:dict1,dict5,dict2,dict3,dict4,nil];
    return arr;
}

+(NSArray*)getBMI{
    NSDictionary *dict1=[[NSDictionary alloc]initWithObjectsAndKeys:@"问：世卫组织生长标准是如何制定的？\n\r答：世卫组织的生长标准以（1997-2003）世卫组织多中心生长参照研究为基础，这一研究所运用的一套严谨方法可以作为开展国际研究合作的模型。由于以生长环境不受约束的健康儿童为样本，因而此项研究为标准的制定提供了坚实的基础。另外，为制定标准而选择的这些儿童的母亲均参与了关键的健康促进做法，即母乳喂养和不吸烟。标准的产生则遵照了最高技术水平的统计学方法。",@"content", nil];
    NSArray *arr = [NSArray arrayWithObjects:dict1 ,nil];
    return arr;
}

+(NSArray*)getHS{
    NSDictionary *dict1=[[NSDictionary alloc]initWithObjectsAndKeys:@"0-6个月宝宝的生理发育特点：宝宝大脑的基本模型于六个月时完成，这一阶段是宝宝大脑发育生长的高峰期，大脑的发育在很大程度上取决于这一年龄段的感官刺激。",@"content", nil];
    NSDictionary *dict2=[[NSDictionary alloc]initWithObjectsAndKeys:@"0-6个月是宝宝一生中成长最快的阶段，也是大脑和视力发育的最关键时期。宝宝与生俱来的无意识动作会渐渐消失，而发展成各种有意义的行为。",@"content", nil];
    NSDictionary *dict3=[[NSDictionary alloc]initWithObjectsAndKeys:@"出生时宝宝的头围平均为34厘米，比胸围略大，所以看上去宝宝的脑袋与身体相比有点大哟。",@"content", nil];
    NSDictionary *dict4=[[NSDictionary alloc]initWithObjectsAndKeys:@"新生儿头部相对较大，由于受产道挤压可能会有些变形。头顶囟门呈菱形，可以看到皮下软组织明显的跳动，是头骨尚未完全封闭形成的，要防止被碰撞。",@"content", nil];
    NSDictionary *dict5=[[NSDictionary alloc]initWithObjectsAndKeys:@"0-6个月是宝宝一生中生长发育最快的阶段，也是大脑发育的“超音速”时期。6个月时，宝宝的脑重会比出生时增加一倍，达到600~700克呢。",@"content", nil];
    NSArray *arr = [NSArray arrayWithObjects:dict1,dict5,dict2,dict3,dict4,nil];
    return arr;
}

+(NSArray*)getTemp{
    NSDictionary *dict1=[[NSDictionary alloc]initWithObjectsAndKeys:@"问：世卫组织生长标准是如何制定的？\n\r答：世卫组织的生长标准以（1997-2003）世卫组织多中心生长参照研究为基础，这一研究所运用的一套严谨方法可以作为开展国际研究合作的模型。由于以生长环境不受约束的健康儿童为样本，因而此项研究为标准的制定提供了坚实的基础。另外，为制定标准而选择的这些儿童的母亲均参与了关键的健康促进做法，即母乳喂养和不吸烟。标准的产生则遵照了最高技术水平的统计学方法。",@"content", nil];
    NSArray *arr = [NSArray arrayWithObjects:dict1 ,nil];
    return arr;

}

@end
