program Lab_3;

{$APPTYPE CONSOLE}

uses
  SysUtils;

const
  hashSize = 26;
type
  strArr = array[1..100] of String;

type
  pNumber = ^Number;
  Number = record
    num: Integer;
    next: pNumber;
  end;

type
  pTermin = ^Termin;
  Termin = record
    name: String;
    podTermin: array [1..hashSize] of pTermin;
    next: pTermin;
    listNum: pNumber;
  end;

var
  dir: pTermin;
  str: strArr;

function Hash(word: String): Integer;
begin
  if('a' <= word[1]) and ('z' >= word[1]) then
    Hash := ord(word[1]) - ord('a') + 1
  else
    Hash := ord(word[1]) - ord('A') + 1;
end;

procedure newTerm(var termin: pTermin; name: String);
var
  i: Integer;
begin
  termin := new(pTermin);
  termin.name := name;
  termin.next := nil;
  termin.listNum := nil;
  for i := 1 to hashSize do
    termin.podTermin[i] := nil;
end;

procedure AddTerm(var root: pTermin; term: strArr; str: Integer; n: Integer);
var
  hashT: array[1..100] of Integer;
  rootT, termT: array[0..100] of pTermin;
  temp, pTemp: pTermin;
  tempNum: pNumber;
  i: Integer;
begin
  if root = nil then
    newTerm(root, 'Dictionary');
  

 rootT[0] := root;
 for i := 1 to n do
 begin
  hashT[i] := Hash(term[i]);
  rootT[i] := rootT[i-1].podTermin[hashT[i]];
  if rootT[i] = nil then
  begin
    //writeln('rootT1=nil');
    newTerm(rootT[i], term[i]);
    rootT[i-1].podTermin[hashT[i]] := rootT[i];
  end
  else
  begin
    temp := rootT[i];
    while (temp <> nil) and (temp.name <> term[i]) do
      temp := temp.next;
    if temp <> nil then
    begin
      termT[i] := temp  ;
      //writeln('temp1<>nil');
    end
    else
    begin
      temp := rootT[i];
      pTemp := nil;
      while (temp <> nil) and (temp.name < term[i]) do
      begin
        pTemp := temp;
        temp := temp.next;
      end;
      if pTemp = nil then
      begin
        newTerm(termT[i], term[i]);
        termT[i].next := rootT[i];
        rootT[i-1].podTermin[hashT[i]] := termT[i];
        rootT[i] := termT[i];
        //writeln('temp1=nil');
      end
      else
      begin
         newTerm(termT[i], term[i]);
         termT[i].next := temp;
         pTemp.next := termT[i];
      end;
    end;
  end;
 end;

  if rootT[n].listNum = nil then
    begin
      new(rootT[n].listNum);
      rootT[n].listNum.num := str;
      rootT[n].listNum.next := nil;
    end
    else
    begin
      new(tempNum);
      tempNum.num := str;
      tempNum.next := rootT[n].listNum;
      rootT[n].listNum := tempNum;
    end;
end;

procedure print(root: pTermin; level: Integer);
var
  i: Integer;
  temp: pNumber;
begin
  if(root<> nil) then
  begin
    for i:=1 to level do
      write(' ');
    write(root.name + ' ');
    temp:=root.listNum;
    while(temp <> nil) do
    begin
      write(temp.num,' ');
      temp := temp.next;
    end;
    writeln;
    for i:=1 to hashSize do
      print(root.podTermin[i], level+1);
    print(root.next, level);
  end;
end;

procedure findPodTermForTerm(root: pTermin; podTerm: String);
var
  i: Integer;
begin
  if root <> nil then
  begin
    if(root.name = podTerm) then
      print(root, 0)
    else
    begin
      findPodTermForTerm(root.next, podTerm);
      for i:=1 to hashSize do
        findPodTermForTerm(root.podTermin[i], podTerm);
    end;
  end;
