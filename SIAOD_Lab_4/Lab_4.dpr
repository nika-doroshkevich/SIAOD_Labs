program Lab_4;

{$APPTYPE CONSOLE}

uses
  SysUtils;

type
  pNode = ^Node;
  Node = record
    inf: String;
    next: pNode;
  end;

procedure Push(var root: pNode; inf: String);
var
  temp: pNode;
begin
  new(temp);
  temp.inf := inf;
  temp.next := root;
  root := temp;
end;

function Pop(var root: pNode): String;
var
  temp: pNode;
begin
  temp := root;
  root := root.next;
  Pop := temp.inf;
end;

function Top(root: pNode): String;
begin
  Top := root.inf;
end;

function isEmpty(root: pNode):Boolean;
begin
  isEmpty := root = nil;
end;

function getPriority(oper: String): Integer;
var
  priority: Integer;
begin
  priority := -1;
  case oper[1] of
    '+': priority := 0;
    '-': priority := 0;
    '*': priority := 1;
    '/': priority := 1;
    '^': priority := 2;
    //'%': priority := 1;
  end;
  getPriority := priority;
end;

function isPriority(s1, s2: String):Boolean;
begin
  isPriority := ((getPriority(s1) >= getPriority(s2))) and (not ((s1 = '^') and (s2 = '^')));
end;

procedure PrimOper(var StOper, StVir: pNode);
var
  s1, s2: String;
begin
  s2 := Pop(StVir);
  s1 := Pop(StVir);
  s1 := s1 + s2 + Pop(StOper);
  Push(StVir, s1);
end;

var
  StOper, StVir: pNode;
  s: String;
  i, sum: Integer;
begin
  sum := 0;

  StOper := nil;
  StVir := nil;

  writeln('Infix expression:');
  readln(s);
  for i := 1 to length(s) do
  begin
    if (s[i] >= 'a') and (s[i] <= 'z') then
      Push(StVir, s[i])
    else if s[i] = '(' then
      Push(StOper, s[i])
    else if s[i] = ')' then
      begin
      while Top(StOper) <> '(' do
        PrimOper(StOper, StVir);
      Pop(StOper);
      end
    else
    begin
      if not isEmpty(StOper) then
        if isPriority(Top(StOper), s[i]) then
          PrimOper(StOper, StVir);
        Push(StOper, s[i]);
    end;
  end;
  while not isEmpty(StOper) do
    PrimOper(StOper, StVir);
  writeln('Postfix expression:');
  writeln(Pop(StVir));
  for i := 1 to length(s) do
  begin
    if (s[i] = '+') or (s[i] = '-') or (s[i] = '/') or (s[i] = '*') or (s[i] = '^') then
      dec(sum)
    else if (s[i] = '(') or (s[i] = ')') then
      sum := sum + 0
    else
      inc(sum);
  end;
  writeln('Rank = ', sum);
  readln
end.
