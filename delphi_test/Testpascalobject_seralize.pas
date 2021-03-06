unit Testpascalobject_seralize;
{

  Delphi DUnit Test Case
  ----------------------
  This unit contains a skeleton test case class generated by the Test Case Wizard.
  Modify the generated code to correctly setup and call the methods from the unit 
  being tested.

}

interface

uses
  TestFramework, pascalobject_seralize, intf_SeralizeadApter,delphi_seralizeadapter, TypInfo, Classes,
  SysUtils, System.NetEncoding, Variants,Dateutils, graphics,frm_test;

type
  { TDataItem }

  TDataItem =Class(TcollectionItem)
  private
    FDateTime: TDateTime;
    fdbl: double;
    FInteger: integer;
    FStr: string;
  published
    property testInteger:integer read FInteger write FInteger;
    property testDate:TDateTime read FDateTime write FDateTime;
    property testString:string read FStr write FStr;
    property testFloat:double read fdbl write fdbl;
  end;
  { TDataCollection }

  TDataCollection=class(TCollection)

  private
    FName: string;
    function GetDataItem(Index: integer): TDataItem;
  public
    function AddDataItem:TDataItem;
    property DataItem[Index:integer]:TDataItem read GetDataItem;
  published
    property datacollectionName:string read FName write FName;
  end;

type
  { TestPascalSeralize }

  TestPascalSeralize=class(TTestCase)
  protected
    Ffrm:TfrmTest;
    procedure Setup;override;
    procedure TearDown;override;
  published
    procedure TestGetPropInfo;
  end;

type
  { TestSearalizeObject }

  TestSearalizeObject= class(TTestCase)
  private
    function SampleDataPath: string;
  protected
    FW:TMyCustomWriter;
    FR:TMyCustomReader;

    procedure SetUp; override;
    procedure TearDown; override;
  public
  published
    procedure TestReadfrmTest;
    procedure TestWritefrmTest;
    procedure TestWriteCollection;
    procedure TEstReadCollection;

    procedure TestWriteFrmTest_JsonAdapter;
    procedure TestReadFrmTest_JsonAdapter;
    procedure TestWriteCollection_Json;
    procedure TEstReadCollection_Json;
  end;




implementation

{ TDataCollection }

function TDataCollection.GetDataItem(Index: integer): TDataItem;
begin
  result :=self.Items[Index] as TDataItem;
end;

function TDataCollection.AddDataItem: TDataItem;
begin
  result :=TDataItem.Create(self);
end;

{ TestPascalSeralize }

procedure TestPascalSeralize.Setup;
begin
  inherited ;
  fFrm :=TfrmTest.Create(nil);
end;

procedure TestPascalSeralize.TearDown;
begin
  FreeAndNil(fFrm);
  inherited ;
end;

procedure TestPascalSeralize.TestGetPropInfo;
var
  I: Integer;
  PList: PPropList;
  intPropCount: Integer;
  PInfo: PPropInfo;
begin


  // Save Collection
  intPropCount := GetTypeData(ffrm.ClassInfo)^.PropCount;
  GetMem(PList, intPropCount * SizeOf(Pointer));
  try
  intPropCount := GetPropList(ffrm.ClassInfo, tkAny, PList);
  for I := 0 to intPropCount-1 do
  begin
    PInfo :=PList^[I];

    {$IFDEF DEBUG}


      //SendInteger('Prop Index:',Pinfo^.PropProcs);
      //SendDebug('PropName:'+Pinfo^.Name);
    {$ENDIF}
  end;

  finally
    FreeMem(PList, intPropCount * SizeOf(Pointer));
  end;


end;

function TestSearalizeObject.SampleDataPath: string;
begin
  result :='..\..\..\testdata\';
end;

procedure TestSearalizeObject.TestWritefrmTest;
var
  Iadp:IDataAdapter;
  frm:TfrmTest;
begin
  iadp :=TDJsonAdapter.Create;
  frm :=TfrmTest.Create(nil);
  try
  fW.Adapter :=Iadp;
  frm.Image1.Picture.LoadFromFile(SampleDataPath+'test.png');
  frm.ShowModal;
  fw.WriteObjectToFile(SampleDataPath+'test.xml',frm);
  finally
    FreeAndnil(frm);
  end;

end;

procedure TestSearalizeObject.TestWriteCollection;
var
  coll:TDataCollection;
  Item:TDataItem;
  IAdp:TDJsonAdapter;
begin
  Coll :=TDatacollection.Create(TdataItem);
  IAdp :=TDJsonAdapter.Create;
  try
    Coll.datacollectionName:='TestDataName';

    Item :=coll.AddDataItem;
    item.testDate:=now;
    item.testFloat:=3.14;
    item.testInteger:=28;
    item.testString:='hello world';
    fw.Adapter :=IAdp;
    fw.WriteObjectToFile(SampleDataPath+'testCollection.xml',Coll);

  finally
    FreeAndNil( Coll);
  end;
