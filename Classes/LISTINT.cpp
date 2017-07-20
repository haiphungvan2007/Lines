#include "LISTINT.h"
#include <stdlib.h>

LISTINT::LISTINT()
{
	this->pointer=NULL;
	this->size=0;
}

LISTINT::~LISTINT()
{
	clear();
}

void LISTINT:: clear()
{
	while(this->size!=0)
	{
		remove(0);
	}
	size=0;
}

void LISTINT:: add(int value)
{
	NodeList *temp;
	temp=new NodeList;
	temp->info=value;
	temp->pre=pointer;
	pointer=temp;


	this->size++;
}

int LISTINT:: getValue(int pos)
{

	NodeList* temp;

	temp=pointer;

	for(int i=0;i<pos;i++)
	{				
		temp=temp->pre;
	}

	return temp->info;
}

void LISTINT:: remove(int pos)
{

	if(this->size!=0)
	{


		NodeList* temp;
		NodeList* tempPre;
		NodeList* tempNext;



		if(pos==0)
		{
			temp=pointer;					
			pointer=pointer->pre;				
			delete temp;
		}


		else
		{

			tempNext=pointer;						
			for(int i=0;i<pos-1;i++)
			{				
				tempNext=tempNext->pre;						
			}

			temp=tempNext->pre;

			tempNext->pre=temp->pre;

			delete temp;
		}


		this->size--;
	}

	
}

void LISTINT::removeValue(int value)
{
	int i;
	NodeList* temp;
	int x;

	temp=pointer;
	for(i=0;i<size;i++)
	{
		x=temp->info;
		if(x==value)
		{
			remove(i);
			break;
		}

		else
		{
			temp=temp->pre;
		}
	}
}