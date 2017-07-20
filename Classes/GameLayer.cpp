#include "GameLayer.h"
#include "GameConstants.h"

using namespace cocos2d;

CCScene* GameLayer::scene()
{
    // 'scene' is an autorelease object
    CCScene *scene = CCScene::create();

    // 'layer' is an autorelease object
    GameLayer *layer = GameLayer::create();

    // add layer as a child to scene
    scene->addChild(layer);

	


    // return the scene
    return scene;
}

void GameLayer::release()
{	
	for(int i=0;i<9;i++)
	{
		for(int j=0; j<9; j++)
		{
			this->ballList[i][j]->release();
		}
	}
	GameLayer::release();
}

bool GameLayer::init()
{
	if(!CCLayer::init())
	{
		return false;
	}

	preX = -1;
	preY = -1;
	curX = -1;
	curY = -1;	
	remainColumn=81;

	isSelected=false;
	isEating=false;
	isShowPreGen=true;
	isShowPath=true;

	for(int i=0;i<9;i++)
	{
		for(int j=0; j<9; j++)
		{
			float tempX = BOARD_X+ BALL_WIDTH*(float)i;
			float tempY = BOARD_Y + BALL_HEIGHT*(float)j;
			this->ballList[i][j]=Ball::create();						
			this->ballList[i][j]->retain();
			
			this->ballList[i][j]->setAnchorPoint(CCPointMake(0,1));
			this->ballList[i][j]->setPosition(CCPointMake(tempX, tempY));
			this->pointList.push_back(j*9 +i);
			this->ballList[i][j]->setStatus(EMPTY);	
			this->ballList[i][j]->isVisited = false;
			this->addChild(ballList[i][j]);
		}
	}

	for (int i =0 ; i < 3; i++)
	{
		nexBallSprite[i] = Ball::create();		
		nexBallSprite[i]->retain();
		nexBallSprite[i]->setColor(RED);
		nexBallSprite[i]->setStatus(NORMAL);
		nexBallSprite[i]->setAnchorPoint(CCPointMake(0,1));
		
		float tempX = BOARD_X + BALL_WIDTH*(float)(i+3);
		float tempY = BOARD_Y + BALL_HEIGHT*(float)(11);
		nexBallSprite[i]->setPosition(CCPointMake(tempX, tempY));
		this->addChild(nexBallSprite[i]);
	}


	ResetGame();

	
	setTouchEnabled(true);
	return true;
}

int GameLayer::RangedRandom(int range_min, int range_max)
{

	int u = (double)rand() / (RAND_MAX + 1) * (range_max - range_min)+ range_min;
	return u;
}

//Khoi tao game
void GameLayer::ResetGame()
{
	int i,j;
	int x,y;

	int random;
	int pos;
	int color;	

	score=0;
	while (!gameSteps.empty())
	{
		gameSteps.pop();
	}

	remainingList.clear();

	for(i=0;i<9;i++)
		for(j=0;j<9;j++)
		{
			ballList[i][j]->setStatus(EMPTY);	
			ballList[i][j]->isVisited=false;	

		}		


		for(i=0;i<81;i++)
		{
			remainingList.add(i);
		}



		for(i=0;i<5;i++)
		{
			random=RangedRandom(0,remainColumn);
			pos=remainingList.getValue(random);
			x=GETX(pos);
			y=GETY(pos);
			color=RangedRandom(0,7);			
			ballList[x][y]->setColor(color);
			ballList[x][y]->setStatus(SHOWING);
			remainingList.remove(random);
			remainColumn--;
		}


		PreGen();

		char szSocre[20];
		sprintf_s(szSocre, 20, "%d",score);
		currentScoreText = CCLabelTTF::create();
		currentScoreText->setFontName("Marker Felt.ttf");
		currentScoreText->setFontSize(40);	
		currentScoreText->setString(szSocre);
		currentScoreText->setPosition(CCPointMake(20, 900));
		this->addChild(currentScoreText);
}