end;

procedure findTermForPodTerm(root, predRoot: pTermin; podTerm: String);
var
  i:Integer;
begin
  if root <> nil then
  begin
    if(root.name = podTerm) then
      print(predRoot, 0)
    else
    begin
      findTermForPodTerm(root.next, predRoot, podTerm);
      for i := 1 to hashSize do
        findTermForPodTerm(root.podTermin[i], root, podTerm);
    end;
  end;
end;

procedure editTerm(root: pTermin; podTerm, editStr: String);
var
  i: Integer;
begin
  if root <> nil then
  begin
    if(root.name = podTerm) then
      root.name := editStr
    else
    begin
      editTerm(root.next, podTerm, editStr);
      for i:=1 to hashSize do
        editTerm(root.podTermin[i], podTerm, editStr);
    end;
  end;
end;

procedure delTerm(root, predRoot: pTermin; num: Integer; podTerm: String);
var
  i: Integer;
  temp, pTemp: pTermin;
begin
  if root <> nil then
  begin
    if(root.name = podTerm) then
    begin
      temp := predRoot.podTermin[num];
      while temp.name <> podTerm do
      begin
        pTemp := temp;
        temp := temp.next;
      end;
      if temp = predRoot.podTermin[num] then
        predRoot.podTermin[num] := temp.next
      else
          pTemp.next := temp.next;
    end
    else
    begin
      delTerm(root.next, predRoot,num, podTerm);
      for i := 1 to hashSize do
        delTerm(root.podTermin[i], root, i, podTerm);
    end;
  end;
end;

var
  vloz, page, choice: Integer;
  term, newTermin: String;

begin
  dir := nil;
  writeln('Choose the operation:');
  writeln('0 - Exit');
  writeln('1 - Add term');
  writeln('2 - Find subterm by term');
  writeln('3 - Find term by subterm');
  writeln('4 - Edit term');
  writeln('5 - Delete term');
  writeln('6 - Show structure');
  readln(choice);

  while choice <> 0 do
    case choice of
      1:
        begin
          writeln('Format: Term Enclosure Page');
          readln(term);
          readln(vloz);
          readln(page);

          str[vloz] := term;
          AddTerm(dir, str, page, vloz);
          readln(choice);
        end;
      2:
        begin
          writeln('Format: Term');
          readln(term);
          findPodTermForTerm(dir, term);
          readln(choice);
        end;
      3:
        begin
          writeln('Format: Subterm');
          readln(term);
          findTermForPodTerm(dir, dir, term);
          readln(choice);
        end;
      4:
        begin
          writeln('Format: Term New_term');
          readln(term);
          readln(newTermin);
          editTerm(dir, term, newTermin);
          readln(choice);
        end;
      5:
        begin
          writeln('Format: Enclosure Term');
          readln(vloz);
          readln(term);
          delTerm(dir, dir, vloz, term);
          readln(choice);
        end;
      6:
        begin
          print(dir, 0);
          readln(choice);
        end;
    end;
  readln
  {
  dir := nil;

  str[1] := 'Mebel';
  str[2] := 'Table';
  str[3] := 'ikea';
  AddTerm(dir, str, 2, 1);
  AddTerm(dir, str, 3, 2);
  AddTerm(dir, str, 4, 3);


  str[3] := 'ami';
  AddTerm(dir, str, 4, 3);
  str[1] := 'Mebel';
  str[2] := 'Bed';
  str[3] := 'ami';
  AddTerm(dir, str, 2, 1);
  AddTerm(dir, str, 3, 2);
  AddTerm(dir, str, 4, 3);

  print(dir, 0);

  findPodTermForTerm(dir, 'Table');
  findTermForPodTerm(dir,dir,'ikea');
  editTerm(dir, 'Table', 'Car');
  delTerm(dir,dir,0,'Mebel');
  print(dir, 0);
  readln
  }
end.
