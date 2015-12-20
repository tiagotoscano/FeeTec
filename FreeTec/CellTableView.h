//
//  CellTableView.h
//  FreeTec
//
//  Created by Tiago Pinheiro on 18/12/15.
//  Copyright © 2015 Tiago Pinheiro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellTableView : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *labEixo;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewCurso;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *loadImg;
@property (strong, nonatomic) IBOutlet UIView *viewBg;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activeLoad;
@property (strong, nonatomic) IBOutlet UIView *viewSombra;

@property (strong, nonatomic) IBOutlet UILabel *labDay;
@end
