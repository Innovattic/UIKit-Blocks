//
//  CAAnimation+IABlocks.h
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

#import <QuartzCore/QuartzCore.h>

/**
 This category adds blocks functionality to CAAnimation to replace its delegate.
 
 Setting either of the two block properties will automatically reset the animation's
 delegate to an internal private object. Manually setting the delegate to another object
 will break the blocks functionality.
 
 Retain cycle considerations:
 The blocks assigned to the animation are copied and retained by the animation for
 the lifetime of the animation. Removing animations (including when they finish) also
 releases them, so in most cases retain cycles are unlikely. Be careful though when
 using repeating animations or when having removedOnCompletion set to NO.
 */
@interface CAAnimation (IABlocks)

/**
 The block to execute when the animation starts.
 
 @see [CAAnimation animationDidStart:]
 */
@property (copy, nonatomic)     void                    (^animationDidStartHandler)(CAAnimation* animation);

/**
 The block to execute when the animation stops.
 
 @see [CAAnimation animationDidStop:]
 */
@property (copy, nonatomic)     void                    (^animationDidStopHandler)(CAAnimation* animation, BOOL finished);

@end
