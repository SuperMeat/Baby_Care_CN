//
//  VaccineDetailContentView.m
//  BabyCalendar
//
//  Created by Will on 14-5-31.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import "VaccineDetailContentView.h"
#import "RTLabel.h"
@implementation VaccineDetailContentView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    _contentView = [[RTLabel alloc] initWithFrame:CGRectMake(10, 0, kDeviceWidth-20, 10)];
    _contentView.textColor = UIColorFromRGB(kColor_val_infoText);
//    _contentView.font = [UIFont systemFontOfSize:kFontsize_untrain_content];
    _contentView.font = [UIFont fontWithName:kFont size:kFontsize_untrain_content];
    _contentView.text = @"疫苗接种前的注意事项：\n1、带好《儿童预防接种证》。这是宝宝接种疫苗的身份证明。当以后您为宝宝在办理入托、入学时都需要查验。\n2、和医生好好谈谈。如果有什么禁忌症和慎用症，让医生准确地知道，以便保护好宝宝的安全。\n3、给小宝洗澡。准备接种前一天给宝宝洗澡，当天最好穿清洁宽松的衣服，便于医生施种。\n4、如果小宝宝有不适，患有结核病、急性传染病、肾炎、心脏病、湿疹、免疫缺陷病、皮肤敏感者等需要暂缓接种。\n疫苗接种后的注意事项：\n1、接种注射疫苗后应当用棉签按住针眼几分钟，不出血时方可拿开棉签，不可揉搓接种部位。\n2、宝宝接种完疫苗以后不要马上回家，要在接种场所休息三十分钟左右，如果宝宝出现高热和其他不良反应， 可以及时请医生诊治。\n3、接种后让宝宝适当休息，多喝水，注意保暖，防止触发其它疾病。\n4、接种疫苗的当天不要给宝宝洗澡，但要保证接种部位的清洁，防止局部感染。\n5、口服脊灰疫苗后半小时内不能进食任何温、热的食物或饮品。接种百白破疫苗后若接种部位出现硬结，可在接种后第二天开始进行热敷以帮助硬结消退。\n6、接种疫苗后如果宝宝出现轻微发热、食欲不振、烦躁、哭闹的现象，不必担心，这些反应一般几天内会自动消失。但如果反应强烈且持续时间长，就应该立刻带宝宝去医院就诊。";
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _scrollView.height  = self.height-40;
    
    _contentView.height = _contentView.optimumSize.height;
    _scrollView.contentSize = CGSizeMake(0, _contentView.height);
    [_scrollView addSubview:_contentView];
    
}
@end
