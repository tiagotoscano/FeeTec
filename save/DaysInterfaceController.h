//
//  DaysInterfaceController.h
//  FreeTec
//
//  Created by Tiago Pinheiro on 08/01/16.
//  Copyright © 2016 Tiago Pinheiro. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>

@interface DaysInterfaceController : WKInterfaceController
@property (strong, nonatomic) IBOutlet WKInterfaceTable *daysTable;
@property (strong,nonatomic) NSArray * days;

@property(strong,nonatomic) NSMutableArray * jRetorno;
@property(strong,nonatomic) NSMutableArray * dadosTable;
@property(strong,nonatomic) NSMutableArray * allDay;
@end