void GameLayer::randomBall(size_t num)
{
	int loop=num;
	srand(static_cast<unsigned int>(time(0)));
	if(this->pointList.size() < num)
	{
		loop=this->pointList.size();
	}

	for(int i=0; i<loop; i++)
	{
		int ran=(rand() % (pointList.size()));
		int pos=pointList[ran];		

		int color= rand() % 7;
		int x, y;
		y=pos/9;
		x=pos%9;


		this->ballList[x][y]->setColor(color);
		this->ballList[x][y]->setStatus(SHOWING);	

		std::vector<int>::iterator it=pointList.begin();
		it += ran;
		this->pointList.erase(it);
	}
}

void GameLayer::PreGen()
{
	int temp;
	int i,j;
	int random;
	int pos;
	int x,y;
	int color;

	remainColumn=81;

	remainingList.clear();

	for (i=0;i<9;i++)
		for (j=0;j<9;j++)
		{

			if ((ballList[i][j]->status==NORMAL)
				||(ballList[i][j]->status==SELECTED)
				||(ballList[i][j]->status==WAITING)
				||(ballList[i][j]->status==SHOWING))
			{
				remainColumn--;
			}

			else 
			{
				remainingList.add(GETPOS(i,j));
			}
		}



		temp=MIN(3,remainColumn);


		if(temp==0)		
		{
			/*
			HighScore highScore;			
			if(!isEating)
			{
				CCUserDefault::sharedUserDefault()->get



				if(fr==NULL)
				{
					for(i=0;i<10;i++)
					{
						wcscpy(highScore.scores[i].name,_T("Còn trống"));
						highScore.scores[i].score=0;
					}
				}

				else
				{
					if(fread(&highScore,sizeof(HighScore),1,fr)==0)
					{
						for(i=0;i<10;i++)
						{
							wcscpy(highScore.scores[i].name,_T("Còn trống"));
							highScore.scores[i].score=0;
						}	
					}				

					fclose(fr);
				}


				if(highScore.scores[9].score<score)
				{
					EnterNameDlg dlg;
					dlg.init(score);
					ResetGame();

					isInvalidated=false;
					if(dlg.DoModal()==IDOK)
					{
						isInvalidated=true;
					}

					else
					{
						isInvalidated=true;
					}
				}


				return;
			}
			*/
		}



		if(!isEating)
		{		
			for(i=0;i<temp;i++)
			{

				random=RangedRandom(0,remainColumn);
				pos=remainingList.getValue(random);
				x=GETX(pos);
				y=GETY(pos);
				genPos[i]=pos;
				color=RangedRandom(0,7);;
				colors[i]=color;
				ballList[x][y]->setColor(color);
				ballList[x][y]->setStatus(WAITING);

				remainingList.remove(random);
				remainColumn--;															
			}

			if(temp==0)
			{
				colors[0]=0;
				colors[1]=0;
				colors[2]=0;

				genPos[0]=-1;
				genPos[1]=-1;
				genPos[2]=-1;


			}

			else if(temp==1)
			{
				colors[1]=0;
				colors[2]=0;

				genPos[1]=-1;
				genPos[2]=-1;
			}

			else if (temp==2)
			{
				colors[2]=0;
				genPos[2]=-1;

			}
		}

		for(i=0;i<9;i++)
		{
			for(j=0;j<9;j++)
			{

				if((this->ballList[i][j]->status==NORMAL)
					||(this->ballList[i][j]->status==SELECTED))
				{
					currentStatus.colums[i][j]=this->ballList[i][j]->color;

				}

				else
				{
					currentStatus.colums[i][j]=0;
				}
		
			}
		}

		currentStatus.score=this->score;

		currentStatus.color0=colors[0];
		currentStatus.color1=colors[1];
		currentStatus.color2=colors[2];

		currentStatus.posGen0=genPos[0];
		currentStatus.posGen1=genPos[1];
		currentStatus.posGen2=genPos[2];

		for (int i=0; i<3; i++)
		{
			if (genPos[i] != -1)
			{
				nexBallSprite[i]->setColor(colors[i]);
				nexBallSprite[i]->setStatus(NORMAL);
			}

			else
			{
				nexBallSprite[i]->setStatus(EMPTY);
			}
		}
}

