
#include <bar1.h>
#include <bar2.h>

#include<stdio.h> 
#include<string.h> 

class ABC {
public:
	ABC() 
		: _str(nullptr)
	{}
	ABC(const char* in)
	{
		_str = strdup(in);
	}
	~ABC() {}

	ABC(const ABC &in) {
		_str = in._str;
	}
private:
	const char* _str;
};

int main(int argc, const char* argv[] ) 
{
	
	ABC abc("tom the best");
	bar1_hello();
	bar2_hello();
	return 0;
}