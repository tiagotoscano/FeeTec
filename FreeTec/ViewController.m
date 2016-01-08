//
//  ViewController.m
//  FreeTec
//
//  Created by Tiago Pinheiro on 18/12/15.
//  Copyright © 2015 Tiago Pinheiro. All rights reserved.
//

#import "ViewController.h"
#import "CellTableView.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"

#import "CellColletionView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if(!self.CpfUser)
        self.CpfUser = @"";
    
    [self getDados];
    
    self.view_Inscricao_Win.layer.cornerRadius = 10;
    
    
    
    
    
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)viewDidAppear:(BOOL)animated{

    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"cpfuser"] ==nil) {
        //NSLog(@"entrou1");
        self.bntLog.imageView.image =[UIImage imageNamed:@"login"];
    }else{
    
        //NSLog(@"entrou2");
        self.bntLog.imageView.image =[UIImage imageNamed:@"logout"];
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dadosTable.count;
}
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    

    CellTableView * cell =[tableView dequeueReusableCellWithIdentifier:@"cellCursos"];
    
    
    
    
    if ([self.CpfUser isEqualToString:@""]) {
        
        cell.viewSombra.hidden = YES;
        
    }else{
        //NSLog(@"Status - %@",self.dadosTable[indexPath.row][@"matriculado"] );
        if([self.dadosTable[indexPath.row][@"matriculado"] isEqualToString:@"true"]){
            cell.viewSombra.hidden = YES;
        }else{
            cell.viewSombra.hidden = NO;
            
        }
    
    }
    
    [self addGestureRecognizeMap:cell.viewSombra];
    
    cell.labEixo.text =self.dadosTable[indexPath.row][@"tema"]  ;
    NSString * rgbValue =self.dadosTable[indexPath.row][@"eixo_color"] ;
    [cell.viewBg setBackgroundColor:[self colorFromHexString:rgbValue]];
    cell.labDay.text=self.dadosTable[indexPath.row][@"horariodesc"]  ;
    
    
    NSString *strUrl = [[NSString alloc]  initWithFormat:@"http://unibratec.edu.br/freetec2016/getImg.php?ID_CURSO=%@&tipodaimg=.jpg",self.dadosTable[indexPath.row][@"id_curso"] ];
    NSURL *url = [NSURL URLWithString:strUrl];
    cell.imageViewCurso.image = [UIImage imageNamed:@"load"];
    [cell.activeLoad startAnimating];
    cell.activeLoad.hidden = false;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:strUrl]];
        dispatch_async(dispatch_get_main_queue(), ^{
        
            [cell.imageViewCurso setImage:[UIImage imageWithData:data]];
            [cell.activeLoad stopAnimating];
            cell.activeLoad.hidden = true;
        });
        
    });
    
    
    
    return cell;
    
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    if(self.allDay.count>0)
        return (self.allDay.count+1);
    else
        return 0;
}

-(UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CellColletionView * cellCollection =[collectionView dequeueReusableCellWithReuseIdentifier:@"cellDay" forIndexPath:indexPath];
    cellCollection.layer.cornerRadius = 10;
    
    
    if(indexPath.row<self.allDay.count){
        NSString * strData = self.allDay[indexPath.row];
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"dataHora==%@",strData];
        NSArray * filteredarray  = [self.jRetorno filteredArrayUsingPredicate:predicate];
        
        cellCollection.labDay.text = filteredarray[0][@"horariodesc"];
        
    }else{
        
        cellCollection.labDay.text = @"Todos";
        //NSLog(@"entrou");
        
        
    }
    cellCollection.layer.borderWidth = 1.5f;
    cellCollection.layer.borderColor=[UIColor grayColor].CGColor;
    
    return cellCollection;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    CellColletionView * cellCollection =[collectionView cellForItemAtIndexPath:indexPath];
    
    if(indexPath.row<self.allDay.count){
        
        NSString * strData = self.allDay[indexPath.row];
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"dataHora==%@",strData];
        self.dadosTable  = [self.jRetorno filteredArrayUsingPredicate:predicate];
        
        [self.tableview reloadData];
    }else{
        NSSortDescriptor *sortDescriptor;
        sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dataHora"
                                                     ascending:YES];
        
        NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
        
        self.dadosTable  = [self.jRetorno sortedArrayUsingDescriptors:sortDescriptors];
        [self.tableview reloadData];
        
        
    }
    
    cellCollection.contentView.backgroundColor = [UIColor grayColor];
    cellCollection.labDay.textColor =[UIColor whiteColor];
    
    
    
    
    
    
    
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CellColletionView * cellCollection =[collectionView cellForItemAtIndexPath:indexPath];
    
    cellCollection.contentView.backgroundColor = [UIColor whiteColor];
    cellCollection.labDay.textColor =[UIColor blackColor];

}



