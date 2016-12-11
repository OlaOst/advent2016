import std.algorithm;
import std.array;
import std.conv;
import std.math;
import std.stdio;


void main(string args[])
{
  auto input = File("day1.1.input");
  
  auto instructions = input.byLine.front.split(", ");
  
  instructions.calculateDistance.writeln;
  instructions.findFirstDoubleLocationDistance.writeln;
  
  auto norths = instructions.normalized.filter!(i => i[0] == 0).map!(i => i[1]).sum;
  auto easts  = instructions.normalized.filter!(i => i[0] == 1).map!(i => i[1]).sum;
  auto souths = instructions.normalized.filter!(i => i[0] == 2).map!(i => i[1]).sum;
  auto wests  = instructions.normalized.filter!(i => i[0] == 3).map!(i => i[1]).sum;
  
  ( abs(norths - souths) + abs(easts - wests) ).writeln;
}

int[2][] normalized(Input)(Input instructions)
{
  int[2][] normalizedInstructions;
  
  int direction = 0;
  foreach (instruction; instructions)
  {
    char turn = instruction[0];
    int distance = instruction[1..$].to!int;
    
    if (turn == 'L')
      direction += 3;
    else if (turn == 'R')
      direction += 1;
      
    direction %= 4;
    
    normalizedInstructions ~= [direction, distance];
  }
  
  return normalizedInstructions;
}


unittest
{
  //assert(calculateDistance([]) == 0);
  assert(calculateDistance(["L0"]) == 0);
  assert(calculateDistance(["R0"]) == 0);
  assert(calculateDistance(["L1"]) == 1);
  assert(calculateDistance(["R1"]) == 1);
  assert(calculateDistance(["R1", "R1", "R1", "R1"]) == 0);
  assert(calculateDistance(["R0", "R1"]) == 1);
  assert(calculateDistance(["L0", "L1"]) == 1);
  assert(calculateDistance(["R2", "L2", "L2", "L2", "R2"]) == 2);
  
  assert(calculateDistance(["R2", "L3"]) == 5, "Expected 5, got " ~ calculateDistance(["R2", "L3"]).to!string);
  assert(calculateDistance(["R2", "R2", "R2"]) == 2);
  assert(calculateDistance(["R5", "L5", "R5", "R3"]) == 12);
  assert(calculateDistance(["L10"]) == 10, "Expected 10, got " ~ calculateDistance(["L10"]).to!string);
}

int calculateDistance(Input)(Input instructions)
{
  //writeln("calculating distance for ", instructions);
  
  int direction = 0;
  int x = 0;
  int y = 0;
  foreach (instruction; instructions)
  {
    char turn = instruction[0];
    int distance = instruction[1..$].to!int;
    
    if (turn == 'R')
      direction += 1;
    else if (turn == 'L')
      direction += 3;
    else
      writeln("WHOOPS, don't know how to interpret turn instruction ", instruction);
      
    direction %= 4;
        
    if (direction == 0)
      y += distance;
    if (direction == 1)
      x += distance;
    if (direction == 2)
      y -= distance;
    if (direction == 3)
      x -= distance;
      
    //writeln("instruction ", instruction, " put coords at ", [x, y]);
  }
  
  return abs(x)+abs(y);
}


unittest
{
  assert(findFirstDoubleLocationDistance(["R8", "R4", "R4", "R8"]) == 4, "Expected 4, got " ~ findFirstDoubleLocationDistance(["R8", "R4", "R4", "R8"]).to!string);
}

int findFirstDoubleLocationDistance(Input)(Input instructions)
{
  int[2][] visitedLocations;
  
  int x = 0;
  int y = 0;
  int direction = 0;
  foreach (instruction; instructions)
  {
    char turn = instruction[0];
    int distance = instruction[1..$].to!int;
    
    if (turn == 'R')
      direction += 1;
    else if (turn == 'L')
      direction += 3;
    else
    {
      writeln("WHOOPS, don't know how to interpret turn instruction ", instruction);
      return -1;
    }
      
    direction %= 4;
    
    //writeln("instruction ", instruction, " with turn ", turn, ", direction ", direction, " and distance ", distance);
    
    if (direction == 0)
    {
      for (int i = 0; i < distance; i++)
      {
        y++;
        if (visitedLocations.canFind([x,y]))
          return abs(x)+abs(y);
        else
          visitedLocations ~= [x, y];
      }
    }
    else if (direction == 1)
    {
      for (int i = 0; i < distance; i++)
      {
        x++;
        if (visitedLocations.canFind([x,y]))
          return abs(x)+abs(y);
        else
          visitedLocations ~= [x, y];
      }
    }
    else if (direction == 2)
    {
      for (int i = 0; i < distance; i++)
      {
        y--;
        if (visitedLocations.canFind([x,y]))
          return abs(x)+abs(y);
        else
          visitedLocations ~= [x, y];
      }        
    }
    else if (direction == 3)
    {
      for (int i = 0; i < distance; i++)
      {
        x--;
        if (visitedLocations.canFind([x,y]))
          return abs(x)+abs(y);
        else
          visitedLocations ~= [x, y];
      }
    }
    else
    {
      writeln("WHOOPS, don't know how to interpret distance in instruction ", instruction);
      return -1;
    }
  }
  writeln("did not find any location visited twice");
  return -1;
}
