import std.algorithm;
import std.array;
import std.conv;
import std.range;
import std.stdio;


void main(string[] args)
{
  "day6.1.input".File.byLine.corrected.writeln;
  "day6.1.input".File.byLine.moreCorrected.writeln;
}

unittest
{
  auto input = 
"eedadn
drvtee
eandsr
raavrd
atevrs
tsrnev
sdttsa
rasrtv
nssdts
ntnada
svetve
tesnvt
vntsnd
vrdear
dvrsen
enarar";

  assert(input.splitter("\n").corrected == "easter");
}
string corrected(Input)(Input input)
{
  auto copy = input.map!(line => line.array).array;
  
  //copy.dup.transposed.map!(line => line.array.sort.group).each!writeln;
  
  return copy.transposed
             .map!(line => line.array
                               .sort
                               .group
                               .maxElement!(g => g[1]))
             .map!(g => g[0].to!string)
             .join;
}


unittest
{
  auto input = 
"eedadn
drvtee
eandsr
raavrd
atevrs
tsrnev
sdttsa
rasrtv
nssdts
ntnada
svetve
tesnvt
vntsnd
vrdear
dvrsen
enarar";

  assert(input.splitter("\n").moreCorrected == "advent");
}
string moreCorrected(Input)(Input input)
{
  auto copy = input.map!(line => line.array).array;
  
  //copy.dup.transposed.map!(line => line.array.sort.group).each!writeln;
  
  return copy.transposed
             .map!(line => line.array
                               .sort
                               .group
                               .minElement!(g => g[1]))
             .map!(g => g[0].to!string)
             .join;
}
