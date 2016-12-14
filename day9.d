import std.algorithm;
import std.array;
import std.conv;
import std.exception;
import std.range;
import std.stdio;


void main(string[] args)
{
  "day9.1.input".File.byLine.map!(line => line.to!string.decompressed.length).writeln;
}


unittest
{
  assert("ADVENT".decompressed == "ADVENT");
  assert("A(1x5)BC".decompressed == "ABBBBBC");
  assert("(3x3)XYZ".decompressed == "XYZXYZXYZ");
  assert("A(2x2)BCD(2x2)EFG".decompressed == "ABCBCDEFEFG", "Expected \"ABCBCDEFEFG\", got \"" ~ "A(2x2)BCD(2x2)EFG".decompressed ~ "\"");
  assert("(6x1)(1x3)A".decompressed == "(1x3)A");
  assert("X(8x2)(3x3)ABCY".decompressed == "X(3x3)ABC(3x3)ABCY");
}
string decompressed(string input)
{
  auto output = "";
  
  while (input.canFind("("))
  {
    output ~= input.until("(").to!string;
      
    //writeln(input, " -> ", output);
  
    assert(input.findSkip("("));
    
    auto marker = input.until(")").array;
    auto numbers = marker.splitter("x").map!(mark => mark.to!int).array;
    auto index = numbers[0];
    auto repeats = numbers[1];
    
    enforce(input.findSkip(")"), "Found marker not closed with )");
    
    output ~= input[0 .. index].repeat(repeats).join.to!string;
    
    //writeln(marker, " ", input, " -> ", output);
    
    input = input[index .. $];
  }
  
  output ~= input;
  
  //writeln(input, " -> ", output);
  
  return output;
}
