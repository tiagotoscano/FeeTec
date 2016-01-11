//
//  WKListagemController.m
//  FreeTec
//
//  Created by Tiago Pinheiro on 08/01/16.
//  Copyright © 2016 Tiago Pinheiro. All rights reserved.
//

#import "WKListagemController.h"
#import "ListagemRow.h"

@interface WKListagemController ()

@end

@implementation WKListagemController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    
    self.dadosTable = context[@"dados"];
    self.cpf = context[@"cpf"];
    
    //NSLog(@"dados rec: %@",self.dadosTable);
    
    [self loadData];
    
    // Configure interface objects here.
}

-(void) table:(WKInterfaceTable *)table didSelectRowAtIndex:(NSInteger)rowIndex{
    
    if(![self.dadosTable[rowIndex][@"matriculado"] isEqualToString:@"true"]){
        
        [self presentControllerWithName:@"details" context:@{@"dados":self.dadosTable[rowIndex],@"cpf":self.cpf}];
        
        
    }
    
}


-(void) loadData{
    
    [self.listTable setNumberOfRows:self.dadosTable.count withRowType:@"listRow"];
    
    for (int x =0; x<self.dadosTable.count; x++) {
        NSLog(@"entrou");
        ListagemRow * dayRow = [self.listTable rowControllerAtIndex:x];
        
        NSString * rgbValue =self.dadosTable[x][@"eixo_color"] ;

        
        [dayRow.labTitle setText: self.dadosTable[x][@"tema"] ];
        //NSLog(@"cpf : tela: -%@-",self.cpf);
        if (  [self.cpf isEqualToString:@"" ]){
            [dayRow.labTitle setTextColor:[self colorFromHexString:@"#FFFFFF"]];
        
            }else{
            
            if([self.dadosTable[x][@"matriculado"] isEqualToString:@"true"]){
                
                [dayRow.labTitle setTextColor:[self colorFromHexString:@"#FFFFFF"]];
            }else{
                [dayRow.labTitle setTextColor:[self colorFromHexString:@"#AAAAAA"]];
                
            }
            
            
            
        }
        
        [dayRow.s1 setColor:[self colorFromHexString:rgbValue]];
        [dayRow.s2 setColor:[self colorFromHexString:rgbValue]];
        [dayRow.s3 setColor:[self colorFromHexString:rgbValue]];
        [dayRow.s4 setColor:[self colorFromHexString:rgbValue]];
        [dayRow.s5 setColor:[self colorFromHexString:rgbValue]];
        
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

-(UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

@end



