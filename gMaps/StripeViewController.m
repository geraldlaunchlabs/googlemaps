//
//  StripeViewController.m
//  gMaps
//
//  Created by LLDM on 15/08/2016.
//  Copyright © 2016 LLDM. All rights reserved.
//

#import "StripeViewController.h"

@interface StripeViewController ()

@end

@implementation StripeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.stpmenu.target = self.revealViewController;
    self.stpmenu.action = @selector(revealToggle:);
    [self.view addGestureRecognizer:(self.revealViewController.panGestureRecognizer)];
    
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:25.0/255.0 green:89.0/255.0 blue:187.0/255.0 alpha:1.0];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    [self setBackground];
    
    self.submitBtn.enabled = NO;
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onChangeCardNum:(id)sender {
    static int prevLength = 0;
    if(self.cardNum.text.length == 19) {
        [self.date becomeFirstResponder];
        [self fieldsFilledUp:self.date];
    }
    else if ((1+self.cardNum.text.length)%5 == 0) {
        if(prevLength<self.cardNum.text.length)
            self.cardNum.text = [NSString stringWithFormat:@"%@ ",self.cardNum.text];
        else
            self.cardNum.text = [self.cardNum.text substringToIndex:[self.cardNum.text length]-1];
    } else if(self.cardNum.text.length == 20) {
        self.date.text = [NSString stringWithFormat:@"%c",[self.cardNum.text characterAtIndex:19]];
        self.cardNum.text = [self.cardNum.text substringToIndex:[self.cardNum.text length]-1];
        [self.date becomeFirstResponder];
    }
    prevLength = (int)self.cardNum.text.length;
}

- (IBAction)onChangeDate:(id)sender {
    static int prevLength = 0;
    if(self.date.text.length == 5) {
        [self.CVC becomeFirstResponder];
        [self fieldsFilledUp:self.CVC];
    }
    else if(self.date.text.length ==1 && [self.date.text substringWithRange:NSMakeRange(0,1)].longLongValue > 1) {
        self.date.text = [NSString stringWithFormat:@"0%@/",self.date.text];
        
    }
    else if(self.date.text.length == 2) {
        if([self.date.text substringWithRange:NSMakeRange(0,2)].longLongValue > 12)
            self.date.text = [self.date.text substringToIndex:[self.date.text length]-1];
        else if(prevLength<self.date.text.length)
            self.date.text = [NSString stringWithFormat:@"%@/",self.date.text];
        else
            self.date.text = [self.date.text substringToIndex:[self.date.text length]-1];
    } else if(self.date.text.length == 0) {
        [self.cardNum becomeFirstResponder];
    } else if(self.date.text.length == 6) {
        self.CVC.text = [NSString stringWithFormat:@"%c",[self.date.text characterAtIndex:5]];
        self.date.text = [self.date.text substringToIndex:[self.date.text length]-1];
        [self.CVC becomeFirstResponder];
    }
    prevLength = (int)self.date.text.length;
}

- (IBAction)onChangeCVC:(id)sender {
    if(self.CVC.text.length == 3) {
        [self fieldsFilledUp:self.CVC];
        [self.CVC resignFirstResponder];
    }
    else if(self.CVC.text.length == 0)
        [self.date becomeFirstResponder];
}

-(void) fieldsFilledUp:(UITextField *)this {
    if(self.cardNum.text.length == 19 && self.date.text.length == 5 && self.CVC.text.length == 3) {
        self.submitBtn.enabled = YES;
        [this resignFirstResponder];
    }
    else
        self.submitBtn.enabled = NO;
}

- (IBAction)submit:(id)sender {
    STPCardParams* card = [[STPCardParams alloc] init];
    card.number = [self.cardNum.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    card.expMonth = [self.date.text substringWithRange:NSMakeRange(0,2)].longLongValue;
    card.expYear = [self.date.text substringWithRange:NSMakeRange(3,2)].longLongValue;
    card.cvc = self.CVC.text;
    [[STPAPIClient sharedClient]
     createTokenWithCard:card
     completion:^(STPToken *token, NSError *error) {
         NSString *alertTitle, *alertMsg;
         if (token) {
             alertTitle = @"Welcome to Stripe";
             alertMsg = [NSString stringWithFormat:@"Token created: %@",token];
             // TODO: send the token to your server so it can create a charge
             
         } else {
             alertTitle = @"Error Creating Token";
             alertMsg =  [NSString stringWithFormat:@"%@",error.localizedDescription];
         }
         UIAlertController* alert = [UIAlertController alertControllerWithTitle:alertTitle
                                                                        message:alertMsg
                                                                 preferredStyle:UIAlertControllerStyleAlert];
         [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
         [self presentViewController:alert animated:YES completion:nil];
     }];
    NSLog(@"cardNum: %@",card.number);
    NSLog(@"Month: %lu",card.expMonth);
    NSLog(@"Year: %lu",card.expYear);
    NSLog(@"CVC: %@",card.cvc);
}

-(void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [self setBackground];
}

-(void) setBackground {
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.view.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:25.0/255.0 green:89.0/255.0 blue:187.0/255.0 alpha:1.0]CGColor],(id)[[UIColor colorWithRed:33.0/255.0 green:142.0/255.0 blue:208.0/255.0 alpha:1.0]CGColor], nil];
    gradient.startPoint = CGPointMake(.3,0);
    gradient.endPoint = CGPointMake(1,.7);
    [self.view.layer insertSublayer:gradient atIndex:0];
}

@end

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
