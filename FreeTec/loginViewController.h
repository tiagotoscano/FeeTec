//
//  loginViewController.h
//  FreeTec
//
//  Created by Tiago Pinheiro on 20/12/15.
//  Copyright © 2015 Tiago Pinheiro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VMaskTextField.h"
#import "MBProgressHUD.h"

@interface loginViewController : UIViewController<UITextFieldDelegate>


@property(strong,nonatomic) MBProgressHUD * hud;
@property (strong, nonatomic) IBOutlet VMaskTextField *textCpf;
@property (strong, nonatomic) IBOutlet VMaskTextField *textNome;
@property (strong, nonatomic) IBOutlet VMaskTextField *textTelefone;
@property (strong, nonatomic) IBOutlet VMaskTextField *textEmail;

@end
