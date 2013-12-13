//
//  UIActionSheet+IABlocks.h
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

#import <UIKit/UIKit.h>


/**
 The block for UIActionSheet events.
 
 @param sheet The action sheet that fired the event.
 @param buttonIndex The index of the button related to the event. May be -1 if it does not apply.
 */
typedef void (^IAActionSheetHandler)(UIActionSheet* sheet, NSInteger buttonIndex);



/**
 This category adds support for blocks to UIActionSheets, making it unnecessary to use delegates.
 
 Using the initializer initWithTitle:cancelButtonTitle:destructiveButtonTitle:otherButtonTitles:... automatically enables
 blocks for the action sheet, but they can also be toggled on or of using the blocksEnabled property. Note
 that when blocks are enabled you SHOULD NOT set the delegate to something else. This implementation
 depends on a private class that acts as the delegate when blocks are enabled. Setting a different delegate
 will have undefined results.
 */
@interface UIActionSheet (IABlocks)

/**
 Initializes the action sheet using the specified starting parameters and with blocks enabled.
 
 @param title A string to display in the title area of the action sheet. Pass nil if you do not want to
 display any text in the title area.
 @param cancelButtonTitle The title of the cancel button. This button is added to the action sheet automatically
 and assigned an appropriate index, which is available from the cancelButtonIndex property. This button is
 displayed in black to indicate that it represents the cancel action. Specify nil if you do not want a cancel
 button or are presenting the action sheet on an iPad.
 @param destructiveButtonTitle The title of the destructive button. This button is added to the action sheet
 automatically and assigned an appropriate index, which is available from the destructiveButtonIndex property.
 This button is displayed in red to indicate that it represents a destructive behavior. Specify nil if you do
 not want a destructive button.
 @param otherButtonTitles The title of an additional buttons you want to add. This parameter consists of a
 nil-terminated, comma-separated list of strings. For example, to specify two additional buttons, you could
 specify the value @"Button 1", @"Button 2", nil.
 @param ... The titles of any additional buttons you want to add.
 @return A newly initialized action sheet with blocks enabled.
 */
- (id)initWithTitle:(NSString*)title cancelButtonTitle:(NSString*)cancelButtonTitle destructiveButtonTitle:(NSString*)destructiveButtonTitle otherButtonTitles:(NSString*)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

/** A Boolean value indicating whether blocks are enabled. */
@property (nonatomic, getter = isBlocksEnabled) BOOL    blocksEnabled;

/**
 The cancel handler will be called when the sheet is cancelled, either by the system or
 by the user tapping the cancel button.
 
 The buttonIndex parameter of the handler is -1 if the sheet is cancelled by the system, or
 equal to cancelButtonIndex if the user tapped the cancel button.
 
 See [UIActionSheetDelegate actionSheetCancel:].
 */
@property (copy, nonatomic)     IAActionSheetHandler    cancelHandler;

/** See [UIActionSheetDelegate actionSheet:clickedButtonAtIndex:]. */
@property (copy, nonatomic)     IAActionSheetHandler    buttonHandler;

/** See [UIActionSheetDelegate willPresentActionSheet:]. */
@property (copy, nonatomic)     IAActionSheetHandler    willPresentHandler;

/** See [UIActionSheetDelegate didPresentActionSheet:]. */
@property (copy, nonatomic)     IAActionSheetHandler    didPresentHandler;

/** See [UIActionSheetDelegate actionSheet:willDismissWithButtonIndex:]. */
@property (copy, nonatomic)     IAActionSheetHandler    willDismissHandler;

/** See [UIActionSheetDelegate actionSheet:didDismissWithButtonIndex:]. */
@property (copy, nonatomic)     IAActionSheetHandler    didDismissHandler;


/**
 Returns the handler for the button at the given index.
 
 @param buttonIndex The index of the button. The button indices start at 0.
 @return The handler for the button specified by index buttonIndex.
 */
- (IAActionSheetHandler)handlerForButtonAtIndex:(NSInteger)buttonIndex;

/**
 Sets the handler for the button at the given index.
 
 @param handler The handler that will be called when the button is tapped.
 @param buttonIndex The index of the button. The button indices start at 0.
 */
- (void)setHandler:(IAActionSheetHandler)handler forButtonAtIndex:(NSInteger)buttonIndex;

@end
