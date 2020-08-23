{======================================================
  Author       Marcus Fernström
  Contributor  Thaddy de Koning
  License      LGPL3
  Version      0.4
  GitHub       https://github.com/MFernstrom/TwilioLib
=======================================================}
unit TwilioLib;
 
{$mode objfpc}{$H+}{$notes off}
 
interface
 
uses
  Classes, SysUtils, fphttpclient, fpjson, jsonparser, opensslsockets;
 
type
  ITwilio = interface
  ['{7C5DF745-E72C-4652-9FB1-94992F181207}']
    procedure send_sms(const from_number, to_number, message: String;var Output: TStrings);
  end;
     
  { TTwilio }
 
  TTwilio = class(TInterfacedObject, ITwilio)
  private
    account_sid, auth_token, url : String;
  public
    constructor create(const sid, token : String);
    destructor destroy;override;
    procedure send_sms(const from_number, to_number, message: String;var Output: TStrings);
  end;
 
  ETWilioException = Class(Exception);
 
implementation
 
constructor TTwilio.create(const sid, token: String );
begin
  Inherited create;
  account_sid := sid;
  auth_token := token;
  url := 'https://api.twilio.com/2010-04-01/Accounts/' + sid + '/Messages.json';
end;
 
destructor TTwilio.Destroy;
begin
  inherited Destroy;
end;
 
procedure TTwilio.send_sms(const from_number, to_number, message: String;
  var Output: TStrings);
var
  postVars: TStringlist;
  responseData: TStringStream;
  pos: Integer = 0;
  jObject : TJSONObject = nil;
begin
   // Check if the output variable has been initialized
   if Assigned(Output) then
   begin
     Output.Clear;
     postVars := TStringlist.Create;
     responseData := TStringStream.Create('');
     try
       // Prep resultVar
       Output.CommaText := 'sid=,date_created=,date_updated=,date_sent=,account_sid=,to=,from=,body=,status=,num_segments=,num_media=,direction=,api_version=,price=,price_unit=,error_code=,error_message=,uri=,raw=';
 
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
 
       jObject := GetJSON( responseData.DataString ) as TJSONObject;
 
       for pos := 0 to Output.Count-1 do
         if jObject.Get(Output.Names[pos]) <> Null then
           Output.Values[Output.Names[pos]] := jObject.Get(Output.Names[pos]);
       Output.Values['raw'] := responseData.DataString;
     finally
       responseData.Free;
       jObject.Free;
       postVars.Free;
     end
   end else
     raise ETWilioException.Create('No output assigned') at
       get_caller_addr(get_frame),
       get_caller_frame(get_frame);;
end;
end.
