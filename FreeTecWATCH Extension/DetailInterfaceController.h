//
//  DetailInterfaceController.h
//  FreeTec
//
//  Created by Tiago Pinheiro on 09/01/16.
//  Copyright © 2016 Tiago Pinheiro. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>

@interface DetailInterfaceController : WKInterfaceController
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *labTitle;
@property (strong, nonatomic) IBOutlet WKInterfaceButton *bntInsc;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *labRet;
@property(strong,nonatomic) NSString * update;
@property(strong,nonatomic) NSDictionary * dados;
@property(strong,nonatomic) NSString *cpf;

@end
