//
// Copyright 2009-2011 Facebook
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import "TBImageLayer.h"

// UI
#import "TBImageView.h"


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation TBImageLayer

@synthesize override = _override;


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)display {
  if (nil != _override) {
//    self.contents = (id)_override.image.CGImage;
      //图片分两层显示
      //默认图层显示默认图片
      //第二层显示请求的图片
      self.contents = (id)_override.defaultImage.CGImage; //第一层，默认层

  } else {
    return [super display];
  }
}


@end
