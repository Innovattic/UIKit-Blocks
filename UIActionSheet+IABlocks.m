//
//  UIActionSheet+IABlocks.m
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

#import "UIActionSheet+IABlocks.h"


#define IAActionSheetBlocksViewTag                (0x14151337)

#pragma mark -
@interface IAActionSheetBlocksView : UIView <UIActionSheetDelegate> {
    IAActionSheetHandler        _cancelHandler;
    IAActionSheetHandler        _buttonHandler;
    NSMutableArray*             _buttonHandlers;
    IAActionSheetHandler        _willPresentHandler;
    IAActionSheetHandler        _didPresentHandler;
    IAActionSheetHandler        _willDismissHandler;
    IAActionSheetHandler        _didDismissHandler;
}

@property (copy, nonatomic)     IAActionSheetHandler    cancelHandler;
@property (copy, nonatomic)     IAActionSheetHandler    buttonHandler;
@property (copy, nonatomic)     IAActionSheetHandler    willPresentHandler;
@property (copy, nonatomic)     IAActionSheetHandler    didPresentHandler;
@property (copy, nonatomic)     IAActionSheetHandler    willDismissHandler;
@property (copy, nonatomic)     IAActionSheetHandler    didDismissHandler;

- (IAActionSheetHandler)handlerForButtonAtIndex:(NSInteger)buttonIndex;
- (void)setHandler:(IAActionSheetHandler)handler forButtonAtIndex:(NSInteger)buttonIndex;

- (void)clearAllHandlers;

@end



#pragma mark -
@implementation UIActionSheet (IABlocks)

#pragma mark -
#pragma mark Lifecycle

- (id)initWithTitle:(NSString*)title cancelButtonTitle:(NSString*)cancelButtonTitle destructiveButtonTitle:(NSString*)destructiveButtonTitle otherButtonTitles:(NSString*)otherButtonTitles, ... {
    self = [self initWithTitle:title delegate:nil cancelButtonTitle:nil destructiveButtonTitle:destructiveButtonTitle otherButtonTitles:otherButtonTitles, nil];
    if (self) {
        if (otherButtonTitles) {
            va_list otherButtonTitlesList;
            va_start(otherButtonTitlesList, otherButtonTitles);
            NSString* otherButtonTitle;
            while ((otherButtonTitle = va_arg(otherButtonTitlesList, NSString*)) != nil) {
                [self addButtonWithTitle:otherButtonTitle];
            }
            va_end(otherButtonTitlesList);
        }
        if (cancelButtonTitle) {
            NSInteger buttonIndex = [self addButtonWithTitle:cancelButtonTitle];
            [self setCancelButtonIndex:buttonIndex];
        }
        [self sizeToFit];
        
        IAActionSheetBlocksView* blocksView = [[IAActionSheetBlocksView alloc] init];
        [self setDelegate:blocksView];
        [self addSubview:blocksView];
    }
    return self;
}


#pragma mark -
#pragma mark Properties

- (BOOL)isBlocksEnabled {
    return ([self viewWithTag:IAActionSheetBlocksViewTag] != nil);
}

- (void)setBlocksEnabled:(BOOL)blocksEnabled {
    IAActionSheetBlocksView* blocksView = (IAActionSheetBlocksView*)[self viewWithTag:IAActionSheetBlocksViewTag];
    if (blocksEnabled) {
        if (!blocksView) {
            blocksView = [[IAActionSheetBlocksView alloc] init];
            [self setDelegate:blocksView];
            [self addSubview:blocksView];
        }
    } else {
        if (blocksView) {
            if ([self delegate] == blocksView)
                [self setDelegate:nil];
            [blocksView removeFromSuperview];
        }
    }
}

- (IAActionSheetHandler)cancelHandler {
    IAActionSheetBlocksView* blocksView = [self findBlocksView];
    if (blocksView)
        return [blocksView cancelHandler];
    else
        return nil;
}

