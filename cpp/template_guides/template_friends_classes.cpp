// example of friend in template class

#include <iostream>
#include <vector>

// For friend declaration operator<< we need  forward declaration of template version of operator<<
template<typename T>
class Stack;
template<typename T>

std::ostream& operator<<(std::ostream& , const Stack<T>&);

template<typename T>
class Stack
{
	public:
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
	
	private:
	void printOn(std::ostream& strm) const
	{
			for(const auto& element : storage)
			{
				strm << element << " ";
			}
			
			strm << std::endl;
	}
	
	friend std::ostream& operator<< <T>(std::ostream& , const Stack<T>&);
	
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

template<typename T>
std::ostream& operator<<(std::ostream&  strm, const Stack<T>& stack)
{
	stack.printOn(strm);
	return strm;
}


//friend declaration inside template class
template<class T>
class AddSpace
{
public:
	AddSpace(const T& value) : m_ref(value)
	{}

	friend std::ostream& operator<<(std::ostream& stream, const AddSpace<T>& spc)
	{
		return stream << spc.m_ref << ' ';		
	}

private:
	const T& m_ref;
};


namespace
{
	template<class ... Args>
	void print(const Args& ... args)
	{
		( std::cout << ... << AddSpace(args) ) << std::endl;
	}
}

int main(int argc, const char* argv[])
{
	Stack<int> st;
	st.push(1);
	st.push(2);
	st.push(3);
	
	std::cout << st << std::endl;

	print('a', 1, 'b', 2);

	return 0;
}