# TwilioLib
A Freepascal library for sending SMS with Twilio

## Use
Add TwilioLib to your uses clause

Instantiate a TTwilio variable, send sms :)

### Example

```
program testsms.pas;
{$mode objfpc}
uses
  Sysutils, Classes, TwilioLib;
 
procedure SendSMS;
var
  twilio: TTwilio;
  twilio_result: TStrings;
begin
  twilio_result := TStringList.Create;
  try
    twilio := TTwilio.create('your sid', 'your secret');
    try
      try
        twilio.send_sms('+OutPhone', '+ToPhone', 'message', twilio_result);
      except
       on E:ETWilioException do
         writeln(e.message)
       else raise;
      end;
    finally
      Twilio.Free;
    end;
  finally
    twilio_result.free;
  end;
end;
 
begin
  SendSMS;
end.
```

## Requirements
You need to have a Twilio account, and your account SID.

## Future
Right now it only supports sending single SMS, in the future I'll be implementing more functionality that Twilio offers.
