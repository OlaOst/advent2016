import std.algorithm;
import std.array;
import std.conv;
import std.stdio;
import std.range;


void main(string args[])
{
  //File("day4.1.input").byLine.map!(line => line.getSectorIdIfRealRoom).sum.writeln;
  File("day4.1.input").byLine.filter!(line => line.getSectorIdIfRealRoom > 0).map!(line => line.decrypted).filter!(room => room.canFind("north")).each!writeln;
}

unittest
{
  assert("aaaaa-bbb-z-y-x-123[abxyz]".getSectorIdIfRealRoom == 123);
  assert("a-b-c-d-e-f-g-h-987[abcde]".getSectorIdIfRealRoom == 987);
  assert("not-a-real-room-404[oarel]".getSectorIdIfRealRoom == 404);
  assert("totally-real-room-200[decoy]".getSectorIdIfRealRoom == 0);
}
int getSectorIdIfRealRoom(Input)(Input name)
{
  auto parts = name.splitter('-').array;
  auto letters = parts[0..$-1].join.array.sort.group.array.sort!((a,b) => (a[1] == b[1]) ? (a[0] < b[0]) : (a[1] > b[1])).map!(g => g[0]).take(5).to!string;
  auto lastParts = parts[$-1].split('[');
  auto sectorId = lastParts[0].to!int;
  auto checksum = lastParts[1][0..$-1];
  
  //writeln("letters: ", letters, ", sectorId: ", sectorId, ", checksum: ", checksum);
  
  if (letters == checksum)
    return sectorId;
  else
    return 0;
}

unittest
{
  assert("qzmt-zixmtkozy-ivhz-343".decrypted == "343 very encrypted name");
}
string decrypted(Input)(Input name)
{
  auto parts = name.splitter('-').array;
  auto letters = parts[0..$-1].join(' ').array;
  auto lastParts = parts[$-1].split('[');
  auto sectorId = lastParts[0].to!int;
  
  auto decrypted = letters.map!(letter => (letter != ' ') ? (((letter - 'a' + sectorId) % 26) + 'a').to!dchar : letter).to!string;
  
  //writeln("letters: ", letters, ", decrypted: ", decrypted);
  
  return sectorId.to!string ~ " " ~ decrypted;
}