- (void)setCancelHandler:(IAActionSheetHandler)cancelHandler {
    IAActionSheetBlocksView* blocksView = [self findBlocksView];
    if (blocksView)
        [blocksView setCancelHandler:cancelHandler];
}

- (IAActionSheetHandler)buttonHandler {
    IAActionSheetBlocksView* blocksView = [self findBlocksView];
    if (blocksView)
        return [blocksView buttonHandler];
    else
        return nil;
}

- (void)setButtonHandler:(IAActionSheetHandler)buttonHandler {
    IAActionSheetBlocksView* blocksView = [self findBlocksView];
    if (blocksView)
        [blocksView setButtonHandler:buttonHandler];
}

- (IAActionSheetHandler)willPresentHandler {
    IAActionSheetBlocksView* blocksView = [self findBlocksView];
    if (blocksView)
        return [blocksView willPresentHandler];
    else
        return nil;
}

- (void)setWillPresentHandler:(IAActionSheetHandler)presentHandler {
    IAActionSheetBlocksView* blocksView = [self findBlocksView];
    if (blocksView)
        [blocksView setWillPresentHandler:presentHandler];
}

- (IAActionSheetHandler)didPresentHandler {
    IAActionSheetBlocksView* blocksView = [self findBlocksView];
    if (blocksView)
        return [blocksView didPresentHandler];
    else
        return nil;
}

- (void)setDidPresentHandler:(IAActionSheetHandler)presentHandler {
    IAActionSheetBlocksView* blocksView = [self findBlocksView];
    if (blocksView)
        [blocksView setDidPresentHandler:presentHandler];
}

- (IAActionSheetHandler)willDismissHandler {
    IAActionSheetBlocksView* blocksView = [self findBlocksView];
    if (blocksView)
        return [blocksView willDismissHandler];
    else
        return nil;
}

- (void)setWillDismissHandler:(IAActionSheetHandler)dismissHandler {
    IAActionSheetBlocksView* blocksView = [self findBlocksView];
    if (blocksView)
        [blocksView setWillDismissHandler:dismissHandler];
}

- (IAActionSheetHandler)didDismissHandler {
    IAActionSheetBlocksView* blocksView = [self findBlocksView];
    if (blocksView)
        return [blocksView didDismissHandler];
    else
        return nil;
}

- (void)setDidDismissHandler:(IAActionSheetHandler)dismissHandler {
    IAActionSheetBlocksView* blocksView = [self findBlocksView];
    if (blocksView)
        [blocksView setDidDismissHandler:dismissHandler];
}


#pragma mark -
#pragma mark Public methods

- (IAActionSheetHandler)handlerForButtonAtIndex:(NSInteger)buttonIndex {
    IAActionSheetBlocksView* blocksView = [self findBlocksView];
    if (blocksView)
        return [blocksView handlerForButtonAtIndex:buttonIndex];
    else
        return nil;
}

- (void)setHandler:(IAActionSheetHandler)handler forButtonAtIndex:(NSInteger)buttonIndex {
    IAActionSheetBlocksView* blocksView = [self findBlocksView];
    if (blocksView)
        [blocksView setHandler:handler forButtonAtIndex:buttonIndex];
}


#pragma mark -
#pragma mark Private methods

- (IAActionSheetBlocksView*)findBlocksView {
    IAActionSheetBlocksView* blocksView = (IAActionSheetBlocksView*)[self viewWithTag:IAActionSheetBlocksViewTag];
    if (!blocksView)
        NSLog(@"WARNING: Blocks are currently not enabled for %@. Either use initWithTitle:cancelButtonTitle:destructiveButtonTitle:otherButtonTitles: or call setBlocksEnabled:YES.", self);
    return blocksView;
}

@end



#pragma mark -
@implementation IAActionSheetBlocksView

