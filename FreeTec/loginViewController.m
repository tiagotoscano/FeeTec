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
#import <WatchConnectivity/WatchConnectivity.h>

@interface loginViewController ()<WCSessionDelegate>

@end

@implementation loginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"Got Didload");
    
    self.textCpf.mask = @"###.###.###-##";
    self.textCpf.delegate = self;
    self.textTelefone.delegate = self;
    
    
    self.textTelefone.mask = @"(##) #####-####";
    if ([WCSession isSupported]) {
        WCSession *session = [WCSession defaultSession];
        session.delegate = self;
        [session activateSession];
    }
    
    
    
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated{
    
    
    NSLog(@"cpf log will-%@",[[NSUserDefaults standardUserDefaults] stringForKey:@"cpfuser"]);
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"cpfuser"] !=nil) {
        
        [self sendPushkey];
        
        ViewController * view = [self.storyboard instantiateViewControllerWithIdentifier:@"Principal"];
        view.CpfUser = [[NSUserDefaults standardUserDefaults] stringForKey:@"cpfuser"];
        
        
        [self presentViewController:view animated:YES completion:^{
            ;
        }];
        
    }else{
        NSLog(@"Entrar no push");
        
        [self sendPushkey];
        
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
        
        [self sendPushkey];
        
        [[WCSession defaultSession] sendMessage:@{@"action":@"LOGIN"} replyHandler:^(NSDictionary *reply) {
        } errorHandler:^(NSError * _Nonnull error) {
        }];
        
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
            AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
            manager.securityPolicy.allowInvalidCertificates = YES;
            
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
            
            NSDictionary * params = @{@"cpf":self.textCpf.text,
                                      @"nome":self.textNome.text,
                                      @"email":self.textEmail.text,
                                      @"telefone":self.textTelefone.text};
            [manager POST:@"http://unibratec.edu.br/freetec2016/cadastroPessoaFreetec_mobile.php" parameters:params  constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                
            } progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSLog(@"Retorno: %@", responseObject);
                
                
                
                
                
                
                if ([responseObject[0][@"status"] isEqualToString:@"000"]) {
                    
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    
                    ViewController * view = [self.storyboard instantiateViewControllerWithIdentifier:@"Principal"];
                    view.CpfUser = self.textCpf.text;
                    
                    [[NSUserDefaults standardUserDefaults] setValue:self.textCpf.text forKey:@"cpfuser"];
                    
                    [self sendPushkey];
                    
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
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
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

-(BOOL) checkCampos{
    
    
    return (([self.textNome.text isEqualToString:@""]) ?  false :
            (([self.textEmail.text isEqualToString:@""]) ?  false :
             (([self.textTelefone.text isEqualToString:@""]) ?  false :
              true)));
    
    return true;
    
}

-(void) cancelHud{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
}





-(void) sendPushkey{
    
    
    if([[NSUserDefaults standardUserDefaults] stringForKey:@"keyNotification"] !=nil){
        
        NSLog(@"Push: %@",[[NSUserDefaults standardUserDefaults] stringForKey:@"keyNotification"]);
        
        AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
        manager.securityPolicy.allowInvalidCertificates = YES;
        
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
        
        NSString * strcpf;
        if([[NSUserDefaults standardUserDefaults] stringForKey:@"cpfuser"] ==nil)
            strcpf = @"";
        else
            strcpf =[[NSUserDefaults standardUserDefaults] stringForKey:@"cpfuser"];
        
        NSDictionary * params = @{@"cpf":strcpf,
                                  @"KEY_PUSH":[[NSUserDefaults standardUserDefaults] stringForKey:@"keyNotification"]
                                  };
        
        [manager POST:@"http://unibratec.edu.br/freetec2016/cadastroKeyIosFreetec.php" parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"4");
            
            //NSString* str = [NSString stringWithUTF8String:[responseObject cStringUsingEncoding:NSUTF8StringEncoding]];
            
            
            
            // responseObject;
            
            NSLog(@"JSON: %@ ",responseObject);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"Erro: %@",error);
        }];
        
    }
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    //Keyboard becomes visible
    
    
    [self.viewPromary setContentOffset:CGPointMake(0, 120) animated:YES];
    
    
    
    
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField {
    
    
    
    
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    //NSLog(@"entrou");
    [self.viewPromary setContentOffset:CGPointMake(0, 0) animated:YES];
    //self.viewPromary.contentSize = CGSizeMake(320,self.viewHeitght);
    
    [textField resignFirstResponder];
    
    return true;
    
}

- (void)session:(WCSession *)session didReceiveMessage:(NSDictionary<NSString *, id> *)message replyHandler:(void(^)(NSDictionary<NSString *, id> *replyMessage))replyHandler{
    
    if ([message[@"action"] isEqualToString:@"LOAD"]) {
        
        if ([[NSUserDefaults standardUserDefaults] stringForKey:@"cpfuser"]==nil) {
            
            
            NSString * cpfstr;
            
            
            cpfstr = @"";
            
            AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
            manager.securityPolicy.allowInvalidCertificates = YES;
            
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
            [manager GET:@"http://unibratec.edu.br/freetec2016/agendaFreetec_ios.php" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                
                
                replyHandler(@{@"cpf":@""
                               ,@"dados":responseObject});
                
                
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                replyHandler(@{@"cpf":@"ERRO"
                               ,@"dados":@""});
                
            }];
            
            
        }
    }
    
    
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
