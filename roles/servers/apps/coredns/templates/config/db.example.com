$ORIGIN example.com.
@       3600 IN SOA dns1 mail (
                                {{ serial_number }} ; serial
                                7200       ; refresh in seconds (2 hours is 7200)
                                3600       ; retry (1 hour)
                                1209600    ; expire (2 weeks)
                                3600       ; minimum (1 hour)
                                )

        3600 IN NS dns1
;       3600 IN NS b.iana-servers.net.

dns1   IN A     8.8.8.8 ; public IP of your 1st DNS server
dns2   IN A     1.1.1.1 ; public IP of your 2nd DNS server

; NOTES:
; If you wish for this file to be reloaded after change,
; Make sure to increment the serial number !
