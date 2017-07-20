#ifndef BALL_H__
#define BALL_H__

#include "cocos2d.h"
#include "GameConstants.h"

using namespace cocos2d;

#define BALL_ANIMATION_DELAY 0.01f

class Ball : public CCSprite
{
private:

	std::vector<CCAnimation*> showingAnimation;
	std::vector<CCSpriteFrame*> normalFrameList;
	std::vector<CCSpriteFrame*> waitingFrameList;
	std::vector<CCAnimation*> buzzAnimate;
	std::vector<CCAnimation*> selectedAnimate;
	CCAnimate* emptyAnimate;

	

public:
	int color;
	int status;
	bool isVisited;
	virtual bool init();
	virtual void release();
	void setStatus(int status);
	void setColor(int color);
	void setIsVisited(bool b);

	void setEmpty();
	void setNormal();

	void GetDisplayRect(CCRect& rect);
	bool CheckContainPoint(CCPoint point);
	

	CREATE_FUNC(Ball);


};

#endif
