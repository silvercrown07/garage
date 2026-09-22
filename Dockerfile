FROM dxflrs/garage:v2.4.1

COPY garage.toml /etc/garage.toml

ENTRYPOINT ["/garage"]
CMD ["server", "--single-node", "--default-bucket"]
EXPOSE 3900 3901 3902 3903