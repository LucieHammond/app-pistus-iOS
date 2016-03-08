//
//  GraphTableViewCell.m
//  PistusApp
//
//  Created by Lucie on 16/01/2016.
//  Copyright © 2016 Lucie. All rights reserved.
//

#import "GraphTableViewCell.h"
#import "GeolocalisationManager.h"
#import "UUChart.h"

@interface GraphTableViewCell ()<UUChartDataSource>
{
    NSIndexPath *path;
    UUChart *chartView;
}
@end

@implementation GraphTableViewCell

- (void)configUI:(NSIndexPath *)indexPath
{
    if (chartView) {
        [chartView removeFromSuperview];
        chartView = nil;
    }
    
    path = indexPath;
    
    chartView = [[UUChart alloc]initwithUUChartDataFrame:CGRectMake(10, 10, [UIScreen mainScreen].bounds.size.width-20, 150) withSource:self withStyle:UUChartLineStyle];
    chartView.backgroundColor = [[UIColor alloc] initWithRed:1 green:1 blue:1 alpha:0.5];
    [chartView showInView:self.contentView];
}

#pragma mark - @required

- (NSArray *)UUChart_xLableArray:(UUChart *)chart
{
    return @[@"samedi",@"dimanche",@"lundi",@"mardi",@"mercredi",@"jeudi",@"vendredi"];
}

