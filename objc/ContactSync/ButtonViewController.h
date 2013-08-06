//
//  ButtonViewController.h
//  ContactSync
//
//  Created by Jack Dubie on 8/5/13.
//  Copyright (c) 2013 Jack Dubie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ButtonViewController : UIViewController
- (void)addTextView;
- (void)append:(NSString *)toWrite;
- (void)set:(NSString *)toWrite;
@end