void GameLayer::Generate()
{
	int i;
	int pos;
	int x,y;


	if(!isEating)
	{	
		for (i=0;i<3;i++)
		{
			pos=genPos[i];
			if(pos>=0)
			{
				x=GETX(pos);
				y=GETY(pos);



				if((ballList[x][y]->status==NORMAL)
					||(ballList[x][y]->status==SELECTED))
				{
					AutoGen1();
				}		

				else
				{
					ballList[x][y]->setColor(colors[i]);			
					ballList[x][y]->setStatus(SHOWING);
					CheckScore(x,y);
				}
			}

			else
			{
				break;
			}
		}

		PreGen();
	}
}

void GameLayer::AutoGen1()
{
	int i,j;
	int random;
	int pos;
	int x,y;

	int color;



	remainColumn=81;

	remainingList.clear();

	for (i=0;i<9;i++)
	{
		for (j=0;j<9;j++)
		{
			if ((ballList[i][j]->status==NORMAL)
				||(ballList[i][j]->status==SELECTED)
				||(ballList[i][j]->status==WAITING)
				||(ballList[i][j]->status==SHOWING))
			{
				remainColumn--;
			}

			else
			{
				remainingList.add(GETPOS(i,j));
			}
		}
	}

	random=RangedRandom(0,remainColumn);
	pos=remainingList.getValue(random);
	x=GETX(pos);
	y=GETY(pos);
	color=RangedRandom(0,7);

	ballList[x][y]->setColor(color);			
	ballList[x][y]->setStatus(SHOWING);
	remainingList.remove(random);

	CheckScore(x,y);

}


