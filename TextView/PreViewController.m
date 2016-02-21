//
//  PreViewController.m
//  TextView
//
//  Created by 沈红榜 on 16/2/18.
//  Copyright © 2016年 沈红榜. All rights reserved.
//

#import "PreViewController.h"
#import "SHBAttachMent.h"

@interface PreViewController ()<UITextViewDelegate>

@end

@implementation PreViewController {
    
    UITextView      *_textView;
    
    NSAttributedString *_attString;
    
    UIImageView     *_imgView;
    
    NSMutableArray  *_attachMents;
    NSMutableArray  *_rangs;
    
}

- (instancetype)initWithAttString:(NSAttributedString *)attString attachMents:(NSArray *)array {
    self = [super init];
    if (self) {
        _attString = attString;
    }
    return self;
}

- (void)post {
    //    NSLog(@"%@ ---- %@",_textView.text , _textView.attributedText);
    
    
    [_textView.attributedText enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, _textView.attributedText.length) options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
//        NSLog(@"++++++%@\n%@", value, NSStringFromRange(range));
        if ([value isKindOfClass:[SHBAttachMent class]]) {
            [_attachMents addObject:value];
            [_rangs addObject:NSStringFromRange(range)];
        }
    }];
    
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithAttributedString:_textView.attributedText];
    
    for (int i = 0; i < _rangs.count; i++) {
        NSString *string = [NSString stringWithFormat:@"[%d]", i];
        NSRange rang = NSRangeFromString(_rangs[i]);
        if (i != 0) {
            rang.location += 2 * i;
        }
        [attString replaceCharactersInRange:rang withString:string];
    }
    
    NSArray *img = [_attachMents valueForKeyPath:@"@unionOfObjects.originalImage"];
    
    NSLog(@"*****\n%@\n****%@\n*****%@", attString.string, _textView.text, img);
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _attachMents = [[NSMutableArray alloc] initWithCapacity:0];
    _rangs = [[NSMutableArray alloc] initWithCapacity:0];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发帖" style:UIBarButtonItemStylePlain target:self action:@selector(post)];
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(20, 0, CGRectGetWidth(self.view.bounds) - 40, CGRectGetHeight(self.view.bounds))];
    
    _textView.backgroundColor = [UIColor whiteColor];
    _textView.delegate = self;
    _textView.editable = false;
    [self.view addSubview:_textView];
    _textView.attributedText = _attString;
    
    
    _imgView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    _imgView.contentMode = UIViewContentModeScaleAspectFit;
    _imgView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.9];
    [self.view addSubview:_imgView];
    _imgView.hidden = true;
    
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange {
    _imgView.hidden = false;
    SHBAttachMent *attachment = (SHBAttachMent *)textAttachment;
    _imgView.image = attachment.originalImage;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _imgView.hidden = true;
    });
    return false;
}



@end
