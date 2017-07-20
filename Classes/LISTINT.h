#pragma once


struct NodeList 
{
	int info;
	NodeList* pre;

};

typedef NodeList* LIST;

class LISTINT
{

private:
	LIST pointer;

public:
	int size;
	LISTINT(void);
	~LISTINT(void);
	void add(int value);
	int getValue(int pos);
	void remove(int pos);
	void removeValue(int value);
	void clear();
};
