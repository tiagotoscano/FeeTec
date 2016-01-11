//
//  DaysInterfaceController.m
//  FreeTec
//
//  Created by Tiago Pinheiro on 08/01/16.
//  Copyright © 2016 Tiago Pinheiro. All rights reserved.
//

#import "DaysInterfaceController.h"
#import "DaysRow.h"
#import "WKListagemController.h"
#import "AFNetworking.h"
#import <WatchConnectivity/WatchConnectivity.h>

@interface DaysInterfaceController ()<WCSessionDelegate>

@property BOOL load;

@property BOOL erro;

@end

@implementation DaysInterfaceController



- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    self.load =YES;
    self.erro =NO;
    NSLog(@"context- %@ -",context);
    if ([WCSession isSupported]) {
       
        WCSession * session = [WCSession defaultSession];
        session.delegate = self;
        
        [session activateSession];
        if (![context isEqualToString:@"callback"]) {
            [self getCalendar];
            
        }
        
    
    }
    
    
    // Configure interface objects here.
    
}
-(void) getCalendar{
    
    [self.daysTable setNumberOfRows:1 withRowType:@"DaysRow"];
    DaysRow * dayRow = [self.daysTable rowControllerAtIndex:0];
    [dayRow.labDay setText: @"Loading..."];
    [dayRow.labData setText: @""];
    self.load = YES;
    self.cpf = @"";
    
   
        
        NSLog(@"entrou");
        
        [[WCSession defaultSession] sendMessage:@{@"action":@"LOAD"} replyHandler:^(NSDictionary *reply) {
            
            NSLog(@"Retonro");
            if ([reply[@"cpf"] isEqualToString:@"ERRO"]) {
                
                [dayRow.labDay setText: @"Falha Comunicação"];
                [dayRow.labData setText: @"01"];
                self.erro =YES;
                
            }else{
                
                self.cpf=reply[@"cpf"];
                NSLog(@"Entrou REtonro");
                self.dadosTable = reply[@"dados"];
                
                self.jRetorno = self.dadosTable;
                
                self.allDay = [self.jRetorno valueForKeyPath:@"@distinctUnionOfObjects.dataHora"];
                
                
                self.allDay =
                [self.allDay sortedArrayUsingSelector:@selector(compare:)];
                
                
                // NSLog(@"JSON: %@ - %lu",self.allDay,(unsigned long)self.allDay.count);
                [self loadData];
                
            }
        } errorHandler:^(NSError * _Nonnull error) {
            [dayRow.labDay setText: @"Falha Comunicação"];
            [dayRow.labData setText: @"00"];
            self.erro =YES;
            
        }];
        
    
    
}
- (void)session:(WCSession *)session didReceiveMessage:(NSDictionary<NSString *, id> *)message replyHandler:(void(^)(NSDictionary<NSString *, id> *replyMessage))replyHandler{
    
    if ([message[@"action"] isEqualToString:@"LOGIN"]) {
        
        [WKInterfaceController reloadRootControllersWithNames:@[@"rootController"] contexts:@[@"callback"]];
        
    
    }else{
        NSLog(@"RECEBER MSG");
        [self getCalendar];
    }
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    
    
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}
-(void) table:(WKInterfaceTable *)table didSelectRowAtIndex:(NSInteger)rowIndex{
    
   
    
    if (!self.load) {
        
        if (self.erro) {
            [self getCalendar];
        }
        
        NSString * strData = self.allDay[rowIndex];
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"dataHora==%@",strData];
        self.dadosTable  = [self.jRetorno filteredArrayUsingPredicate:predicate];
        
        
        [self presentControllerWithName:@"Listagem" context:@{@"dados":self.dadosTable,@"cpf":self.cpf}];
    }
    
    
}

-(void) loadData{
    [self.daysTable setNumberOfRows:self.allDay.count withRowType:@"DaysRow"];
    
    for (int x =0; x<self.allDay.count; x++) {
        //NSLog(@"entrou");
        DaysRow * dayRow = [self.daysTable rowControllerAtIndex:x];
        
        NSString * strData = self.allDay[x];
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"dataHora==%@",strData];
        NSArray * filteredarray  = [self.jRetorno filteredArrayUsingPredicate:predicate];
        
        [dayRow.labDay setText: filteredarray[0][@"horariodesc"] ];
        NSString * datastr = filteredarray[0][@"data"];
        //NSLog(@"Data %@",datastr);
        datastr = [datastr substringFromIndex:8];
        
        [dayRow.labData setText: [NSString stringWithFormat:@"%@ JAN",datastr ]];
        
        
    }
    self.load =NO;
}

//-(void) getCalendar{
//    NSLog(@"entrou get");
//    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
//    manager.securityPolicy.allowInvalidCertificates = YES;
//
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
//    [manager GET:@"http://unibratec.edu.br/freetec2016/agendaFreetec_ios.php" parameters:@{@"CPF_INSCRITO":self.cpf} progress:^(NSProgress * _Nonnull downloadProgress) {
//
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//
//
//        //NSString* str = [NSString stringWithUTF8String:[responseObject cStringUsingEncoding:NSUTF8StringEncoding]];
//
//
//
//        self.jRetorno = responseObject;
//
//        //NSLog(@"JSON: %@ ",self.jRetorno);
//
//
//        self.dadosTable = responseObject;
//
//
//        self.allDay = [self.jRetorno valueForKeyPath:@"@distinctUnionOfObjects.dataHora"];
//
//
//        self.allDay =
//        [self.allDay sortedArrayUsingSelector:@selector(compare:)];
//
//
//        // NSLog(@"JSON: %@ - %lu",self.allDay,(unsigned long)self.allDay.count);
//        [self loadData];
//
//        //[self reloadAllpin];
//
//
//
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"Erro: %@",error);
//    }];
//    
//    
//    
//}
- (IBAction)actionAtualizar {
    
    [self getCalendar];
}

@end



