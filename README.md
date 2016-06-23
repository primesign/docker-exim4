# Docker Image for Exim4

This is a simple Docker image for Exim4 based on the official [ubuntu:trusty](https://hub.docker.com/r/_/ubuntu/) image.

It uses the official Exim4 default configuraton file `configuration.default` instead of the configuration files provided by ubuntu package.

Use it like this in your `docker-compose.yml` file:

~~~~
version: "2"
  services:
    smtp:
      image: primesign/exim4
      ports:
        - "25:25"
      volumes:
        - "./conf/exim4.conf:/etc/exim4/exim4.conf:ro"
        - "./conf/ssl/exim.crt:/etc/ssl/exim.crt:ro"
        - "./conf/ssl/exim.pem:/etc/ssl/exim.pem:ro"
        - "/var/opt/smtp/spool:/var/spool/exim4/"
        - "/var/opt/smtp/log:/var/log/exim4/"
~~~~

## Smart Host Configuration

To send email via a smart host disable the `dnslookup` router in your `exim4.conf`. And add a `smarthost` router like follows:

~~~~
smarthost:
 driver = manualroute
 domains = *
 transport = remote_smtp
 route_data = your.smart.host
 ignore_target_hosts = <; 0.0.0.0 ; 127.0.0.0/8 ; ::1
 no_more
~~~~

Replace `your.smart.host` with the hostname or IP adress of your smart host (e.g. xxx.mail.protection.outlook.com in case of Office365 / Exchange Online).

For details see [the official documentation](http://www.exim.org/exim-html-current/doc/html/spec_html/ch-some_common_configuration_settings.html).


## SMTP TLS Client Authentication

In order to enable TLS authentication for the Exim SMTP client uncomment `tls_certificate` and `tls_privatekey` from your configuration file, mount or add the corresponding certificate and private key files into your container and add `hosts_require_tls = *` to your `remote_smtp` transport configurtion.

~~~~
remote_smtp:
  driver = smtp
  hosts_require_tls = *
~~~~

For details see [9. Configuring an Exim client to use TLS](http://www.exim.org/exim-html-current/doc/html/spec_html/ch-encrypted_smtp_connections_using_tlsssl.html) in the official Exim4 documentation.
