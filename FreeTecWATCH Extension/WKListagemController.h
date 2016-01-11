//
//  WKListagemController.h
//  FreeTec
//
//  Created by Tiago Pinheiro on 08/01/16.
//  Copyright © 2016 Tiago Pinheiro. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>

@interface WKListagemController : WKInterfaceController

@property(strong,nonatomic) NSMutableArray * dadosTable;
@property (strong, nonatomic) IBOutlet WKInterfaceTable *listTable;
@property(strong,nonatomic) NSString *cpf;

@end