#pragma mark -
#pragma mark Lifecycle

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUserInteractionEnabled:NO];
        [self setTag:IAActionSheetBlocksViewTag];
        
        _buttonHandlers = [[NSMutableArray alloc] init];
        
        [self clearAllHandlers];
    }
    return self;
}

- (void)dealloc {
}


#pragma mark -
#pragma mark Properties

@synthesize cancelHandler = _cancelHandler;
@synthesize buttonHandler = _buttonHandler;
@synthesize willPresentHandler = _willPresentHandler;
@synthesize didPresentHandler = _didPresentHandler;
@synthesize willDismissHandler = _willDismissHandler;
@synthesize didDismissHandler = _didDismissHandler;


#pragma mark -
#pragma mark UView

- (void)willMoveToSuperview:(UIView*)newSuperview {
    [self clearAllHandlers];
}


#pragma mark -
#pragma mark UIAlertViewDelegate

- (void)actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (_buttonHandler)
        _buttonHandler(actionSheet, buttonIndex);
    
    if (buttonIndex >= 0) {
        IAActionSheetHandler handler = [self handlerForButtonAtIndex:buttonIndex];
        if (handler)
            handler(actionSheet, buttonIndex);
        
        if (buttonIndex == [actionSheet cancelButtonIndex] && _cancelHandler)
            _cancelHandler(actionSheet, buttonIndex);
    }
}

- (void)willPresentActionSheet:(UIActionSheet*)actionSheet {
    if (_willPresentHandler)
        _willPresentHandler(actionSheet, -1);
}

- (void)didPresentActionSheet:(UIActionSheet*)actionSheet {
    if (_didPresentHandler)
        _didPresentHandler(actionSheet, -1);
}

- (void)actionSheet:(UIActionSheet*)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (_willDismissHandler)
        _willDismissHandler(actionSheet, buttonIndex);
}

- (void)actionSheet:(UIActionSheet*)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (_didDismissHandler)
        _didDismissHandler(actionSheet, buttonIndex);
}

- (void)actionSheetCancel:(UIActionSheet*)actionSheet {
    NSInteger cancelButtonIndex = [actionSheet cancelButtonIndex];
    if (_buttonHandler && cancelButtonIndex >= 0)
        _buttonHandler(actionSheet, cancelButtonIndex);
    
    if (cancelButtonIndex >= 0) {
        IAActionSheetHandler handler = [self handlerForButtonAtIndex:cancelButtonIndex];
        if (handler)
            handler(actionSheet, cancelButtonIndex);
    }
    
    if (_cancelHandler)
        _cancelHandler(actionSheet, -1);
}



#pragma mark -
#pragma mark Public methods

- (IAActionSheetHandler)handlerForButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex < 0)
        @throw [NSException exceptionWithName:NSRangeException reason:@"Button index can't be less than 0." userInfo:nil];
    
    if (buttonIndex < [_buttonHandlers count]) {
        id handler = [_buttonHandlers objectAtIndex:buttonIndex];
        if ([handler isKindOfClass:[NSNull class]])
            return nil;
        else
            return handler;
    } else {
        return nil;
    }
}

- (void)setHandler:(IAActionSheetHandler)handler forButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex < 0)
        @throw [NSException exceptionWithName:NSRangeException reason:@"Button index can't be less than 0." userInfo:nil];
    
    while ([_buttonHandlers count] < buttonIndex)
        [_buttonHandlers addObject:[NSNull null]];
    
    if (buttonIndex == [_buttonHandlers count])
        [_buttonHandlers addObject:(handler ? [handler copy] : [NSNull null])];
    else
        [_buttonHandlers replaceObjectAtIndex:buttonIndex withObject:(handler ? [handler copy] : [NSNull null])];
}

- (void)clearAllHandlers {
    _cancelHandler = nil;
    _buttonHandler = nil;
    [_buttonHandlers removeAllObjects];
    _willPresentHandler = nil;
    _didPresentHandler = nil;
    _willDismissHandler = nil;
    _didDismissHandler = nil;
}

@end
