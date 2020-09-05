# ssh

- Edit the to `~/.ssh/config` file to avoid freezing/disconnection of idle connections to server.
```bash
Host *
  ServerAliveInterval 60
```

- SSH tunnelling.
```bash
ssh -N -L <local-port>:<server-ip>:<server-port> -i <pem-file> <user>@<tunnel-server>
```
