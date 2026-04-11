# Anisble Role "etc_monitor"

This role deploys the monitor to content changes to files within /etc directory.
If any file was changed, send email to root with the file name(s).
It shows which files were added, deleted or modified.

## Automated Tests

Please refer to [molecule/README.md](../../molecule/README.md).

## End-to-end Test

After the "etc_monitor" role applied to the hosts,
`ssh` to any one of the hosts to run the following command:

```sh
# Just make some changes under the /etc directory.
cd /etc
sudo touch haha.md
sudo mkdir demo
echo "nice" | sudo tee -a haha.md
sudo mv haha.md ./demo
sudo rm demo/ -r
```

Then run the `mail` command:

```sh
# See all the emails received by the root user.
sudo mail -u root
```

It's expected to see something like this at the end of the email list:

<!-- markdownlint-disable MD013 -->
```txt
Mail version 8.1.2 01/15/2001.  Type ? for help.
"/var/mail/root": 7 messages 7 new
>N  1 root@36a279fc450c  Thu Nov 27 09:55   15/493   /etc change detected - CREATE - /etc/haha.md
 N  2 root@36a279fc450c  Thu Nov 27 09:55   15/499   /etc change detected - CREATE,ISDIR - /etc/demo
 N  3 root@36a279fc450c  Thu Nov 27 09:55   15/493   /etc change detected - MODIFY - /etc/haha.md
 N  4 root@36a279fc450c  Thu Nov 27 09:56   15/501   /etc change detected - MOVED_FROM - /etc/haha.md
 N  5 root@36a279fc450c  Thu Nov 27 09:56   15/507   /etc change detected - MOVED_TO - /etc/demo/haha.md
 N  6 root@36a279fc450c  Thu Nov 27 09:56   15/503   /etc change detected - DELETE - /etc/demo/haha.md
 N  7 root@36a279fc450c  Thu Nov 27 09:56   15/497   /etc change detected - DELETE,ISDIR - /etc/demo
```
<!-- markdownlint-enable MD013 -->

You may also see other emails if this role is executed before other roles,
since it's common for ansible tasks to modify the /etc directory.
