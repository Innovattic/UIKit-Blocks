//
//  CAAnimation+IABlocks.m
//
//  This is free and unencumbered software released into the public domain.
//
//  Anyone is free to copy, modify, publish, use, compile, sell, or
//  distribute this software, either in source code form or as a compiled
//  binary, for any purpose, commercial or non-commercial, and by any
//  means.
//
//  In jurisdictions that recognize copyright laws, the author or authors
//  of this software dedicate any and all copyright interest in the
//  software to the public domain. We make this dedication for the benefit
//  of the public at large and to the detriment of our heirs and
//  successors. We intend this dedication to be an overt act of
//  relinquishment in perpetuity of all present and future rights to this
//  software under copyright law.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
//  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
//  IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
//  OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
//  ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//
//  For more information, please refer to <http://unlicense.org>
//

#import "CAAnimation+IABlocks.h"

#define IAAnimationDidStartHandlerKey           @"IAAnimationDidStartHandler"
#define IAAnimationDidStopHandlerKey            @"IAAnimationDidStopHandler"


#pragma mark -
@interface IAAnimationBlocksDelegate : NSObject {
}

+ (IAAnimationBlocksDelegate*)sharedInstance;

- (void)animationDidStart:(CAAnimation*)animation;
- (void)animationDidStop:(CAAnimation*)animation finished:(BOOL)finished;

@end



#pragma mark -
@implementation CAAnimation (IABlocks)

#pragma mark -
#pragma mark Properties

- (void (^)(CAAnimation*))animationDidStartHandler {
    return [self valueForKey:IAAnimationDidStartHandlerKey];
}

- (void)setAnimationDidStartHandler:(void (^)(CAAnimation*))animationDidStartHandler {
    [self setValue:[animationDidStartHandler copy] forKey:IAAnimationDidStartHandlerKey];
    
    if (animationDidStartHandler) {
        id delegate = [IAAnimationBlocksDelegate sharedInstance];
        if ([self delegate] != delegate)
            [self setDelegate:delegate];
    }
}

- (void (^)(CAAnimation*, BOOL))animationDidStopHandler {
    return [self valueForKey:IAAnimationDidStopHandlerKey];
}

- (void)setAnimationDidStopHandler:(void (^)(CAAnimation*, BOOL))animationDidStopHandler {
    [self setValue:[animationDidStopHandler copy] forKey:IAAnimationDidStopHandlerKey];
    
    if (animationDidStopHandler) {
        id delegate = [IAAnimationBlocksDelegate sharedInstance];
        if ([self delegate] != delegate)
            [self setDelegate:delegate];
    }
}

@end



#pragma mark -
@implementation IAAnimationBlocksDelegate

#pragma mark -
#pragma mark Class methods

+ (IAAnimationBlocksDelegate*)sharedInstance {
    static IAAnimationBlocksDelegate* instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[IAAnimationBlocksDelegate alloc] init];
    });
    return instance;
}


#pragma mark -
#pragma mark Lifecycle

- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)dealloc {
}


#pragma mark -
#pragma mark CAAnimation delegate

- (void)animationDidStart:(CAAnimation*)animation {
    void (^block)(CAAnimation*) = [animation valueForKey:IAAnimationDidStartHandlerKey];
    if (block)
        block(animation);
}

- (void)animationDidStop:(CAAnimation*)animation finished:(BOOL)finished {
    void (^block)(CAAnimation*, BOOL) = [animation valueForKey:IAAnimationDidStopHandlerKey];
    if (block)
        block(animation, finished);
}

@end
