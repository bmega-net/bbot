#include "match.h"

Match::Match(DWORD offset, PatternMatcher *matcher)
{
	_offset = offset;
	_matcher = matcher;
};

DWORD Match::getRealValue() const
{
	BYTE *buffer = _matcher->getBuffer() + _offset;
	DWORD res = *buffer;
	res += *(++buffer) << 8;
	res += *(++buffer) << 16;
	res += *(++buffer) << 24;
	return res;
};

DWORD Match::getValue() const
{
	return getRealValue() - _matcher->getRealBaseAddress() + _matcher->getOutputBaseAddress();

};

DWORD Match::getAddress() const
{
	return _offset + _matcher->getOutputBaseAddress();
};

Match Match::followJump()
{
	return followOffset(getRealValue() + 4);
};

Match Match::followOffset(DWORD offset)
{
	DWORD newOffset = _offset + offset;
	if(newOffset < _matcher->getSize())
		return Match(newOffset, _matcher);
	else
		throw "followOffset() out of bounds";
};

std::ostream& operator<<(std::ostream& os, const Match& m)
{
	os << "{0x" << std::uppercase <<
		std::hex << (int)m.getAddress() << "=" << (int)m.getValue() << "}";
	return os;
};
