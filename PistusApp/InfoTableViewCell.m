//
//  InfoTableViewCell.m
//  PistusApp
//
//  Created by Lucie on 17/01/2016.
//  Copyright © 2016 Lucie. All rights reserved.
//

#import "InfoTableViewCell.h"

@implementation InfoTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (int) configUIWithTitle:(NSString*)titre date:(NSString *)date HTML:(NSString*)html{
    if(titreLabel!=nil){
        [titreLabel removeFromSuperview];
        titreLabel = nil;
    }
    if(dateLabel!=nil){
        [dateLabel removeFromSuperview];
        dateLabel = nil;
    }
    if(texte!=nil){
        [texte removeFromSuperview];
        texte = nil;
    }
    if(delimiteur!=nil){
        [delimiteur removeFromSuperview];
        delimiteur = nil;
    }
    titreLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, [UIScreen mainScreen].bounds.size.width-35, 26)];
    UIFont *font = [UIFont fontWithName:@"Times New Roman" size:20];
    UIFontDescriptor * fontD = [font.fontDescriptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold];
    [titreLabel setFont:[UIFont fontWithDescriptor:fontD size:0]];
    titreLabel.text = titre;
    titreLabel.adjustsFontSizeToFitWidth = YES;
    titreLabel.minimumScaleFactor = 0.8;
    [self addSubview:titreLabel];
    
    int supplement = 0;
    if(date!=nil)
    {
        dateLabel =  [[UILabel alloc] initWithFrame:CGRectMake(20, 35, [UIScreen mainScreen].bounds.size.width-50, 17)];
        [dateLabel setFont:[UIFont italicSystemFontOfSize:11]];
        dateLabel.text = date;
        supplement = 9;
        [self addSubview:dateLabel];
    }
    
    texte = [[UILabel alloc] initWithFrame:CGRectMake(20, 48+supplement, [UIScreen mainScreen].bounds.size.width-35, 500)];
    texte.numberOfLines = 0;
    NSError *err = nil;
    texte.attributedText =[[NSAttributedString alloc]initWithData: [html dataUsingEncoding:NSUTF16StringEncoding] options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
     documentAttributes: nil error: &err];
    if(err)
        NSLog(@"Unable to parse label text: %@", err);
    [texte sizeToFit];
    [self addSubview:texte];
    
    delimiteur = [[UIView alloc] initWithFrame:CGRectMake(0, texte.frame.size.height+35+supplement, [UIScreen mainScreen].bounds.size.width, 13)];
    delimiteur.backgroundColor = [UIColor colorWithRed:230.0/255 green:241.0/255 blue:252.0/255 alpha:1];
    [self addSubview:delimiteur];
    return (texte.frame.size.height + 48+supplement);
}

@end
