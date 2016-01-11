//
//  DaysRow.h
//  FreeTec
//
//  Created by Tiago Pinheiro on 08/01/16.
//  Copyright © 2016 Tiago Pinheiro. All rights reserved.
//
#import <WatchKit/WatchKit.h>

#import <Foundation/Foundation.h>

@interface DaysRow : NSObject
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *labDay;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *labData;

@end
