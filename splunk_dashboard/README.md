# Display all the host in the custom splunk dashboard 
index='_internal' host=* 
| stats count by host
| sort -count
