//
//  DetailInterfaceController.m
//  FreeTec
//
//  Created by Tiago Pinheiro on 09/01/16.
//  Copyright © 2016 Tiago Pinheiro. All rights reserved.
//

#import "DetailInterfaceController.h"

#import <WatchConnectivity/WatchConnectivity.h>

@interface DetailInterfaceController ()

@end

@implementation DetailInterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    self.dados = context[@"dados"];
    self.cpf = context[@"cpf"];
    
    [self.labTitle setText: self.dados[@"tema"]];
    NSLog(@"dados: %@",self.dados);
    
    if ([self.cpf isEqualToString:@""]) {
        [self.bntInsc setTitle:@"Não Cadastrado"];
        [self.bntInsc setEnabled:NO];
        self.update=@"false";
    }else{
        [self.bntInsc setTitle:@"Inscrever-se"];
        [self.bntInsc setEnabled:YES];
        self.update=@"false";
    }
    
    // Configure interface objects here.
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}
- (IBAction)actBtn {
    
    
    [self.bntInsc setEnabled:NO];
    [[WCSession defaultSession] sendMessage:@{@"action":@"INSCRICAO"
                                              ,@"curso_codigo":self.dados[@"id_curso"]
                                              ,@"horario_codigo":self.dados[@"id_horario"]
                                              ,@"confirmUpdHorario":self.update} replyHandler:^(NSDictionary *reply) {
        
        NSLog(@"Retonro %@",reply);
                                                  
        if ([reply[@"status"] isEqualToString:@"404"]) {
            
            [self.labRet setText:@"Falha: Comunicação"];
            [self.bntInsc setEnabled:YES];
            self.update=@"false";
            
        }else{
            if ([reply[@"status"] isEqualToString:@"000"]) {
                
                [self.labRet setText:reply[@"retorno"]];
                self.update=@"false";
                [WKInterfaceController reloadRootControllersWithNames:@[@"rootController"] contexts:@[@"callback"]];
            
            }else if([reply[@"status"] isEqualToString:@"103"]){
                
                [self.labRet setText:reply[@"retorno"]];
                [self.bntInsc setTitle:@"Mudar para Este Curso"];
                [self.bntInsc setEnabled:YES];
                self.update=@"true";
            }
            
            
        }
    } errorHandler:^(NSError * _Nonnull error) {
        
        [self.labRet setText:@"Falha: Comunicação"];
        
    }];
}

@end