// tinh diem
bool GameLayer::CheckScore(int x, int y)
{
	int i;
	int tempx, tempy;
	int ngang;
	int doc;
	int cheoTrai;
	int cheoPhai;	
	BOOLEAN result=false;

	int color=ballList[x][y]->color;

	int pos;
	int posX;
	int posY;


	ngangList.clear();
	docList.clear();
	traiList.clear();
	phaiList.clear();


	ngangList.add(GETPOS(x,y));
	docList.add(GETPOS(x,y));
	traiList.add(GETPOS(x,y));
	phaiList.add(GETPOS(x,y));

	ngang=1;
	//kiem tra hang ngang
	for(tempx=x-1;tempx>=0;tempx--)
	{
		if((ballList[tempx][y]->status==NORMAL)
			||(ballList[tempx][y]->status==SELECTED)
			||(ballList[tempx][y]->status==SHOWING))
		{
			if(ballList[tempx][y]->color==color)
			{
				ngang++;
				ngangList.add(GETPOS(tempx,y));
			}

			else
			{
				break;
			}
		}

		else
		{
			break;
		}

	}


	for (tempx=x+1;tempx<9;tempx++)
	{
		if((ballList[tempx][y]->status==NORMAL)
			||(ballList[tempx][y]->status==SELECTED)
			||(ballList[tempx][y]->status==SHOWING))
		{
			if(ballList[tempx][y]->color==color)
			{
				ngang++;
				ngangList.add(GETPOS(tempx,y));
			}

			else
			{
				break;
			}
		}

		else
		{
			break;
		}
	}



	if(ngang>4)
	{
		result=true;
		for(i=0;i<ngangList.size;i++)
		{
			pos=ngangList.getValue(i);
			posX=GETX(pos);
			posY=GETY(pos);
			ballList[posX][posY]->setStatus(BUZZ);
		}
	}

	else
	{
		ngang=0;
	}



	//Kiem tra hang doc
	doc=1;
	for(tempy=y-1;tempy>=0;tempy--)
	{
		if((ballList[x][tempy]->status==NORMAL)
			||(ballList[x][tempy]->status==SELECTED)
			||(ballList[x][tempy]->status==SHOWING))
		{
			if(ballList[x][tempy]->color==color)
			{
				doc++;
				docList.add(GETPOS(x,tempy));
			}

			else
			{
				break;
			}
		}

		else
		{
			break;
		}
	}

	for(tempy=y+1;tempy<9;tempy++)
	{
		if((ballList[x][tempy]->status==NORMAL)
			||(ballList[x][tempy]->status==SELECTED)
			||(ballList[x][tempy]->status==SHOWING))
		{
			if(ballList[x][tempy]->color==color)
			{
				doc++;
				docList.add(GETPOS(x,tempy));
			}

			else
			{
				break;
			}
		}

		else
		{
			break;
		}
	}

	if(doc>4)
	{
		result=true;
		for(i=0;i<docList.size;i++)
		{
			pos=docList.getValue(i);
			posX=GETX(pos);
			posY=GETY(pos);
			ballList[posX][posY]->setStatus(BUZZ);
		}
	}

	else
	{
		doc=0;
	}

	//cheo trai
	cheoTrai=1;
	tempx=x-1;
	tempy=y-1;
	while((tempx>=0)&&(tempy>=0))
	{
		if((ballList[tempx][tempy]->status==NORMAL)
			||(ballList[tempx][tempy]->status==SELECTED)
			||(ballList[tempx][tempy]->status==SHOWING))
		{
			if(ballList[tempx][tempy]->color==color)
			{
				cheoTrai++;
				traiList.add(GETPOS(tempx,tempy));
			}

			else
			{
				break;
			}
		}

		else
		{
			break;
		}
		tempx--;
		tempy--;
	}

	tempx=x+1;
	tempy=y+1;
	while((tempx<9)&&(tempy<9))
	{
		if(ballList[tempx][tempy]->status==NORMAL)
		{
			if(ballList[tempx][tempy]->color==color)
			{
				cheoTrai++;
				traiList.add(GETPOS(tempx,tempy));
			}

			else
			{
				break;
			}
		}

		else
		{
			break;
		}
		tempx++;
		tempy++;
	}

	if(cheoTrai>4)
	{
		result=true;
		for(i=0;i<traiList.size;i++)
		{
			pos=traiList.getValue(i);
			posX=GETX(pos);
			posY=GETY(pos);
			ballList[posX][posY]->setStatus(BUZZ);
		}
	}

	else
	{
		cheoTrai=0;
	}


	//cheo phai
	cheoPhai=1;
	// nua tren
	for(tempx=x-1,tempy=y+1;(tempx>=0)&&(tempy<9);tempx--,tempy++)
	{
		if((ballList[tempx][tempy]->status==NORMAL)
			||(ballList[tempx][tempy]->status==SELECTED)
			||(ballList[tempx][tempy]->status==SHOWING))
		{
			if(ballList[tempx][tempy]->color==color)
			{
				cheoPhai++;
				phaiList.add(GETPOS(tempx,tempy));
			}

			else
			{
				break;
			}
		}

		else
		{
			break;
		}
	}

	//nua tren
	for(tempx=x+1,tempy=y-1;(tempx<9)&&(tempy>=0);tempx++,tempy--)
	{
		if((ballList[tempx][tempy]->status==NORMAL)
			||(ballList[tempx][tempy]->status==SELECTED)
			||(ballList[tempx][tempy]->status==SHOWING))
		{
			if(ballList[tempx][tempy]->color==color)
			{
				cheoPhai++;
				phaiList.add(GETPOS(tempx,tempy));
			}

			else
			{
				break;
			}
		}

		else
		{
			break;
		}
	}

	if(cheoPhai>4)
	{
		result=true;
		for(i=0;i<phaiList.size;i++)
		{
			pos=phaiList.getValue(i);
			posX=GETX(pos);
			posY=GETY(pos);
			ballList[posX][posY]->setStatus(BUZZ);
		}
	}

	else
	{
		cheoPhai=0;
	}

	this->score=this->score+(doc+ngang+cheoPhai+cheoTrai)*2;
	this->isEating=result;

	char szSocre[20];
	sprintf_s(szSocre, 20, "%d",score);	
	currentScoreText->setString(szSocre);
	return result;
}


