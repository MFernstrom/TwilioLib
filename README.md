# TwilioLib
A Freepascal library for sending SMS with Twilio

## Use
Add TwilioLib to your uses clause

Instantiate a TTwilio variable, send sms :)

### Example

```
uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, TwilioLib;

procedure SendSMS();
var
  twilio: TTwilio;
  twilio_result: TStringList;
begin
  twilio := TTwilio.create('YourAccountSid', 'YourAccountToken');
  TwilioResult := twilio.send_sms('from_number', 'to_number', 'String to send');
end;
```

## Future
Right now it only supports sending single SMS, in the future I'll be implementing more functionality that Twilio offers.
