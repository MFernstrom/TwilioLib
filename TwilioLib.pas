unit TwilioLib;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fphttpclient, fpjson, jsonparser, Dialogs, TypInfo;

type
  TTwilio = class
    private
      account_sid, auth_token, url : String;

    public
      constructor create(sid, token : String);
      function send_sms(from_number, to_number, message: String): TStringlist;
  end;
  var
    account_sid, auth_token, send_from_number, send_to_number: String;

implementation
constructor TTwilio.create( sid, token: String );
begin
  Inherited create;
  account_sid := sid;
  auth_token := token;
  url := 'https://api.twilio.com/2010-04-01/Accounts/' + sid + '/Messages.json';
end;

function TTwilio.send_sms( from_number, to_number, message: String ): TStringlist;
var
  resultVar, postVars: TStringlist;
  s: String;
  Respo: TStringStream;
  pos: Integer;
  jData : TJSONData;
  jObject : TJSONObject;
begin
  // Initialise result variable, and set defaults
  resultVar := TStringlist.Create;
  resultVar.CommaText := 'sid=,date_created=,date_updated=,date_sent=,account_sid=,to=,from=,body=,status=,num_segments=,num_media=,direction=,api_version=,price=,price_unit=,error_code=,error_message=,uri=,raw=';
  postVars := TStringlist.Create;
  postVars.Add('To=' + to_number);
  postVars.Add('From=' + from_number);
  postVars.Add('Body=' + message);

  With TFPHttpClient.Create(Nil) do
    try
      Respo:=TStringStream.Create('');
      UserName := account_sid;
      Password := auth_token;
      FormPost(url, postVars, Respo);
      S := Respo.DataString;
      Respo.Destroy;
    finally
      Free;
    end;
  postVars.Free;

  jData := GetJSON( S );
  jObject := TJSONObject(jData);

  for pos := 0 to resultVar.Count-1 do
  begin
    if jObject.Get(resultVar.Names[pos]) <> Null then
      resultVar.Values[resultVar.Names[pos]] := jObject.Get(resultVar.Names[pos]);
  end;

  resultVar.Values['raw'] := S;
  Result := resultVar;
end;

end.
