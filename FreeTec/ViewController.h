//
//  ViewController.h
//  FreeTec
//
//  Created by Tiago Pinheiro on 18/12/15.
//  Copyright © 2015 Tiago Pinheiro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "CellTableView.h"

@interface ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>


@property(strong,nonatomic) NSMutableArray * jRetorno;
@property(strong,nonatomic) NSMutableArray * dadosTable;
@property(strong,nonatomic) NSMutableArray * allDay;
@property(strong,nonatomic) MBProgressHUD * hud;
@property (strong, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;


@property (strong, nonatomic) IBOutlet UIView *view_Inscricao_Win;
@property (strong, nonatomic) IBOutlet UILabel *insc_labCurso;
@property (strong, nonatomic) IBOutlet UILabel *insc_labHorario;
@property(strong,nonatomic) NSString * insc_idCurso;
@property(strong,nonatomic) NSString * insc_idHorario;
@property (strong, nonatomic) IBOutlet UIButton *insc_Bnt;
@property(strong,nonatomic) CellTableView * insc_Cell;
@property (strong, nonatomic) IBOutlet UIButton *insc_bnt_Update;

@property (strong, nonatomic) IBOutlet UIView *view_Inscricao;

@property (strong, nonatomic) IBOutlet UIButton *bntLog;
@property(strong,nonatomic) NSString * CpfUser;
@property (strong, nonatomic) IBOutlet UILabel *labRetorno;


@end