void GameLayer::ccTouchesEnded(CCSet* touches, CCEvent* event)
{
	CCTouch* pTouch = static_cast<CCTouch*>(touches->anyObject() );
	CCPoint touchLocation= pTouch->getLocation();
	

	//CheckContainPoint(touchLocation)
	boolean found=false;

	int i,j;
	for(i=0;i<9;i++)
	{
		if(!found)
		{		
			for (j=0;j<9;j++)
			{		
				if(ballList[i][j]->CheckContainPoint(touchLocation))
				{
					found=true;
					curX=i;
					curY=j;
					break;
				}
			}
		}
	}

	int pos;
	int x,y;

	if(found)
	{

		if(isSelected)
		{
			// di chuyen
			if((ballList[curX][curY]->status==EMPTY)
				||(this->ballList[curX][curY]->status==WAITING))
			{
				//kiem tra duong di
				if (CheckPath(preX,preY,curX,curY))
				{
					//luu trang thai

					GameStatus tempStatus;
					for(i=0;i<9;i++)
						for(j=0;j<9;j++)
						{

							if((this->ballList[i][j]->status==NORMAL)
								||(this->ballList[i][j]->status==SELECTED))
							{
								tempStatus.colums[i][j]=this->ballList[i][j]->color;

							}

							else
							{
								tempStatus.colums[i][j]=0;
							}

						}
						tempStatus.score=this->score;

						tempStatus.color0=colors[0];
						tempStatus.color1=colors[1];
						tempStatus.color2=colors[2];

						tempStatus.posGen0=genPos[0];
						tempStatus.posGen1=genPos[1];
						tempStatus.posGen2=genPos[2];


						gameSteps.push(tempStatus);


						//danh dau duong di
						while(!pathStack.empty())
						{
							pos=pathStack.top();
							x=GETX(pos);
							y=GETY(pos);
							//ballList[x][y].setMoving(ballList[preX][preY]->color);
							pathStack.pop();
						}


						ballList[preX][preY]->setStatus(EMPTY);
						ballList[curX][curY]->setColor(ballList[preX][preY]->color);
						ballList[curX][curY]->setStatus(NORMAL);
						isSelected=false;
						remainingList.add(preY*9+preX);
						remainingList.removeValue(curY*9+curX);
						CheckScore(curX,curY);
						Generate();

						for(i=0;i<9;i++)
							for(j=0;j<9;j++)
							{

								if((this->ballList[i][j]->status==NORMAL)
									||(this->ballList[i][j]->status==SELECTED))
								{
									currentStatus.colums[i][j]=this->ballList[i][j]->color;

								}

								else
								{
									currentStatus.colums[i][j]=0;
								}

							}
							currentStatus.score=this->score;

							currentStatus.color0=colors[0];
							currentStatus.color1=colors[1];
							currentStatus.color2=colors[2];

							currentStatus.posGen0=genPos[0];
							currentStatus.posGen1=genPos[1];
							currentStatus.posGen2=genPos[2];
				}

				else
				{
				}

			}

			else if(ballList[curX][curY]->status==NORMAL)
			{
				ballList[preX][preY]->setStatus(NORMAL);
				ballList[curX][curY]->setStatus(SELECTED);
				preX=curX;
				preY=curY;
				isSelected=true;
			}

		}

		else
		{
			if(ballList[curX][curY]->status==NORMAL)
			{

				ballList[curX][curY]->setStatus(SELECTED);
				preX=curX;
				preY=curY;
				isSelected=true;
			}
		}

	}
	
}

