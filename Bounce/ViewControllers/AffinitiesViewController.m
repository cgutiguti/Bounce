//
//  AffinitiesViewController.m
//  Bounce
//
//  Created by Carmen Gutierrez on 7/23/20.
//  Copyright © 2020 Carmen Gutierrez. All rights reserved.
//

#import "AffinitiesViewController.h"
#import "AAChartKit.h"

@interface AffinitiesViewController ()

@end

@implementation AffinitiesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    AASeriesElement *element = AASeriesElement.new
    .nameSet(@"语言热度值")
    .innerSizeSet(@"20%")//内部圆环半径大小占比
    .sizeSet(@200)//尺寸大小
    .borderWidthSet(@0)//描边的宽度
    .allowPointSelectSet(true)//是否允许在点击数据点标记(扇形图点击选中的块发生位移)
    .statesSet(AAStates.new
               .hoverSet(AAHover.new
                         .enabledSet(false)//禁用点击区块之后出现的半透明遮罩层
                         ))
    .dataSet(@[
        @[@"Firefox",   @3336.2],
        @[@"IE",          @26.8],
        @{@"sliced": @true,
          @"selected": @true,
          @"name": @"Chrome",
          @"y": @666.8,        },
        @[@"Safari",      @88.5],
        @[@"Opera",       @46.0],
        @[@"Others",     @223.0],
    ]);
    AAChartModel *aaChartModel = AAChartModel.new
    .chartTypeSet(AAChartTypePie)
    .colorsThemeSet(@[@"#0c9674",@"#7dffc0",@"#ff3333",@"#facd32",@"#ffffa0",@"#EA007B"])
    .dataLabelsEnabledSet(true)//是否直接显示扇形图数据
    .yAxisTitleSet(@"摄氏度")
    .seriesSet(@[element]);

    // Do any additional setup after loading the view.
    CGFloat chartViewWidth  = self.view.frame.size.width;
    CGFloat chartViewHeight = self.view.frame.size.height-250;
    AAChartView *aaChartView = [[AAChartView alloc] init];
    aaChartView.frame = CGRectMake(0, 60, chartViewWidth, chartViewHeight);
    //_aaChartView.scrollEnabled = NO;
    //// set the content height of aaChartView
    // _aaChartView.contentHeight = chartViewHeight;
    [self.view addSubview:aaChartView];
    [aaChartView aa_drawChartWithChartModel:aaChartModel];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
