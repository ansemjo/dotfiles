if command -q openssl

    alias view-cert "openssl x509 -noout -text -in"
    alias view-cert-fpr "openssl x509 -noout -fingerprint -sha256 -in"
    alias view-request "openssl req -noout -text -verify -in"
    alias view-revocs "openssl crl -noout -text -in"
    alias view-rsakey "openssl rsa -check -in"
    alias view-pkcs12 "openssl pkcs12 -info -in"

    function openssl-client -d "wrapper for openssl s_client"

        # expect at least one argument
        argparse --min-args 1 -- $argv
        or return

        # remove protocol from destination and maybe add port
        set -f host (string replace -ri '^([a-z0-9]*://)?([^/]+)(/.*)?$' '$2' $argv[1])
        set -f server $host
        if not string match ':[0-9]{1,5}$' $server
            set server "$server:443"
        end

        # connect to the server
        echo + openssl s_client -status -connect $server -servername $host $argv[2..]
        openssl s_client -status -connect $server -servername $host $argv[2..]

    end

    function getcert -d "connect with openssl-client and dump the certificate"
        openssl-client $argv </dev/null | sed -n '/BEGIN CERTIFICATE/,/END CERTIFICATE/p'
    end

    function snakeoil -d "generate a selfsigned certificate with openssl"
        argparse --min-args 1 --max-args 1 -- $argv
        or return
        openssl req -x509 -nodes -days 30 -newkey rsa:2048 \
            -keyout "$argv[1].key" -out "$argv[1]"
    end

end
