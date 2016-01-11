//
//  DaysInterfaceController.m
//  FreeTec
//
//  Created by Tiago Pinheiro on 08/01/16.
//  Copyright © 2016 Tiago Pinheiro. All rights reserved.
//

#import "DaysInterfaceController.h"
#import "DaysRow.h"

@interface DaysInterfaceController ()

@end

@implementation DaysInterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    self.days = [[NSArray alloc] initWithObjects:
                 @"Segunda",
                 @"Terça",
                 @"Quarta",
                 @"Quinta",
                 @"Sexta",
                 @"Sabádo",
                 nil];
    NSLog(@"chegou");
    [self.daysTable setNumberOfRows:self.days.count withRowType:@"DaysRow"];
    
    for (int x =0; x<self.days.count; x++) {
        NSLog(@"entrou");
        DaysRow * dayRow = [self.daysTable rowControllerAtIndex:x];
        [dayRow.labDay setText:  self.days[x]];
        
    }
    [self getCalendar];
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
-(void) table:(WKInterfaceTable *)table didSelectRowAtIndex:(NSInteger)rowIndex{
    
    
    
    
}

-(void) getCalendar{
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration     defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject];
    NSURL * url = [[NSURL alloc] initWithString:@"http://unibratec.edu.br/freetec2016/agendaFreetec_ios.php"];
    NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithURL:url
                                       
    completionHandler:^(NSData *data,    NSURLResponse *response, NSError *error) {
        if(error == nil)
        {
        
            NSString * text = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
            NSLog(@"Data = %@",text);
        
        
        }
        
        
    }];
    [dataTask resume];
    
    
}

@end



