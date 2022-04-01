#ifndef __MATCH_H__
#define __MATCH_H__
#include "windows.h"
#include <iostream>
#include "pattern_matcher.h"
class PatternMatcher;
class Match
{
	public:
		Match(DWORD offset, PatternMatcher *matcher);

		DWORD getValue() const;
		DWORD getAddress() const;

		Match followJump();
		Match followOffset(DWORD offset);
	private:
		DWORD getRealValue() const;
		PatternMatcher *_matcher;
		DWORD _offset;
};

std::ostream& operator<<(std::ostream& os, const Match& m);
#endif
