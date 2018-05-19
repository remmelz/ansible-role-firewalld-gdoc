# ansible-role-firewalld-googledoc
Handle firewalld whitelist ipsets using a google spreadsheet.

## Setup
* Create a Google Spreadsheet with the following layout:
```
| Whitelist | Description
| <ip addr> | <some text>
```
* In the Spreadsheet, go to File -> Download as -> Comma-separated values.
* Copy the url location.
* Edit file /opt/fwdgdoc/etc/whitelist.gdoc
* Paste the url and save the file.
