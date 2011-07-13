//
//  NumberInputController.h
//  NumberInput
//
//  Created by Roger Chapman on 13/07/2011.
//  Copyright 2011 Storm ID Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NumberInputController : UIViewController {
    
  int _currentNumber;
  
  UITextField *_numberTextField;
  UILabel *_numberLabel;
}

@property (nonatomic, retain) IBOutlet UITextField *numberTextField;
@property (nonatomic, retain) IBOutlet UILabel *numberLabel;

- (IBAction)textChanged:(id)sender;

@end