end;

procedure TestSearalizeObject.TEstReadCollection;
var
  coll:TDataCollection;
  Item:TDataItem;
  IAdp:TDJsonAdapter;
begin
  Coll :=TDatacollection.Create(TdataItem);
  IAdp :=TDJsonAdapter.Create;
  try
    fr.Adapter :=IAdp;
    fr.ReadFileToObject(SampleDataPath+'testcollection.xml',coll);
    checkequals(Coll.datacollectionName,'TestDataName');
    Item :=Coll.DataItem[0];

    checkequals(item.testString,'hello world');
    checkequals(item.testInteger,28);
    checkequals(item.testFloat,3.14);
    checkequals(YearOf(item.testDate),yearOf(now));

  finally
     FreeAndNil( Coll);
  end;

end;

procedure TestSearalizeObject.TestWriteFrmTest_JsonAdapter;
var
  Iadp:IDataAdapter;
  frm:TfrmTest;
begin
  iadp :=TDJsonAdapter.Create;
  frm :=TfrmTest.Create(nil);
  try
  fW.Adapter :=Iadp;
 // frm.Image1.Picture.LoadFromFile('E:\GitHub\PascalObjectSeralize\testdata\'+'test.png');
  frm.ShowModal;
  fw.WriteObjectToFile(SampleDataPath+'test.json',frm);
  finally
    FreeAndnil(frm);
  end;
end;

procedure TestSearalizeObject.TestReadFrmTest_JsonAdapter;
var
  Iadp:IDataAdapter;
  frm:TfrmTest;
begin
  iadp :=TDJsonAdapter.Create;
  frm :=TfrmTest.Create(nil);
  try
    fr.Adapter :=Iadp;
    fr.ReadFileToObject(SampleDataPath+'test.json',frm) ;
    frm.ShowModal;
  finally
    FreeAndnil(frm);
  end;


end;

procedure TestSearalizeObject.TestWriteCollection_Json;
var
  coll:TDataCollection;
  Item:TDataItem;
  IAdp:IDataAdapter;
begin
  Coll :=TDatacollection.Create(TdataItem);
  IAdp :=TDJsonAdapter.Create;
  try
    Coll.datacollectionName:='TestDataName';

    Item :=coll.AddDataItem;
    item.testDate:=now;
    item.testFloat:=3.14;
    item.testInteger:=28;
    item.testString:='hello world';


    Item :=coll.AddDataItem;
    Item.testDate :=Date;
    item.testFloat :=2.2;
    item.testInteger :=9;
    item.testString :='delphi test';

    fw.Adapter :=IAdp;

    fw.WriteObjectToFile(SampleDataPath+'testCollection.Json',Coll);

  finally
    FreeAndNil( Coll);
  end;

end;

procedure TestSearalizeObject.TEstReadCollection_Json;
var
  coll:TDataCollection;
  Item:TDataItem;
  IAdp:IDataAdapter;
begin
  Coll :=TDatacollection.Create(TdataItem);
  IAdp :=TDJsonAdapter.Create;
  try
    fr.Adapter :=IAdp;
    fr.ReadFileToObject(SampleDataPath+'testcollection.Json',coll);
    checkequals(Coll.datacollectionName,'TestDataName');
    Item :=Coll.DataItem[0];

    checkequals(item.testString,'hello world');
    checkequals(item.testInteger,28);
    CheckTrue(abs(item.testFloat-3.14)<=0.0000001,'float not equals');
    checkequals(YearOf(item.testDate),yearOf(now));

  finally
     FreeAndNil( Coll);
  end;

end;

procedure TestSearalizeObject.SetUp;
begin
  FW :=TMyCustomWriter.Create(nil);
  Fr :=TMyCustomReader.Create(nil);
end;

procedure TestSearalizeObject.TearDown;
begin
  FreeAndnil(Fr);
  FreeAndNil(FW);
end;

procedure TestSearalizeObject.TestReadfrmTest;
var
  Iadp:IDataAdapter;
  frm:TfrmTest;
begin
  iadp :=TDJsonAdapter.Create;
  frm :=TfrmTest.Create(nil);
  try
    fr.Adapter :=Iadp;
    fr.ReadFileToObject(SampleDataPath+'test.xml',frm) ;
    frm.ShowModal;
  finally
    FreeAndnil(frm);
  end;


end;

initialization
  // Register any test cases with the test runner
  registerTest(TestPascalSeralize.suite);
  RegisterTest(TestSearalizeObject.suite);
  RegisterClass(TDataItem);
  RegisterClass(TDataCollection);
end.

