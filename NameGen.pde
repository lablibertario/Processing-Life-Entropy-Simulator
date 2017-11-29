class NameGen
{
  int count;
  String[] consonants = {"b", "c", "d", "f", "g", "h", "j", "k", "l", "m", "n", "p", "q", "r", "s", "t", "v", "w", "x", "y", "z"};
  String[] vowels = {"a", "e", "i", "o", "u"};
  
  NameGen()
  {
    count = 0;
  }
  String next()
  {
    String name = "";
    name += consonants[mainRng.nextInt(consonants.length)];
    name += vowels[mainRng.nextInt(vowels.length)];
    name += consonants[mainRng.nextInt(consonants.length)];
    name += vowels[mainRng.nextInt(vowels.length)];
    name += Integer.toString(count);
    count ++;
    return name;
  }
}