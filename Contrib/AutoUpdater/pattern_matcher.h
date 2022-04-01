#ifndef __PATTERN_MATCHER_H__
#define __PATTERN_MATCHER_H__
#include "windows.h"
#include <string>
#include <sstream>
#include <vector>
#include "match.h"
class Match;
using Matches = std::vector<Match>;

class PatternMatcher
{
	public:
		PatternMatcher(BYTE *buffer, DWORD size, DWORD realBaseAddress, DWORD outputBaseAddress);

		void load(std::string pattern);
		Matches matches();
		Matches matches(std::string pattern);

		BYTE *getBuffer() { return _buffer; };
		DWORD getSize() { return _size; };
		DWORD getRealBaseAddress() const { return _realBaseAddress; };
		DWORD getOutputBaseAddress() const { return _outputBaseAddress; };
	private:
		BYTE *_buffer;
		DWORD _size;
		DWORD _realBaseAddress;
		DWORD _outputBaseAddress;
		std::string _pattern;
		std::vector<BOOL> _mask;
		std::vector<BYTE> _values;
};
#endif
