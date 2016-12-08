import std.algorithm;
import std.conv;
import std.digest.digest;
import std.digest.md;
import std.stdio;


void main (string[] args)
{
  //"ugkcyxxp".findPassword.writeln;
  "ugkcyxxp".findHarderPassword.writeln;
}

unittest
{
  //auto password = "abc".findPassword;
  //auto expected = "18F47A30";
  //assert(password == expected, "Expected " ~ expected ~ ", got " ~ password);
}
string findPassword(string id)
{
  int index = 0;

  char[8] password;
  
  char[32] hash;// = (id ~ index.to!string).hexDigest!MD5;
  
  for (int passwordIndex = 0; passwordIndex < password.length; passwordIndex++)
  {
    hash = findNextHash(id, index);
    password[passwordIndex] = hash[5];
    hash = (id ~ index.to!string).hexDigest!MD5;
  }
  
  return password.to!string;
}

char[32] findNextHash(string id, ref int index)
{
  char[32] hash = (id ~ index.to!string).hexDigest!MD5;
  
  while (hash[0..5] != ['0','0','0','0','0'])
  {
    auto test = (id ~ index.to!string);
    hash = test.hexDigest!MD5;
    index++;
  }
  
  return hash;
}

unittest
{
  auto password = "abc".findHarderPassword;
  auto expected = "05ACE8E3";
  assert(password == expected, "Expected " ~ expected ~ ", got " ~ password);
}
string findHarderPassword(string id)
{
  int index = 0;
  char[8] password = '_';
  
  writeln("finding password for id ", id);
  
  auto hit = 0;
  //while (password.any!(c => c == 0))
  while (hit < 8)
  {
    auto hash = findNextHash(id, index);
    
    int pos = hash[5].to!string.to!int(16);
    
    //writeln("found hash ", hash, " at index ", index, ", pos ", pos, ", password is ", password);
    
    if (pos < 8 && password[pos] == '_')
    {
      hit++;
      password[pos] = hash[6];
      
      writeln("hit at index ", index, ", password now ", password.to!string);
    }
  }
  
  return password.to!string;
}
