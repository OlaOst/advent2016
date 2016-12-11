import std.algorithm;
import std.array;
import std.conv;
import std.range;
import std.stdio;


void main(string[] args)
{
  auto tlsMatches = "day7.1.input".File.byLine.filter!(line => line.supportsTLS).array;
  tlsMatches.count.writeln;
  
  auto sslMatches = "day7.1.input".File.byLine.filter!(line => line.supportsSSL).array;
  sslMatches.count.writeln;
}

unittest
{
  assert("nope[nahh]hmmm[ehhh]".supportsTLS == false);
  assert("nope[nahh]hmmm[ehhh]okko".supportsTLS);
  assert("abba[abcd]hmmm[baab]okko".supportsTLS == false);
  
  assert("abba[mnop]qrst".supportsTLS);
  assert("abcd[bddb]xyyx".supportsTLS == false);
  assert("aaaa[qwer]tyui".supportsTLS == false);
  assert("ioxxoj[asdfgh]zxcvbn".supportsTLS);
  assert("ioxxoj[asbaabdfgh]zxcvbn".supportsTLS == false);
}
bool supportsTLS(Input)(Input ip)
{
  auto parts = ip.splitter('[').map!(part => part.splitter(']')).filter!(part => !part.empty).join;
  
  if (parts.length % 2 == 1)
    parts ~= [' '];
    
  return parts.chunks(2).all!(part => part[1].isABBA == false) && parts.chunks(2).any!(part => part[0].isABBA);
}

bool isABBA(Input)(Input part)
{
  if (part.length < 4)
    return false;
    
  for (int index = 0; index < part.length-3; index++)
  {
    if (part[index .. index + 4].isABBAInternal)
      return true;
  }
  return false;
}

bool isABBAInternal(Input)(Input letters)
{
  return letters[0] == letters[3] && letters[0] != letters[1] && letters[1] == letters[2];
}

unittest
{
  assert("aba[bab]xyz".supportsSSL);
  assert("xyx[xyx]xyx".supportsSSL == false);
  assert("aaa[kek]eke".supportsSSL);
  assert("zaqzbz[bzb]cdb".supportsSSL);
}
bool supportsSSL(Input)(Input ip)
{
  auto parts = ip.splitter('[').map!(part => part.splitter(']')).filter!(part => !part.empty).join.array;
    
  auto superParts = parts.stride(2);
  auto hyperParts = parts[1..$].stride(2);
  
  auto superABAs = sort(superParts.map!(part => part.getABAs).join).uniq;
  auto hyperABAs = sort(hyperParts.map!(part => part.getABAs).join).uniq;
  
  return hyperABAs.any!(aba => superABAs.canFind(aba.reversedABA));
}

char[3][] getABAs(Input)(Input part)
{  
  char[3][] abas;
    
  for (int index = 0; index < part.length-2; index++)
  {
    if (part[index .. index + 3].isABA)
      abas ~= part[index .. index + 3].to!(char[])[0..3];
  }
  
  return abas;
}

bool isABA(Input)(Input part)
{
  if (part.length < 3)
    return false;
    
  return part[0] != part[1] && part[0] == part[2];
}

unittest
{
  assert("aza".reversedABA == "zaz");
}
char[3] reversedABA(char[3] aba)
{
  return [aba[1], aba[0], aba[1]];
}
