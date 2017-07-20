#include "Ball.h"

using namespace cocos2d;

bool Ball::init()
{

	if(!CCSprite::init())
	{
		return false;
	}

	CCSpriteFrameCache* frameCache=CCSpriteFrameCache::sharedSpriteFrameCache();

	//empty
	CCAnimation* emptyAnimation=CCAnimation::create();
	emptyAnimation->addSpriteFrame(frameCache->spriteFrameByName("empty"));
	emptyAnimation->retain();
	this->emptyAnimate=CCAnimate::create(emptyAnimation);

	//Showing
	for(int c=0; c<7; c++)
	{
		CCAnimation* animation=CCAnimation::create();
		animation->retain();
		for(int s=5; s>=0; s--)
		{
			char st[10];
			sprintf(st,"c%d_s%d",c,s);			
			animation->addSpriteFrame(frameCache->spriteFrameByName(st));			
		}
		animation->setDelayPerUnit(0.01f);
		this->showingAnimation.push_back(animation);
	}

	//Normal
	for(int c=0; c<7; c++)
	{
		char st[10];
		sprintf(st,"c%d_s0",c);
		
		this->normalFrameList.push_back(frameCache->spriteFrameByName(st));
	}

	//Buzz
	for(int c=0; c<7; c++)
	{
		CCAnimation* animation=CCAnimation::create();
		animation->retain();
		for(int s=0; s<6; s++)
		{
			char st[10];
			sprintf(st,"c%d_s%d",c,s);
			animation->addSpriteFrame(frameCache->spriteFrameByName(st));
		}
		animation->setDelayPerUnit(0.05f);
		this->buzzAnimate.push_back(animation);
	}

	//Selected
	for(int c=0; c<7; c++)
	{
		CCAnimation* animation=CCAnimation::create();		
		animation->retain();
		for(int s=0; s<4; s++)
		{
			char st[10];
			sprintf(st,"c%d_s%d",c,s);
			CCSpriteFrame* spriteFrame = frameCache->spriteFrameByName(st);
			animation->addSpriteFrame(frameCache->spriteFrameByName(st));
		}

		for(int s=3; s>=0; s--)
		{
			char st[10];
			sprintf(st,"c%d_s%d",c,s);
			CCSpriteFrame* spriteFrame = frameCache->spriteFrameByName(st);
			animation->addSpriteFrame(frameCache->spriteFrameByName(st));
		}		
		animation->setDelayPerUnit(0.08f);

		this->selectedAnimate.push_back(animation);
	}


	//Waiting	
	for(int c=0; c<7; c++)
	{
		char st[10];
		sprintf(st,"c%d_s5",c);

		this->waitingFrameList.push_back(frameCache->spriteFrameByName(st));
	}

	return true;
}

void Ball::release()
{
	for(int i=0; i<showingAnimation.size(); i++)
	{
		this->showingAnimation[i]->release();
		this->normalFrameList[i]->release();
		this->buzzAnimate[i]->release();
		this->selectedAnimate[i]->release();
	}

	this->showingAnimation.clear();
	this->normalFrameList.clear();
	this->buzzAnimate.clear();
	this->selectedAnimate.clear();
	CCSprite::release();

}

void Ball::setColor(int color)
{
	this->color=color;
}

void Ball::setStatus(int status)
{
	this->status=status;
	this->stopAllActions();
	if(this->status==EMPTY)
	{		
		CCSpriteFrameCache* frameCache=CCSpriteFrameCache::sharedSpriteFrameCache();
		this->setDisplayFrame(frameCache->spriteFrameByName("empty"));
	}

	else if(this->status==NORMAL)
	{
		this->setDisplayFrame(this->normalFrameList[this->color]);
	
	}

	else if(this->status==SHOWING)
	{
		CCCallFunc* callFunc=CCCallFunc::create(this,callfunc_selector(Ball::setNormal));
		CCSequence* sequenceAction=CCSequence::create(CCAnimate::create(showingAnimation[this->color]), callFunc, NULL);
		this->runAction(sequenceAction);
	}

	else if(this->status==BUZZ)
	{
		CCCallFunc* callFunc=CCCallFunc::create(this,callfunc_selector(Ball::setEmpty));
		CCSequence* sequenceAction=CCSequence::create(CCAnimate::create(buzzAnimate[this->color]), callFunc, NULL);
		this->runAction(sequenceAction);
	}

	else if(this->status==SELECTED)
	{
		this->runAction(CCRepeatForever::create(CCAnimate::create(selectedAnimate[this->color])));
	}

	else if(this->status==WAITING)
	{
		this->setDisplayFrame(this->waitingFrameList[this->color]);
	}
}

void Ball::setIsVisited(bool b)
{
	this->isVisited=b;
}

void Ball::setEmpty()
{
	this->setStatus(EMPTY);
}

void Ball::setNormal()
{
	this->setStatus(NORMAL);
}

void Ball::GetDisplayRect(CCRect& rect)
{
	rect.setRect(
		getPositionX() - getContentSize().width*getAnchorPoint().x,
		getPositionY() - getContentSize().width*getAnchorPoint().y,
		getContentSize().width,
		getContentSize().height
		);
}

bool Ball::CheckContainPoint(CCPoint point)
{
	CCRect displayRect;
	GetDisplayRect(displayRect);

	return displayRect.containsPoint(point);
}