- (NSArray *)UUChart_yValueArray:(UUChart *)chart
{
    // On calcule les valeurs à afficher
    GeolocalisationManager *gm = [GeolocalisationManager sharedInstance];
    NSArray *vitesse;
    NSArray *distance;
    NSArray *temps;

    NSLog(@"%@",gm.tabNbPositions );
    NSLog(@"%@",gm.tabNbPositions[0] );
    if([gm.tabNbPositions[0] floatValue]>0)
        vitesse5 = [gm.tabVitesseCumulee[0] floatValue]/[gm.tabNbPositions[0] floatValue];
    else
        vitesse5 = 0;
    NSString *v5 = [NSString stringWithFormat:@"%f",vitesse5];
    if([gm.tabNbPositions[1] floatValue] - [gm.tabNbPositions[0] floatValue]>0)
        vitesse6 = ([gm.tabVitesseCumulee[1] floatValue]-[gm.tabVitesseCumulee[0] floatValue])/([gm.tabNbPositions[1] floatValue]-[gm.tabNbPositions[0] floatValue]);
    else
        vitesse6 = 0;
    NSString *v6 = [NSString stringWithFormat:@"%f",vitesse6];
    if(([gm.tabNbPositions[2] floatValue] - [gm.tabNbPositions[1] floatValue])>0)
        vitesse7 = ([gm.tabVitesseCumulee[2] floatValue]-[gm.tabVitesseCumulee[1] floatValue])/([gm.tabNbPositions[2] floatValue]-[gm.tabNbPositions[1] floatValue]);
    else
        vitesse7 = 0;
    NSString *v7 = [NSString stringWithFormat:@"%f",vitesse7];
    if(([gm.tabNbPositions[3] floatValue] - [gm.tabNbPositions[2] floatValue])>0)
        vitesse8 = ([gm.tabVitesseCumulee[3] floatValue]-[gm.tabVitesseCumulee[2] floatValue])/([gm.tabNbPositions[3] floatValue]-[gm.tabNbPositions[2] floatValue]);
    else
        vitesse8 = 0;
    NSString *v8 = [NSString stringWithFormat:@"%f",vitesse8];
    if(([gm.tabNbPositions[4] floatValue] - [gm.tabNbPositions[3] floatValue])>0)
        vitesse9 = ([gm.tabVitesseCumulee[4] floatValue]-[gm.tabVitesseCumulee[3] floatValue])/([gm.tabNbPositions[4] floatValue]-[gm.tabNbPositions[3] floatValue]);
    else
        vitesse9 = 0;
    NSString *v9 = [NSString stringWithFormat:@"%f",vitesse9];
    if(([gm.tabNbPositions[5] floatValue] - [gm.tabNbPositions[4] floatValue])>0)
        vitesse10 = ([gm.tabVitesseCumulee[5] floatValue]-[gm.tabVitesseCumulee[4] floatValue])/([gm.tabNbPositions[5] floatValue]-[gm.tabNbPositions[4] floatValue]);
    else
        vitesse10 = 0;
    NSString *v10 = [NSString stringWithFormat:@"%f",vitesse10];
    if(([gm.tabNbPositions[6] floatValue] - [gm.tabNbPositions[5] floatValue])>0)
        vitesse11 = ([gm.tabVitesseCumulee[6] floatValue]-[gm.tabVitesseCumulee[5] floatValue])/([gm.tabNbPositions[6] floatValue]-[gm.tabNbPositions[5] floatValue]);
    else
        vitesse11 = 0;
    NSString *v11 = [NSString stringWithFormat:@"%f",vitesse11];
    if([gm.tabVitesseCumulee[0] floatValue]==-1)
        vitesse = @[];
    else if([gm.tabVitesseCumulee[1] floatValue]==-1)
        vitesse = @[v5];
    else if([gm.tabVitesseCumulee[2] floatValue]==-1)
        vitesse = @[v5,v6];
    else if([gm.tabVitesseCumulee[3] floatValue]==-1)
        vitesse = @[v5,v6,v7];
    else if([gm.tabVitesseCumulee[4] floatValue]==-1)
        vitesse = @[v5,v6,v7,v8];
    else if([gm.tabVitesseCumulee[5] floatValue]==-1)
        vitesse = @[v5,v6,v7,v8,v9];
    else if([gm.tabVitesseCumulee[6] floatValue]==-1)
        vitesse = @[v5,v6,v7,v8,v9,v10];
    else
        vitesse = @[v5,v6,v7,v8,v9,v10,v11];
    
    
    distance5 = [gm.tabDistance[0] floatValue];
    NSString *d5 = [NSString stringWithFormat:@"%f",distance5/1000];
    distance6 = [gm.tabDistance[1] floatValue] - [gm.tabDistance[0] floatValue];
    NSString *d6 = [NSString stringWithFormat:@"%f",distance6/1000];
    distance7 = [gm.tabDistance[2] floatValue] - [gm.tabDistance[1] floatValue];
    NSString *d7 = [NSString stringWithFormat:@"%f",distance7/1000];
    distance8 = [gm.tabDistance[3] floatValue] - [gm.tabDistance[2] floatValue];
    NSString *d8 = [NSString stringWithFormat:@"%f",distance8/1000];
    distance9 = [gm.tabDistance[4] floatValue] - [gm.tabDistance[3] floatValue];
    NSString *d9 = [NSString stringWithFormat:@"%f",distance9/1000];
    distance10 = [gm.tabDistance[5] floatValue] - [gm.tabDistance[4] floatValue];
    NSString *d10 = [NSString stringWithFormat:@"%f",distance10/1000];
    distance11 = [gm.tabDistance[6] floatValue] - [gm.tabDistance[5] floatValue];
    NSString *d11 = [NSString stringWithFormat:@"%f",distance11/1000];
    if(distance5<0)
        distance = @[];
    else if(distance6<0)
        distance = @[d5];
    else if(distance7<0)
        distance = @[d5,d6];
    else if(distance8<0)
        distance = @[d5,d6,d7];
    else if(distance9<0)
        distance = @[d5,d6,d7,d8];
    else if(distance10<0)
        distance = @[d5,d6,d7,d8,d9];
    else if(distance11<0)
        distance = @[d5,d6,d7,d8,d9,d10];
    else
        distance = @[d5,d6,d7,d8,d9,d10,d11];
    
    temps5 = [gm.tabTemps[0] floatValue];
    NSString *t5 = [NSString stringWithFormat:@"%.2f",temps5];
    temps6 = [gm.tabTemps[1] floatValue] - [gm.tabTemps[0] floatValue];
    NSString *t6 = [NSString stringWithFormat:@"%.2f",temps6];
    temps7 = [gm.tabTemps[2] floatValue] - [gm.tabTemps[1] floatValue];
    NSString *t7 = [NSString stringWithFormat:@"%.2f",temps7];
    temps8 = [gm.tabTemps[3] floatValue] - [gm.tabTemps[2] floatValue];
    NSString *t8 = [NSString stringWithFormat:@"%.2f",temps8];
    temps9 = [gm.tabTemps[4] floatValue] - [gm.tabTemps[3] floatValue];
    NSString *t9 = [NSString stringWithFormat:@"%.2f",temps9];
    temps10 = [gm.tabTemps[5] floatValue] - [gm.tabTemps[4] floatValue];
    NSString *t10 = [NSString stringWithFormat:@"%.2f",temps10];
    temps11 = [gm.tabTemps[6] floatValue] - [gm.tabTemps[5] floatValue];
    NSString *t11 = [NSString stringWithFormat:@"%.2f",temps11];
    if(temps5<0)
        temps = @[];
    else if(temps6<0)
        temps = @[t5];
    else if(temps7<0)
        temps = @[t5,t6];
    else if(temps8<0)
        temps = @[t5,t6,t7];
    else if(temps9<0)
        temps = @[t5,t6,t7,t8];
    else if(temps10<0)
        temps = @[t5,t6,t7,t8,t9];
    else if(temps11<0)
        temps = @[t5,t6,t7,t8,t9,t10];
    else
        temps = @[t5,t6,t7,t8,t9,t10,t11];
    
    // On affiche ces valeurs
    switch (path.section) {
        case 0:
            return @[vitesse];
            break;
        case 1:
            return @[distance];
            break;
        case 2:
            return @[temps];
            break;
        default:
            return @[@[@"0",@"0",@"0",@"0",@"0",@"0",@"0"]];
    }
}

#pragma mark - @optional

- (NSArray *)UUChart_ColorArray:(UUChart *)chart
{
    return @[UUGreen,UURed,UUBrown];
}

- (CGRange)UUChartChooseRangeInLineChart:(UUChart *)chart
{
    if (path.section==0) {
        return CGRangeMake(150, 0);
    }
    else if (path.section==1) {
        return CGRangeMake(100, 0);
    }
    else if(path.section==2){
        return CGRangeMake(10, 0);
    }
    else{
        return CGRangeZero;
    }
}

#pragma mark

- (CGRange)UUChartMarkRangeInLineChart:(UUChart *)chart
{
    return CGRangeZero;
}

- (BOOL)UUChart:(UUChart *)chart ShowHorizonLineAtIndex:(NSInteger)index
{
    return YES;
}

- (BOOL)UUChart:(UUChart *)chart ShowMaxMinAtIndex:(NSInteger)index
{
    return YES;
}

@end
