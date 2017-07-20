#ifndef GAMELAYER_H__
#define GAMELAYER_H__

#include "cocos2d.h"
#include "Ball.h"
#include "LISTINT.h"

#include <string>
#include <stack>
#include <queue>

using namespace cocos2d;

struct PlayerInfo 
{
	std::string name;
	int score;
};

struct HighScore
{
	PlayerInfo scores[10];
};

struct GameStatus
{
	int colums[9][9];
	int score;

	int color0;
	int posGen0;
	int random;

	int color1;
	int posGen1;

	int color2;
	int posGen2;
};

#define GETX(val) val%9
#define GETY(val) val/9

#define MAX(x,y) x>y? x:y
#define MIN(x,y) x<=y? x:y

#define GET_TOPY(y) MAX(y-1,0)
#define GET_BOTTOMY(y) MIN(y+1,8)

#define GET_LEFTX(x) MAX(x-1,0)
#define GET_RIGHTX(x) MIN(x+1,8)

#define GETPOS(x,y) x+y*9

#define SZ_USER_NAME "USER_NAME"
#define SZ_SCORE "SCORE"

#define SZ_USER_NAME "USER_NAME"

class GameLayer:public CCLayer
{
private:
	std::vector<int> pointList;
	Ball* nexBallSprite[3];
	Ball* ballList[9][9];
	bool isVisited[9][9];
	int path[81];
	std::stack<int> pathStack;
	std::queue<int> columQueu;
	
	int preX, preY;
	int curX, curY;
	int score;
	int remainColumn;

	bool isEating;
	bool isShowPreGen;
	bool isShowPath;
	bool isSelected;
	int colors[3];
	int genPos[3];

	std::stack<GameStatus> gameSteps;
	GameStatus currentStatus;

	LISTINT remainingList;
	LISTINT ngangList;
	LISTINT docList;
	LISTINT traiList;
	LISTINT phaiList;

	CCLabelTTF *currentScoreText;
	CCLabelTTF *highScoreText;

	bool CheckScore(int x, int y);
	void AutoGen1();
	void Generate();
	void PreGen();

	int RangedRandom(int range_min, int range_max);
	void ResetGame();

	void LoadHighScore(HighScore &highScore);
	void SaveHighScore(HighScore highScore);


	void SaveGame();
	void LoadGame();
	
	
public:
	
	static CCScene* scene();
	void randomBall(size_t num);	
	bool CheckPath(int x1, int y1, int x2, int y2);
	virtual bool init();
	virtual void release();
	virtual void ccTouchesEnded(CCSet* touches, CCEvent* event);
	CREATE_FUNC(GameLayer);

	

};

#endif
