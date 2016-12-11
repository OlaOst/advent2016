import std.conv;
import std.stdio;


void main(string args[])
{
  auto mapping = createMapping();
  
  char current = '5';
  foreach (line; File("day2.1.input").byLine)
  {
    current = getCode(mapping, line, current);
    write(current.to!string);
  }
  
  writeln;
  auto advancedMapping = createAdvancedMapping();
  current = '5';
  foreach (line; File("day2.1.input").byLine)
  {
    current = getCode(advancedMapping, line, current);
    write(current.to!string);
  }
}


char[char][char] createMapping()
{
  char[char][char] mapping;

  mapping['1']['U'] = '1';
  mapping['1']['L'] = '1';
  mapping['1']['D'] = '4';
  mapping['1']['R'] = '2';

  mapping['2']['U'] = '2';
  mapping['2']['L'] = '1';
  mapping['2']['D'] = '5';
  mapping['2']['R'] = '3';

  mapping['3']['U'] = '3';
  mapping['3']['L'] = '2';
  mapping['3']['D'] = '6';
  mapping['3']['R'] = '3';

  mapping['4']['U'] = '1';
  mapping['4']['L'] = '4';
  mapping['4']['D'] = '7';
  mapping['4']['R'] = '5';

  mapping['5']['U'] = '2';
  mapping['5']['L'] = '4';
  mapping['5']['D'] = '8';
  mapping['5']['R'] = '6';

  mapping['6']['U'] = '3';
  mapping['6']['L'] = '5';
  mapping['6']['D'] = '9';
  mapping['6']['R'] = '6';

  mapping['7']['U'] = '4';
  mapping['7']['L'] = '7';
  mapping['7']['D'] = '7';
  mapping['7']['R'] = '8';

  mapping['8']['U'] = '5';
  mapping['8']['L'] = '7';
  mapping['8']['D'] = '8';
  mapping['8']['R'] = '9';

  mapping['9']['U'] = '6';
  mapping['9']['L'] = '8';
  mapping['9']['D'] = '9';
  mapping['9']['R'] = '9';
  
  return mapping;
}

char[char][char] createAdvancedMapping()
{
  char[char][char] mapping;

  mapping['1']['U'] = '1';
  mapping['1']['L'] = '1';
  mapping['1']['D'] = '3';
  mapping['1']['R'] = '1';
  
  mapping['2']['U'] = '2';
  mapping['2']['L'] = '2';
  mapping['2']['D'] = '6';
  mapping['2']['R'] = '3';
  
  mapping['3']['U'] = '1';
  mapping['3']['L'] = '2';
  mapping['3']['D'] = '7';
  mapping['3']['R'] = '4';
  
  mapping['4']['U'] = '4';
  mapping['4']['L'] = '3';
  mapping['4']['D'] = '8';
  mapping['4']['R'] = '4';
  
  mapping['5']['U'] = '5';
  mapping['5']['L'] = '5';
  mapping['5']['D'] = '5';
  mapping['5']['R'] = '6';
  
  mapping['6']['U'] = '2';
  mapping['6']['L'] = '5';
  mapping['6']['D'] = 'A';
  mapping['6']['R'] = '7';
  
  mapping['7']['U'] = '3';
  mapping['7']['L'] = '6';
  mapping['7']['D'] = 'B';
  mapping['7']['R'] = '8';
  
  mapping['8']['U'] = '4';
  mapping['8']['L'] = '7';
  mapping['8']['D'] = 'C';
  mapping['8']['R'] = '9';
  
  mapping['9']['U'] = '9';
  mapping['9']['L'] = '8';
  mapping['9']['D'] = '9';
  mapping['9']['R'] = '9';
  
  mapping['A']['U'] = '6';
  mapping['A']['L'] = 'A';
  mapping['A']['D'] = 'A';
  mapping['A']['R'] = 'B';
  
  mapping['B']['U'] = '7';
  mapping['B']['L'] = 'A';
  mapping['B']['D'] = 'D';
  mapping['B']['R'] = 'C';
  
  mapping['C']['U'] = '8';
  mapping['C']['L'] = 'B';
  mapping['C']['D'] = 'C';
  mapping['C']['R'] = 'C';
  
  mapping['D']['U'] = 'B';
  mapping['D']['L'] = 'D';
  mapping['D']['D'] = 'D';
  mapping['D']['R'] = 'D';
  
  return mapping;
}

unittest
{
  auto mapping = createMapping();
  assert(getCode(mapping, "ULL", '5') == '1');
  assert(getCode(mapping, "RRDDD", '1') == '9');
  assert(getCode(mapping, "LURDL", '9') == '8');
  assert(getCode(mapping, "UUUUD", '8') == '5');
  
  auto advancedMapping = createAdvancedMapping();
  assert(getCode(advancedMapping, "ULL", '5') == '5');
  assert(getCode(advancedMapping, "RRDDD", '5') == 'D');
  assert(getCode(advancedMapping, "LURDL", 'D') == 'B');
  assert(getCode(advancedMapping, "UUUUD", 'B') == '3');
}

char getCode(Input)(char[char][char] mapping, Input line, char start)
{
  char current = start;
  foreach (letter; line)
  {
    current = mapping[current][letter];
  }
  return current;
}
