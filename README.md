# ansible-role-firewalld-gsync
Handle firewalld whitelist ipsets using a google spreadsheet.

## Setup
* Create a Google Spreadsheet with the following layout:
```
| Whitelist | Description |
| <ip addr> | <some text> |
```
* In the Spreadsheet, go to File -> Download as -> Comma-separated values.
* Copy the url location.
* Edit file /opt/firewalld-gsync/etc/whitelist.url
* Paste the url and save the file.
