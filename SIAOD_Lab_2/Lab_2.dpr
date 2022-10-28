program Lab_2;

{$APPTYPE CONSOLE}

uses
  SysUtils;

type
  pNode = ^node;

  node = record
    fio: String;
    number: Integer;
    next: pNode;
  end;

procedure add(var root: pNode; fio:String; number:integer);
var
  temp, addX: pNode;
begin
  New(addX);
  addX.fio := fio;
  addX.number := number;
  addX.next := nil;

  if root = nil then
    root := addX
  else
  begin
    temp := root;
    if (CompareStr(root.fio, addX.fio) < 0) then
    begin
      while (temp.next <> nil) and (CompareStr(temp.next.fio, addX.fio) < 0) do
        temp := temp.next;
      addX.next := temp.next;
      temp.next := addX;
    end
    else
    begin
      addX.next := root;
      root := addX;
    end;
  end;
end;

procedure printList(root: pNode);
var
  temp: pNode;
begin
  temp := root;
  while temp <> nil do
  begin
    writeln(temp.fio, ' ', temp.number);
    temp := temp.next;
  end;
end;

procedure printListByFIO(root: pNode; fio: String);
var
  temp: pNode;
begin
  temp := root;
  while temp <> nil do
  begin
    if CompareStr(temp.fio, fio) = 0 then
      writeln(temp.fio, ' ', temp.number);
    temp := temp.next;
  end;
end;

procedure printListByNumber(root: pNode; number:Integer);
var
  temp: pNode;
begin
  temp := root;
  while temp <> nil do
  begin
    if temp.number = number then
      writeln(temp.fio, ' ', temp.number);
    temp := temp.next;
  end;
end;

var
  list: pNode;
  fioEnt: String;
  numberEnt, choiceEnt: Integer;

begin
  list := nil;

  writeln('0 - Exit');
  writeln('1 - Add new contact');
  writeln('2 - Display all list');
  writeln('3 - Search by last name');
  writeln('4 - Search by phone number');

  writeln('Choose option:');
  readln(choiceEnt);

  while choiceEnt <> 0 do
    case choiceEnt of
      1:
        begin
          writeln('Enter the contact''s last name and phone number:');
          readln(fioEnt);
          readln(numberEnt);
          add(list, fioEnt, numberEnt);
          readln(choiceEnt);
        end;
      2:
        begin
          writeln('Full list:');
          printList(list);
          readln(choiceEnt);
        end;
      3:
        begin
          writeln('Enter the last name to search for:');
          readln(fioEnt);
          writeln;
          writeln('List:');
          printListByFIO(list, fioEnt);
          readln(choiceEnt);
        end;
      4:
        begin
          writeln('Enter the phone number to search for:');
          readln(numberEnt);
          writeln;
          writeln('List:');
          printListByNumber(list, numberEnt);
          readln(choiceEnt);
        end;
    end;
  readln
end.
