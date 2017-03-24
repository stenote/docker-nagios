# dockerfile-nagios

nagios dockerfile

## Usage

### build

```
./build
```

### run

```
docker run -d -p 80:80 -v /nagios:/usr/local/nagios/etc/ nagios-image
```

## info

### basic auth

`nagios:nagios`
