{======================================================
  Author      Marcus Fernström
  License     GPL3
  Version     0.2
  GitHub      https://github.com/MFernstrom/TwilioLib
=======================================================}
unit TwilioLib;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fphttpclient, fpjson, jsonparser, Dialogs, TypInfo;

type
  TTwilio = class(TInterfacedObject)
    private
      account_sid, auth_token, url : String;

    public
      constructor create(sid, token : String);
      procedure send_sms(from_number, to_number, message: String; VAR Output:TStringList );
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

procedure TTwilio.send_sms( from_number, to_number, message: String; Var Output:TStringList );
var
  resultVar, postVars: TStringlist;
  responseData: TStringStream;
  pos: Integer;
  jData : TJSONData;
  jObject : TJSONObject;
begin
  resultVar := TStringlist.Create;
  postVars := TStringlist.Create;
  responseData := TStringStream.Create('');
  try
    // Check if the output variable has been initialized
    if Not Assigned(Output) then
      raise exception.create('Output variable isn''t initialized') at
      get_caller_addr(get_frame),
      get_caller_frame(get_frame);

    // Prep resultVar
    resultVar.CommaText := 'sid=,date_created=,date_updated=,date_sent=,account_sid=,to=,from=,body=,status=,num_segments=,num_media=,direction=,api_version=,price=,price_unit=,error_code=,error_message=,uri=,raw=';

    // postVars holds the API data needed, to/from/body
    postVars.Add('To=' + to_number);
    postVars.Add('From=' + from_number);
    postVars.Add('Body=' + message);

    // Make the api call
    With TFPHttpClient.Create(Nil) do
      try
        UserName := account_sid;
        Password := auth_token;
        FormPost(url, postVars, responseData);
      finally
        Free;
      end;

    jData := GetJSON( responseData.DataString );
    jObject := TJSONObject(jData);

    for pos := 0 to resultVar.Count-1 do
    begin
      if jObject.Get(resultVar.Names[pos]) <> Null then
        resultVar.Values[resultVar.Names[pos]] := jObject.Get(resultVar.Names[pos]);
    end;

    resultVar.Values['raw'] := responseData.DataString;
    Output.Assign(resultVar);

  finally
    responseData.Free;
    resultVar.Free;
    postVars.Free;
  end;
end;

end.
