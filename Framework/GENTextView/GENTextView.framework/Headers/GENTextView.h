//
//  GENTextView.h
//  GENTextView
//
//  Created by 王磊 on 2020/5/3.
//  Copyright © 2020 王磊. All rights reserved.
//

#import <Foundation/Foundation.h>

//! Project version number for GENTextView.
FOUNDATION_EXPORT double GENTextViewVersionNumber;

//! Project version string for GENTextView.
FOUNDATION_EXPORT const unsigned char GENTextViewVersionString[];

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GENTextView : UIView

@property (nonatomic ,strong,readonly) UITextView *placeholderView;

@property (nonatomic ,strong,readonly) UITextView *textView;

@property (nonatomic ,strong) UIColor *textColor;

@property (nonatomic ,strong) UIFont *font;

@property (nonatomic ,copy) NSString *placeholder;

@property (nonatomic ,copy) NSString *text;

@property (nonatomic ,assign) UIEdgeInsets textContainerInset;

+ (instancetype)createTextViewWithFrame:(CGRect )frame;

@end

NS_ASSUME_NONNULL_END
