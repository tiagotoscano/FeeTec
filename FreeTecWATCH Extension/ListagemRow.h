//
//  ListagemRow.h
//  FreeTec
//
//  Created by Tiago Pinheiro on 08/01/16.
//  Copyright © 2016 Tiago Pinheiro. All rights reserved.
//
#import <WatchKit/WatchKit.h>

#import <Foundation/Foundation.h>

@interface ListagemRow : NSObject
@property (strong, nonatomic) IBOutlet WKInterfaceSeparator *s1;
@property (strong, nonatomic) IBOutlet WKInterfaceSeparator *s2;
@property (strong, nonatomic) IBOutlet WKInterfaceSeparator *s3;
@property (strong, nonatomic) IBOutlet WKInterfaceSeparator *s4;
@property (strong, nonatomic) IBOutlet WKInterfaceSeparator *s5;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *labTitle;
@end
