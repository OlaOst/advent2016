import std.algorithm;
import std.array;
import std.conv;
import std.exception;
import std.regex;
import std.stdio;


void main(string[] args)
{
  auto input = "day10.1.input".File.byLine.map!(line => line.to!string).array.getBots();
  
  //input.each!writeln;
  input.findComparingBot(17, 61).writeln;
}

unittest
{
  auto input = ["value 5 goes to bot 2",
                "bot 2 gives low to bot 1 and high to bot 0",
                "value 3 goes to bot 1",
                "bot 1 gives low to output 1 and high to bot 0",
                "bot 0 gives low to output 2 and high to output 0",
                "value 2 goes to bot 2"];
        
  // step 0: bot 2 has 5 and 2, bot 1 has 3, bot 0 has nothing
  // step 1: bot 2 has nothing, bot 1 has 3 and 2, bot 0 has 5
  // step 2: bot 2 has nothing, bot 1 has nothing, bot 0 has 5 and 3, output 1 has 2
  // step 3: bot 2 has nothing, bot 1 has nothing, bot 0 has nothing, output 1 has 2, output 2 has 3, output 0 has 5
  
  auto bots = input.getBots();
        
  assert(bots.findComparingBot(2, 5) == "bot 2");
  assert(bots.findComparingBot(2, 3) == "bot 1");
  
  bots.findComparingBot(10, 11).writeln;
}

struct Bot
{
  string name;
  
  string outputLow;
  string outputHigh;
  
  int[] chips;
  
  this(string name, string outputLow, string outputHigh)
  {
    this.name = name;
    this.outputLow = outputLow;
    this.outputHigh = outputHigh;
  }
  
  void addChip(int chip)
  {
    if (chips.length == 1)
    {
      if (chip > chips[0])
        chips = [chips[0], chip];
      else
        chips = [chip, chips[0]];
    }
    else if (chips.length == 0)
    {
      chips = [chip];
    }
    else if (name.startsWith("bot"))
    {
      assert(0, "Cannot add more than 2 chips to a bot");
    }
  }
}

Bot[string] getBots(Input)(Input instructions)
{
  auto bots = instructions.map!(line => line.to!string.matchFirst("(bot [0-9]+) gives low to (bot [0-9]+|output [0-9]+) and high to (bot [0-9]+|output [0-9]+)"))
                          .filter!(matches => !matches.empty)
                          .map!(matches => Bot(matches[1], matches[2], matches[3]))
                          .array;
  
  Bot[string] output;
  foreach (bot; bots)
    output[bot.name] = bot;
       
  auto initials = instructions.map!(line => line.matchFirst("value ([0-9]+) goes to (bot [0-9]+)"))
                              .filter!(matches => !matches.empty);
  
  foreach (initial; initials)
    output[initial[2]].addChip(initial[1].to!int);
    
  return output;
}

string findComparingBot(Bot[string] bots, int lowChip, int highChip)
{
  assert(lowChip < highChip, "lowChip parameter " ~ lowChip.to!string ~ " must be lower than highChip parameter " ~ highChip.to!string);
  
  if (bots == null)
    return null;
  
  auto found = bots.byValue.find!(bot => bot.name.startsWith("bot") && bot.chips.length >= 2 && bot.chips[0] == lowChip && bot.chips[1] == highChip);
  
  if (!found.empty)
    return found.front.name;
  else
    return bots.iterated.findComparingBot(lowChip, highChip);
}

Bot[string] iterated(Bot[string] bots)
{
  Bot[string] output;
  
  //writeln("iterating bots: ");
  //bots.byValue.map!(bot => bot).each!writeln;
  
  bots.byValue.each!(bot => output[bot.name] = bot);
  
  if (bots.byValue.all!(bot => bot.name.startsWith("output") || bot.chips.length < 2))
    return null;
    
  assert(bots.byValue.any!(bot => bot.name.startsWith("bot") && bot.chips.length >= 2));
  
  foreach (bot; bots.byValue)
  {
    if (bot.chips.length >= 2)
    {
      //writeln(bot.name, " putting chip ", bot.chips[0], " into ", bot.outputLow);
      //writeln(bot.name, " putting chip ", bot.chips[1], " into ", bot.outputHigh);
      
      if (bot.outputLow !in output)
        output[bot.outputLow] = Bot(bot.outputLow, "?", "?");
      if (bot.outputHigh !in output)
        output[bot.outputHigh] = Bot(bot.outputHigh, "?", "?");
        
      output[bot.outputLow].addChip(bot.chips[0]);
      output[bot.outputHigh].addChip(bot.chips[1]);
      
      output[bot.name].chips = [];
    }
  }
  
  return output;
}