// Chamada de dados


-(void) getDados{
    
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.mode = MBProgressHUDModeIndeterminate;
    //hub.mode = MBProgressHUDModeText;
    self.hud.labelText = @"Recebendo dados!";
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager  manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    [manager GET:@"http://unibratec.edu.br/freetec2016/agendaFreetec_ios.php" parameters:@{@"CPF_INSCRITO":self.CpfUser} success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        
        //NSString* str = [NSString stringWithUTF8String:[responseObject cStringUsingEncoding:NSUTF8StringEncoding]];
        
        
        
        self.jRetorno = responseObject;
        
        //NSLog(@"JSON: %@ ",self.jRetorno);
        
        
        self.dadosTable = responseObject;
        
        
        self.allDay = [self.jRetorno valueForKeyPath:@"@distinctUnionOfObjects.dataHora"];
       
        
        self.allDay =
        [self.allDay sortedArrayUsingSelector:@selector(compare:)];
        
        
       // NSLog(@"JSON: %@ - %lu",self.allDay,(unsigned long)self.allDay.count);
        
        
        //[self reloadAllpin];
        [self.collectionView reloadData];
        [self.tableview reloadData];
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"Erro: %@",error);
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
    }];
    
    
}
- (IBAction)bntLogin:(id)sender {
    
    
        [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"cpfuser"];
        [self dismissViewControllerAnimated:YES completion:^{
            
            
        }];
    
    
    
}

-(UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}


-(void)addGestureRecognizeMap:(UIView *) view{
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openInscricao:)];
    
    tapGesture.numberOfTapsRequired = 1;
    
    
    
    
    [view addGestureRecognizer:tapGesture];
}


-(void)openInscricao:(id) sender{
    
    //UIGestureRecognizer * tap
    
    
    UIView * view = [sender view];
    while (![view isKindOfClass:[CellTableView class]]) {
        
        view= [view superview];
        
    }
    NSIndexPath * index = [self.tableview indexPathForCell:(CellTableView *) view];
    
    self.insc_labCurso.text = self.dadosTable[index.row][@"tema"];
    self.insc_labHorario.text = self.dadosTable[index.row][@"horariodesc"];
    
    self.insc_idCurso=self.dadosTable[index.row][@"id_curso"];
    self.insc_idHorario=self.dadosTable[index.row][@"id_horario"];
    self.insc_Cell = (CellTableView *) view;
    
    self.view_Inscricao.hidden=NO;
    //self.seletedIndexClick = index.row;
    
    //[self likeByid:index.row  andCell:(PhotoTableViewCell*)view];
}

- (IBAction)bntClose:(id)sender {
    
    NSLog(@"FECHAR");
    self.view_Inscricao.hidden=YES;
    self.insc_Bnt.hidden = NO;
    self.insc_bnt_Update.hidden=YES;
    self.labRetorno.hidden = YES;
    
    
}

- (IBAction)bntInscricao:(id)sender {
    
    
    
    [self saveInscricao:@"false"];
    
    
    
}

- (IBAction)bnt_Inscricao_Update:(id)sender {
    
    
    [self saveInscricao:@"true"];
    
    
}

-(void) saveInscricao:(NSString *)update{

    
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.mode = MBProgressHUDModeIndeterminate;
    //hub.mode = MBProgressHUDModeText;
    self.hud.labelText = @"Efetuando Alteração!";
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager  manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    
    NSDictionary * params = @{@"cpf":self.CpfUser,
                              @"confirmUpdHorario":update,
                              @"curso_codigo":self.insc_idCurso,
                              @"horario_codigo":self.insc_idHorario};
    
    [manager POST:@"http://unibratec.edu.br/freetec2016/cadastroFreetec_mobile.php" parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        
        //NSString* str = [NSString stringWithUTF8String:[responseObject cStringUsingEncoding:NSUTF8StringEncoding]];
        
        
        
        // responseObject;
        
        NSLog(@"JSON: %@ ",responseObject);
        
        
        
        
        // NSLog(@"JSON: %@ - %lu",self.allDay,(unsigned long)self.allDay.count);
        
        self.labRetorno.text = responseObject[0][@"Msg"];
        self.labRetorno.hidden = NO;
        self.insc_Bnt.hidden = YES;
        self.insc_bnt_Update.hidden = YES;
        
        if ([responseObject[0][@"status"] isEqualToString:@"000"]) {
            
            [self getDados];
            
        }
        
        if ([responseObject[0][@"status"] isEqualToString:@"103"]) {
            
            
            self.insc_bnt_Update.hidden = NO;
            
            
        }
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"Erro: %@",error);
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
    }];
    
    
}





@end
