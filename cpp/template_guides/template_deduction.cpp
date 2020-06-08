//example for class deduction; need compile with option /std:c++17

#include <iostream>
#include <string>
#include <vector>

template<typename T>
class Stack
{
	public:
	Stack() = default;
	
	// first approach: declare ctor uses value for initialisation ( allow using decay for  char array  case )
	//Stack(  T element ) : 
	//	storage( { element } )
	//{}
	
	// second approach: using deduction guide for convert const char* -> std::string
	Stack(  const T& element ) : 
		storage( { element } )
	{}
	
	void push(const T& element)
	{
		storage.push_back(element);
	}
	
	T pop();
	const T& top() const;
	
	bool isEmpty()
	{
		return storage.empty();
	}
	
	void printOn(std::ostream& strm) const
	{
			for(const auto& element : storage)
			{
				strm << element << " ";
			}
			
			strm << std::endl;
	}
	
	private:
	std::vector<T> storage;
};


template<typename T>
T Stack<T>::pop()
{
	assert(!isEmpty());
	
	T element = storage.back();
	storage.pop_back();
	
	return element;
}

template<typename T>
const T& Stack<T>::top() const
{
	assert(!isEmpty());
	return storage.back();
}

Stack(const char* ) -> Stack<std::string>;

int main(int argc, const char* argv[])
{
	// first approach allows to use copy initialisation
	//Stack st =  "hello";
	
	// second approach does not allow using copy initialisation
	// Stack st{ "hello2" };
	Stack st = { "hello3" };
	
	st.printOn(std::cout);
	
	return 0;
}