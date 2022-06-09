unit uDistance;

interface

uses
  uBTypes;

const
  // Pathing Result
  PathCost_NotPossible = -1;
  // Walk cost
  StepCost_Straight = 1;
  StepCost_Diagonal = 3;
  // Tile cost
  TileCost_Like = 0.85;
  TileCost_Normal = 1.0;
  TileCost_Avoid = 1.15;
  TileCost_ExtremeAvoid = 32.0;
  TileCost_NotWalkable = 999.0;

function DiagonalDistance(OX, OY, TX, TY: BInt32; CostDiagonal, CostStraight: BUInt32): BUInt32;
function NormalDistance(OX, OY, TX, TY: BInt32): BUInt32;
function SQMDistance(OX, OY, TX, TY: BInt32): BUInt32;

implementation

uses
  Math,
  SysUtils;

function DiagonalDistance(OX, OY, TX, TY: BInt32; CostDiagonal, CostStraight: BUInt32): BUInt32;
var
  dx, dy: BUInt32;
begin
  dx := BAbs(OX - TX);
  dy := BAbs(OY - TY);
  Result := CostStraight * (dx + dy) + (CostDiagonal - 2 * CostStraight) * BMin(dx, dy);
end;

function NormalDistance(OX, OY, TX, TY: BInt32): BUInt32;
var
  dx, dy: BUInt32;
begin
  dx := BAbs(OX - TX);
  dy := BAbs(OY - TY);
  Result := Round(SQRt((dx * dx) + (dy * dy)));
end;

function SQMDistance(OX, OY, TX, TY: BInt32): BUInt32;
var
  dx, dy: BUInt32;
begin
  dx := BAbs(OX - TX);
  dy := BAbs(OY - TY);
  Result := BMax(dx, dy);
end;

end.