bool GameLayer::CheckPath(int x1, int y1, int x2, int y2)
{
	BOOLEAN result=false;

	int i,j;
	for (i=0;i<9;i++)
		for (j=0;j<9;j++)
		{

			if((ballList[i][j]->status==EMPTY)
				||(ballList[i][j]->status==WAITING))
			{
				ballList[i][j]->isVisited=false;
			}

			else
			{
				ballList[i][j]->isVisited=true;
			}

		}


		ballList[x1][y1]->isVisited=true;



		int xTop;
		int yTop;
		int top;

		xTop=x1;
		yTop=GET_TOPY(y1);
		top=GETPOS(xTop,yTop);

		int xBottom;
		int yBottom;
		int bottom;
		xBottom=x1;
		yBottom=GET_BOTTOMY(y1);
		bottom=GETPOS(xBottom,yBottom);


		int xLeft;
		int yLeft;
		int left;
		xLeft=GET_LEFTX(x1);
		yLeft=y1;
		left=GETPOS(xLeft,yLeft);

		int xRight;
		int yRight;
		int right;
		xRight=GET_RIGHTX(x1);
		yRight=y1;
		right=GETPOS(xRight,yRight);

		while(!columQueu.empty())
		{
			columQueu.pop();	
		}



		int position=GETPOS(x1,y1);
		if (!ballList[xTop][yTop]->isVisited)
		{
			path[top]=position;
			columQueu.push(top);
		}

		if (!ballList[xBottom][yBottom]->isVisited)
		{
			path[bottom]=position;
			columQueu.push(bottom);
		}

		if (!ballList[xLeft][yLeft]->isVisited)
		{
			path[left]=position;
			columQueu.push(left);
		}

		if (!ballList[xRight][yRight]->isVisited)
		{
			path[right]=position;
			columQueu.push(right);
		}


		int tempPos;
		int tempx;
		int tempy;


		while(!pathStack.empty())
		{
			pathStack.pop();
		}


		//int tempSize;
		while((!result)&&(!columQueu.empty()))
		{	
			tempPos=columQueu.front();
			columQueu.pop();
			tempx=GETX(tempPos);
			tempy=GETY(tempPos);




			if((tempx==x2)&&(tempy==y2))
			{
				result=true;		

				// 				int prePos=tempPos;
				// 				while(prePos!=GETPOS(x1,y1))
				// 				{
				// 					pathStack.push(prePos);
				// 					prePos=path[tempPos];
				// 				}

				break;
			}

			else
			{

				if(!ballList[tempx][tempy]->isVisited)
				{
					ballList[tempx][tempy]->isVisited=true;

					xTop=tempx;
					yTop=GET_TOPY(tempy);
					top=GETPOS(xTop,yTop);

					xBottom=tempx;
					yBottom=GET_BOTTOMY(tempy);
					bottom=GETPOS(xBottom,yBottom);

					xLeft=GET_LEFTX(tempx);
					yLeft=tempy;
					left=GETPOS(xLeft,yLeft);

					xRight=GET_RIGHTX(tempx);
					yRight=tempy;
					right=GETPOS(xRight,yRight);

					if (!ballList[xTop][yTop]->isVisited)
					{
						path[top]=tempPos;
						columQueu.push(top);
					}

					if (!ballList[xBottom][yBottom]->isVisited)
					{
						path[bottom]=tempPos;
						columQueu.push(bottom);
					}

					if (!ballList[xLeft][yLeft]->isVisited)
					{
						path[left]=tempPos;
						columQueu.push(left);
					}

					if (!ballList[xRight][yRight]->isVisited)
					{
						path[right]=tempPos;
						columQueu.push(right);
					}
				}		

			}

		}

		return result;
}