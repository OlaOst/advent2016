import std.algorithm;
import std.array;
import std.conv;
import std.file;
import std.range;
import std.stdio;


void main(string args[])
{
  auto values = "day3.1.input".File.byLine.map!(line => line.strip(' ')
                                                            .splitter(" ")
                                                            .map!(number => number.strip(' '))
                                                            .filter!(number => number.length > 0)
                                                            .map!(number => number.to!int)
                                                            .array).array;

  values.count!(value => value.isValidTriangle).writeln;
  
  auto transposedValues = values.dup.transposed.join.chunks(3);
  
  assert(values.count == transposedValues.count);
  
  values[0..9].writeln;
  transposedValues[0..9].writeln;
  
  //transposedValues[0].writeln;
  //transposedValues[$-1].writeln;
  
  transposedValues.count!(value => value.isValidTriangle).writeln;
}

unittest
{
  assert([5, 10, 25].isValidTriangle == false);
  assert([5, 25, 10].isValidTriangle == false);
  assert([10, 5, 25].isValidTriangle == false);
  assert([10, 25, 5].isValidTriangle == false);
  assert([25, 5, 10].isValidTriangle == false);
  assert([25, 10, 5].isValidTriangle == false);
}

bool isValidTriangle(Input)(Input sides)
{
  auto sorted = sides.dup.sort;
  
  return sorted[0] + sorted[1] > sorted[2];
}
