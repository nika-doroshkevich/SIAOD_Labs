program Lab_5;

{$APPTYPE CONSOLE}

uses
  SysUtils;

type
  TClient = record
    num: Integer;
    workTime: Integer;
end;

type
  pNode = ^Node;
  Node = record
    workTime: TClient;
    priority: Integer;
    next: pNode;
  end;

var
  sizeTact , sizeInp, indW ,i, tact, prostoi, allMove, temp:integer;
  s: String;
  cl: TClient;
  mas: array[1..5] of Integer = (1,1,1,1,1);
  masPrior: array[1..5] of Integer = (1,1,2,2,2);
  masWork: array[1..2,1..5] of Integer =((0,0,0,0,0),(0,0,0,0,0));
  workOfClients: array[1..5,1..10] of Integer = ((2, 2, 3, 4, 2, 1, 1, 3, 3, 2),
                                                 (4, 1, 1, 1, 1, 2, 2, 3, 1, 1),
                                                 (4, 5, 3, 2, 1 , 3 , 4, 5, 2, 3),
                                                 (4, 5, 3, 2, 1, 1, 3, 3, 3, 4),
                                                 (6, 8, 7, 5, 4, 2, 3, 1, 8, 5));

procedure Push(var root: pNode; workTime, num, priority: Integer);
var
  temp, temp2: pNode;
begin
  new(temp);
  temp.workTime.workTime := workTime;
  temp.workTime.num := num;
  temp.priority := priority;
  if root = nil then
  begin
    root := temp;
    root.next := nil;
  end
  else
  begin
    temp2 := root;
    while (temp2.next <> nil) and (temp2.next.priority > temp.priority) do
      temp2 := temp2.next;
    if (temp2 = root) and (temp.priority >= root.priority) then
    begin
      temp.next := root;
      root := temp;
    end
    else
    begin
      temp.next := temp2.next;
      temp2.next := temp;
    end;
  end;
end;

function Pop(var root: pNode): TClient;
var
  temp, temp2: pNode;
begin
  temp := root;
  temp2 := nil;
  while temp.next <> nil do
  begin
    temp2 := temp;
    temp := temp.next;
  end;
  Pop := temp.workTime;
  if temp2 = nil then
    root := nil
  else
    temp2.next := nil;

end;

procedure print(root: pNode);
begin
  while root <> nil do
  begin
    writeln(root.workTime.workTime, ' ' , root.workTime.num);
    root := root.next;
  end;
end;

function isEmpty(root: pNode): Boolean;
begin
  isEmpty := root = nil;
end;

function isEmptyMas(): Boolean;
var i, j, c: Integer;
begin
  c := 0;
  for i:=1 to 2 do
    for j:=1 to 5 do
      c := c + masWork[i][j];
  Result := c=0;
end;

var
  root: pNode;

begin
  root := nil;
  sizeTact := 8;
  sizeInp := 0;
  for sizeTact:=1 to 10 do
    for sizeInp:=0 to 10 do
    begin
      for i:=1 to 5 do
      begin
        mas[i] := 1;
        push(root, workOfClients[i][mas[i]], i, masPrior[i]);
      end;
      tact := 0;
      allMove := 0;
      prostoi := 0;
      while (not isEmpty(root)) or (not isEmptyMas) do
      begin
        s:='_____';
        indW := 0;
        for i:=1 to 5 do
        if masWork[1][i] <> 0 then
          indW := i;
        if (indW = 0) and (not isEmpty(root)) and (tact = 0) then
        begin
          cl := pop(root);
          masWork[1][cl.num] := cl.workTime;
          masWork[2][cl.num] := sizeInp;
          indW := cl.num;
        end;
        if indW<>0 then
        begin
          Dec(masWork[1][indW]);
          s[indW] := 'w';
          if (masWork[1][indW]=0) and (sizeInp=0) and (mas[indW]<11) then
          begin
            push(root, workOfClients[indW][mas[indW]] , indW, masPrior[indW]);
            Inc(mas[indW]);
          end;
        end;

        for i:= 1 to 5 do
        begin
          if (masWork[2][i] <> 0) and (i<>indW) and (masWork[1][i] = 0) then
          begin
            Dec(masWork[2][i]);
            s[i] := 'i';
            if (mas[i] < 11) and (masWork[2][i] = 0)then
            begin
              push(root, workOfClients[i][mas[i]] , i, masPrior[i]);
              Inc(mas[i]);
            end;
          end;
      
        end;
        temp := 0;
        for i:=1 to 5 do
        if s[i] = 'w' then
          Inc(temp);
        if temp = 0 then
          Inc(prostoi);
        Inc(allMove);

        tact := (tact+1) mod sizeTact;
      end;
      writeln('tact: ',sizeTact, '   input: ', sizeInp, '   idle: ', prostoi,'   KPD: ', ((1-prostoi/allMove)*100):4:2,'%');
    end;
  readln
end.
