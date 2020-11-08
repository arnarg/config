{ ... }:

{
  users = {
    users = {
      arnar = {
        isNormalUser = true;
        uid = 1000;
        group = "arnar";
        extraGroups = [ "wheel" ];
        home = "/home/arnar";
        openssh.authorizedKeys.keys = [
          # Krypton
          "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDPa8klVyO+Tm+D5tMs9rJPhPp1wYoaLLqxXBZRddgZrNBwnWngnEwym5zpNbPfOY0L7M1t+BHwcvGxKo9TFcUQyzxCsknUuOZNpomcJrAPYHE9l+uHikhrbVuP8H0Q8nfRgiesK9jPE6lZAp4Pifo4+8ggef/w2a5ropLgnrAEmBDkFdTxmh2vBvYDY8P8KhudU3Lkr1n44Z7HX/Q8DtEjUs8aXz5oaQhO6YqBJplHfBVrZeRLuSQExovGJ9SZhLsodbfrPXeJvaBEHYtokptXfQXVeWKibs5GW+09FKN6dmqMCJaDWfHvjJ08t4/+jtGJqxTMyOYu9jhzVciu2jQkO/fMJw0iNpSFhNTIEkdrvEsiBYyrsHq0p+1mLYxI9rmDqiXstAqf1uvzC2gOmNdNk/I05Y1NLfng5ms53AnN3F+ymJizooaql6qp+oGQwIkqP1Rd9cZPMEIBX3AN5nP9ZfsxTPu1buRdBKhtRuiPZ1mJ8J1JgRuTH0u1Ds3cOI8="
          # Yubikey 1
          "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBCJgc736QyZbRlQLbK8Lm8Ra8EJdZIl3U84DRP3U7qmR/jSQR9P92RBuIXWTbcHbNxeZbMx7g6n9CDDPV0weXRQ="
          # Yubikey 2
          "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBDKo0cPCEyU0wpsxTlKLqlLqjbO491aF80OE86lepqbrZpWqNurFd8EUdisSyOG5fMNNlbS3H7lVOruqGbuJUYo="
        ];
      };
    };

    groups = {
      arnar = {
        gid = 1000;
      };
    };
  };
  local.immutable.users = [ "arnar" ];
}
