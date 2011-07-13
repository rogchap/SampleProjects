//
//  NumberInputController.m
//  NumberInput
//
//  Created by Roger Chapman on 13/07/2011.
//  Copyright 2011 Storm ID Ltd. All rights reserved.
//

#import "NumberInputController.h"


@implementation NumberInputController
@synthesize numberTextField = _numberTextField, numberLabel = _numberLabel;

- (void)dealloc {
    [_numberTextField release];
    [_numberLabel release];
    [super dealloc];
}

-(void)viewDidLoad {
  [_numberTextField becomeFirstResponder];
}

- (void)viewDidUnload {
    [self setNumberTextField:nil];
    [self setNumberLabel:nil];
    [super viewDidUnload];
}
- (IBAction)textChanged:(id)sender {
  
  int number = [_numberTextField.text intValue];
  
  // make sure we don't go beyond INT32_MAX
  if (number == INT32_MAX) {
    number = _currentNumber;
    _numberTextField.text = [NSString stringWithFormat:@"%d", number];
  }
  
  _currentNumber = number;
  _numberLabel.text = [NSString stringWithFormat:@"%@%d", [[NSLocale currentLocale] objectForKey:NSLocaleCurrencySymbol], _currentNumber];
}
@end
