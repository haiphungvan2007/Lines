#ifndef GAMESTATE_H__
#define GAMESTATE_H__
typedef enum BallState_enum
{
	EMPTY=0,
	NORMAL,
	SELECTED,
	MOVING,
	BUZZ,
	SHOWING,
	WAITING
}BallState;

typedef enum BallColor_enum
{	
	RED,		//0
	BLUE,		//1
	YELLOW,		//2
	GREEN,		//3
	PURPLE,		//4
	PINK,		//5
	BLACK		//6
}BallColor;




#define BALL_WIDTH 53.0f
#define BALL_HEIGHT 53.0f

#define DELAY_BLINK 0.1f
#define DELAY_SHOWING 0.1f
#define DELAY_MOVING 0.1f

#define BOARD_X 17.5f
#define BOARD_Y 273.5f


#endif
