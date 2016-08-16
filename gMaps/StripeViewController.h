//
//  StripeViewController.h
//  gMaps
//
//  Created by LLDM on 15/08/2016.
//  Copyright © 2016 LLDM. All rights reserved.
//

#import "ViewController.h"
#import "SWRevealViewController.h"
#import <Stripe/Stripe.h>


@interface StripeViewController : ViewController<STPPaymentCardTextFieldDelegate>

@property (weak,nonatomic) IBOutlet UIBarButtonItem * stpmenu;
@property (nonatomic) STPPaymentCardTextField *paymentTextField;
@property (nonatomic) UIButton *submitButton;

@property (strong, nonatomic) IBOutlet UITextField *cardNum;
@property (strong, nonatomic) IBOutlet UITextField *date;
@property (strong, nonatomic) IBOutlet UITextField *CVC;
@property (strong, nonatomic) IBOutlet UIButton *submitBtn;
- (IBAction)onChangeCardNum:(id)sender;
- (IBAction)onChangeDate:(id)sender;
- (IBAction)onChangeCVC:(id)sender;
- (IBAction)submit:(id)sender;
- (IBAction)primary:(id)sender;

@end
