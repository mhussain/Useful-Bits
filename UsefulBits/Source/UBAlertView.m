//
//  AlertView.m
//  Quickie
//
//  Created by Kevin O'Neill on 28/04/11.
//
//  Copyright (c) 2011, Kevin O'Neill
//  All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  * Redistributions of source code must retain the above copyright
//   notice, this list of conditions and the following disclaimer.
//
//  * Redistributions in binary form must reproduce the above copyright
//   notice, this list of conditions and the following disclaimer in the
//   documentation and/or other materials provided with the distribution.
//
//  * Neither the name UsefulBits nor the names of its contributors may be used
//   to endorse or promote products derived from this software without specific
//   prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//  DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY
//  DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
//  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "UBAlertView.h"


@implementation UBAlertView

- (id)initWithTitle:(NSString*)title message:(NSString*)msg
{
  if(([super initWithTitle:title message:msg delegate:nil cancelButtonTitle:nil otherButtonTitles:nil]))
  {
    [self setDelegate:self];
    buttonBlocks_ = [[NSMutableArray alloc] init];
  }
  
  return self;
}

- (void)dealloc
{
  [cancel_ release];
  [buttonBlocks_ release];
  
  [super dealloc];
}

-(void)addButtonWithTitle:(NSString*)title block:(void(^)(UBAlertView*, NSInteger))block
{
  [self addButtonWithTitle:title];
  [buttonBlocks_ addObject:[[block copy] autorelease]];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  ((void(^)(UBAlertView*, NSInteger))[buttonBlocks_ objectAtIndex:buttonIndex])((UBAlertView*)alertView, buttonIndex);
}

-(void)alertViewCancel:(UIAlertView *)alertView
{
  if(nil != cancel_)
  {
    cancel_((UBAlertView*)alertView);
  }
  else
  {
    [self dismissWithClickedButtonIndex:self.cancelButtonIndex animated:NO];
  }
}

-(void)setAlertViewCancelBlock:(void(^)(UBAlertView*))block
{
  if (block != cancel_)
  {
    [cancel_ release];
    cancel_ = [block copy];
  }
}

@end
