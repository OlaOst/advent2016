import std.algorithm;
import std.array;
import std.conv;
import std.range;
import std.stdio;


alias ScreenDef = dchar[][];


void main(string[] args)
{
  //ScreenDef screen = '.';
  
  //foreach (line; "day8.1.input".File.byLine)
    //screen.update(line);
  
  //screen.each!writeln;
}

unittest
{
  ScreenDef test = dchar('.').repeat(50).array.repeat(6).array;
  test.each!writeln;
  writeln;
  
  test.update("rect 3x2");
  test.each!writeln;
  writeln;
  
  test.update("rotate column x=1 by 1");
  test.each!writeln;
  writeln;
  
  test.update("rotate row y=0 by 4");
  test.each!writeln;
  writeln;
  
  test.update("rotate column x=1 by 1");
  test.each!writeln;
  writeln;
  
  //test.update("rect 3x2");
  //test.writeln;
}
ScreenDef update(Input)(const ScreenDef screen, Input instruction)
{
  //auto output = screen.dup.joiner('\n');
  dchar[][] output = cast(dchar[][])(screen.map!(line => line.array).array);
  
  //writeln(instruction);
  
  if (instruction.findSkip("rect "))
  {
    auto coords = instruction.splitter("x").map!(c => c.to!int).array;
    //coords.writeln;
    for (int x = 0; x < coords[0]; x++)
    {
      for (int y = 0; y < coords[1]; y++)
      {
        //writeln(x, " ", y, ": ", screen[y][x]);
        output[y][x] = '#';
        
        //screen.each!writeln;
      }
    }
  }
  else if (instruction.findSkip("rotate "))
  {
    if (instruction.findSkip("row y="))
    {
      auto coords = instruction.splitter(" by ").map!(c => c.to!int).array;
      
      auto row = screen[coords[0]];
      auto pixels = coords[1] % 50;
      
      bringToFront(row[pixels..$], row[0..pixels]);
      output[coords[0]] = row;
      //output[coords[0]*50 .. coords[0]*50+row.length] = row;
    }
    else if (instruction.findSkip("column x="))
    {
      auto coords = instruction.splitter(" by ").map!(c => c.to!int).array;
      
      auto flipped = screen.transposed.map!(line => line.array).array;
      
      auto col = flipped[coords[0]];
      auto pixels = coords[1] % 6;
      
      bringToFront(col[pixels..$], col[0..pixels]);
      flipped[coords[0]] = col;
      
      output = flipped.transposed.map!(line => line.array).array;
    }
  }
  
  return output;//.splitter('\n').array;
}
