

/****************************************************************************
Copyright (c) 2010-2013 cocos2d-x.org
Copyright (c) Microsoft Open Technologies, Inc.

http://www.cocos2d-x.org

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
****************************************************************************/
#include "AppDelegate.h"

#include <vector>
#include <string>

#include "GameLayer.h"
#include "AppMacros.h"

#include "GameConstants.h"

USING_NS_CC;
using namespace std;
using namespace cocos2d;

AppDelegate::AppDelegate() {
	CCSpriteFrameCache* spriteFrameCache=CCSpriteFrameCache::sharedSpriteFrameCache();
	for(int color=0; color<7; color++)
	{
		for(int size=0; size<6; size++)
		{
			CCSpriteFrame* frame=CCSpriteFrame::create("nho1.png",CCRectMake((color+1)*BALL_WIDTH,size*BALL_HEIGHT,BALL_WIDTH,BALL_HEIGHT));
			char st[10];
			sprintf(st,"c%d_s%d",color,size);
			spriteFrameCache->addSpriteFrame(frame,st);
		}
	}

	CCSpriteFrame* emptyFrame=CCSpriteFrame::create("nho1.png",CCRectMake(0,0,BALL_WIDTH,BALL_HEIGHT));
	spriteFrameCache->addSpriteFrame(emptyFrame,"empty");
}

AppDelegate::~AppDelegate() 
{
	CCSpriteFrameCache* spriteFrameCache=CCSpriteFrameCache::sharedSpriteFrameCache();
	spriteFrameCache->removeUnusedSpriteFrames();
	spriteFrameCache->release();
}

bool AppDelegate::applicationDidFinishLaunching() {
    // initialize director
    CCDirector* pDirector = CCDirector::sharedDirector();
    CCEGLView* pEGLView = CCEGLView::sharedOpenGLView();

    pDirector->setOpenGLView(pEGLView);
	CCSize frameSize = pEGLView->getFrameSize();

	//1280x720
    pEGLView->setDesignResolutionSize(512, 910, kResolutionShowAll);
	pDirector->setContentScaleFactor(1);

	
    // turn on display FPS
    pDirector->setDisplayStats(true);

    // set FPS. the default value is 1.0/60 if you don't call this
    pDirector->setAnimationInterval(1.0 / 60);

    // create a scene. it's an autorelease object
    CCScene *pScene = GameLayer::scene();

    // run
    pDirector->runWithScene(pScene);



    return true;
}

// This function will be called when the app is inactive. When comes a phone call,it's be invoked too
void AppDelegate::applicationDidEnterBackground() {
    CCDirector::sharedDirector()->stopAnimation();

    // if you use SimpleAudioEngine, it must be pause
    // SimpleAudioEngine::sharedEngine()->pauseBackgroundMusic();
}

// this function will be called when the app is active again
void AppDelegate::applicationWillEnterForeground() {
    CCDirector::sharedDirector()->startAnimation();

    // if you use SimpleAudioEngine, it must resume here
    // SimpleAudioEngine::sharedEngine()->resumeBackgroundMusic();
}
