//
//  loginViewController.m
//  FreeTec
//
//  Created by Tiago Pinheiro on 20/12/15.
//  Copyright © 2015 Tiago Pinheiro. All rights reserved.
//

#import "loginViewController.h"
#import "ViewController.h"
#import "AFNetworking.h"
#import "CWSBrasilValidate.h"

@interface loginViewController ()

@end

@implementation loginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textCpf.mask = @"###.###.###-##";
    self.textCpf.delegate = self;
    self.textTelefone.delegate = self;
    
    
    self.textTelefone.mask = @"(##) #####-####";
    
    
    
    
    // Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated{


    NSLog(@"cpf log will-%@",[[NSUserDefaults standardUserDefaults] stringForKey:@"cpfuser"]);
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"cpfuser"] !=nil) {
        
        ViewController * view = [self.storyboard instantiateViewControllerWithIdentifier:@"Principal"];
        view.CpfUser = [[NSUserDefaults standardUserDefaults] stringForKey:@"cpfuser"];
        
        
        [self presentViewController:view animated:YES completion:^{
            ;
        }];
        
    }

}
-(void)viewWillAppear:(BOOL)animated{
    
    
}

- (void)didReceiveMemoryWarning {

    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if(([textField isEqual:self.textNome])||([textField isEqual:self.textEmail])){
        return true;
    }else{
        VMaskTextField * maskTextField = (VMaskTextField*) textField;
        return  [maskTextField shouldChangeCharactersInRange:range replacementString:string];
    }

}
- (IBAction)bntLogin:(id)sender {
    
    
    if (![self.textCpf.text isEqualToString:@""]) {
        
        ViewController * view = [self.storyboard instantiateViewControllerWithIdentifier:@"Principal"];
        view.CpfUser = self.textCpf.text;
        
        [[NSUserDefaults standardUserDefaults] setValue:self.textCpf.text forKey:@"cpfuser"];
        
        
        [self presentViewController:view animated:YES completion:^{
            ;
        }];
        
        
    
    }
    
    
}
- (IBAction)bntIr:(id)sender {
    
    ViewController * view = [self.storyboard instantiateViewControllerWithIdentifier:@"Principal"];
    view.CpfUser = @"";
    [self presentViewController:view animated:YES completion:^{
        ;
    }];

    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return true;
    
}
- (IBAction)bntCadastro:(id)sender {
    
    NSString *strcpf = self.textCpf.text;
    
    strcpf = [[strcpf
               stringByReplacingOccurrencesOfString:@"."
               withString:@""]
              stringByReplacingOccurrencesOfString:@"-"
              withString:@""];
    BOOL valido = [CWSBrasilValidate validarCPF: strcpf];
    if(valido){
        
        if ([self checkCampos]) {
            
            self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            self.hud.mode = MBProgressHUDModeIndeterminate;
            
            //self.hud.mode = MBProgressHUDModeText;
            self.hud.labelText = @"Efetuando cadastro.";
            
            AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager  manager];
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
            
            NSDictionary * params = @{@"cpf":self.textCpf.text,
                                      @"nome":self.textNome.text,
                                      @"email":self.textEmail.text,
                                      @"telefone":self.textTelefone.text};
            
            [manager POST:@"http://unibratec.edu.br/freetec2016/cadastroPessoaFreetec_mobile.php" parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                
                
                NSLog(@"Retorno: %@", responseObject);
                
                
                
                
                
                
                if ([responseObject[0][@"status"] isEqualToString:@"000"]) {
                    
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    
                    ViewController * view = [self.storyboard instantiateViewControllerWithIdentifier:@"Principal"];
                    view.CpfUser = self.textCpf.text;
                    
                    [[NSUserDefaults standardUserDefaults] setValue:self.textCpf.text forKey:@"cpfuser"];
                    
                    
                    [self presentViewController:view animated:YES completion:^{
                        ;
                    }];
                    
                    
                }
                
                if ([responseObject[0][@"status"] isEqualToString:@"101"]) {
                    
                    
                    self.hud.labelText = @"ERRO NO CADASTRO!";
                    
                    [self.hud addGestureRecognizer: [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelHud)]];
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    });
                    
                    
                }
                
                
                
                
            } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
                NSLog(@"Erro: %@",error);
                self.hud.labelText = @"ERRO NO CADASTRO!";
                
                [self.hud addGestureRecognizer: [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelHud)]];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                });
            }];
            
        }else{
            
            self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            //self.hud.mode = MBProgressHUDModeIndeterminate;
            
            self.hud.mode = MBProgressHUDModeText;
            self.hud.labelText = @"Erro: Campo(s) Incompleto(s)!";
            
            [self.hud addGestureRecognizer: [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelHud)]];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            });
            
        }
        
        
    }else{
        self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        //self.hud.mode = MBProgressHUDModeIndeterminate;
        
        self.hud.mode = MBProgressHUDModeText;
        self.hud.labelText = @"ERRO CPF INVALIDO!";
        
        [self.hud addGestureRecognizer: [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelHud)]];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        });
    
    };
    
}

-(void) cancelHud{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
}

-(BOOL) checkCampos{
    
    
    return (([self.textNome.text isEqualToString:@""]) ?  false :
     (([self.textEmail.text isEqualToString:@""]) ?  false :
      (([self.textTelefone.text isEqualToString:@""]) ?  false :
        true)));
    
    return true;
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
