#include "pattern_matcher.h"

PatternMatcher::PatternMatcher(BYTE *buffer, DWORD size, DWORD realBaseAddress, DWORD outputBaseAddress)
	: _buffer(buffer), _size(size), _realBaseAddress(realBaseAddress), _outputBaseAddress(outputBaseAddress), _pattern("")
{
};

void PatternMatcher::load(std::string pattern)
{
	_pattern = pattern;
	std::stringstream ss{pattern};
	std::string tok;
	_mask.clear();
	_values.clear();
	while(ss >> tok)
	{
		bool isMask = tok == "?";
		DWORD value = 0;
		if(!isMask)
		{
			std::stringstream cValue;
			cValue << std::hex << tok;
			cValue >> value;
		}
		_mask.push_back(isMask);
		_values.push_back(value);
	}
};

Matches PatternMatcher::matches()
{
	Matches ms;
	for(unsigned int i = 0; i < _size; i++)
	{
		for(unsigned int j = 0; j < _mask.size(); j++)
		{
			if(_mask[j])
					continue;
			if(_buffer[i + j] != _values[j])
				break;
			if(j == _values.size() - 1)
			{
				ms.emplace_back(i, this);
				i += _mask.size() - 1;
			}
		}
	}	
	return ms;
};

Matches PatternMatcher::matches(std::string pattern)
{
	load(pattern);
	return matches();
};
