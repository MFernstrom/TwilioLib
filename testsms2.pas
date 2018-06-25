program testsms2.pas;
{$mode objfpc}
uses
  Sysutils, Classes, TwilioLib;
 
procedure SendSMS;
var
  twilio: ITwilio;
  twilio_result: TStrings;
begin
  twilio_result := TStringList.Create;
  try
    twilio := TTwilio.create('<SID>', '<TOKEN>') as ITwilio;
    try
      twilio.send_sms('<OUTPHONE>', '<TOPHONE>', '<message>', twilio_result);
    except
      on E:ETwilioException do
        writeln(e.message)
      else
        raise;
    end;
  finally
    twilio_result.free;
  end;
end;
 
begin
  SendSMS;
end.
