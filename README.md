# ansible-role-firewalld-gsync
Handle firewalld whitelist ipsets using a google spreadsheet. The scripts checks each minute for changes in the CSV formatted url file. It than matches the hosts MAC address and execute the firewall-cmd for creating firewallD rich rules.

## Setup
* Create a Google Spreadsheet with the following layout:
```
Host,  MAC Address,  Allow IP,  Service,   Description
```
* In the Spreadsheet, go to File -> Download as -> Comma-separated values.
* Copy the url location.
* Edit file /opt/firewalld-gsync/etc/whitelist.url
* Paste the url and save the file.
