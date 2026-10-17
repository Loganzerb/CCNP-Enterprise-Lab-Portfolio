# Ubuntu TACACS+ reproduction setup

The original lab used Ubuntu 20.04.2 LTS and Shrubbery `tac_plus` F4.0.4.32. The CML export contains the Ubuntu node and cloud-init, but does not package the installed daemon or its runtime files. The steps below are reproduction instructions based on the supplied material; they have not been rerun during portfolio preparation.

## Establish the actual interface mapping

Before applying network configuration, inspect guest addresses and routes. The export and the original guest used different interface names:

| Connection | Exported Ubuntu interface | Guest-observed interface |
|---|---|---|
| CML NAT / DHCP | n2/i0, `ens3` | `ens2` |
| Internal link to R1 | n2/i1, `ens4` | `ens3` |

The supplied [Netplan file](ubuntu-netplan.yaml) targets the **guest-observed internal `ens3`**, at `/etc/netplan/99-aaa-internal.yaml`. It is not a declaration that the export's `ens3` label is the internal link. Confirm the mapping in a new guest and adapt only your private local setup if its names differ. The public YAML retains the original link IDs and labels.

The original guest used NAT DHCP on `192.168.255.0/24` with gateway `192.168.255.1`. The supplied file configures only the internal `192.0.2.20/24` address; it is not a complete inventory of every Ubuntu network configuration file. Check that the NAT default route remains available after locally applying it.

## Install the server separately

Prepare private Ubuntu access before startup. Obtain and independently verify the intended Shrubbery source archive and required build dependencies. The prior package's captured sequence records successful installation of F4.0.4.32 under `/usr/local`; its source archive and installed binary are not included here.

Use the original [verification](../verification/README.md) to distinguish the observed build, loader repair, and version check from any new installation. Check that `/usr/local/sbin/tac_plus` is present before using the supplied service unit.

## Prepare the policy locally

The [TACACS+ file](tac_plus.conf) is a reconstruction of the supplied two-group policy summary. Its commented user/key stanzas contain REDACTED fields and provide no usable login or shared key. Replace those fields and uncomment the stanzas in a private copy before installing it as `/etc/tacacs/tac_plus.conf`. Configure the same private shared key on R1 and protect the server file's access permissions.

Both groups request privilege level 15. `NETADMINS` permits the administrator's commands. `NOC-RESTRICTED` explicitly denies `configure` while otherwise retaining the supplied default-permit policy. Do not interpret that example as a general read-only role.

For a new private parser check, keep configuration output out of shared logs:

```bash
sudo /usr/local/sbin/tac_plus -P -C /etc/tacacs/tac_plus.conf >/dev/null 2>&1
echo "Parser exit code: $?"
```

This is a reproduction command, not a parser result from the reconstructed template. The original successful parser result belongs to the supplied evidence.

## Apply the supplied persistent settings

Install [tac_plus.service](tac_plus.service) at `/etc/systemd/system/tac_plus.service` after preparing the internal address and private policy. Its supplied command keeps the daemon in the foreground and binds it to `192.0.2.20`; it writes accounting according to the policy file. Reload systemd, enable and start the unit, and inspect the service and TCP 49 listener. Check that a separate manually started daemon is not already using that listener.

The original Ubuntu reboot was followed by the internal address, NAT route, enabled/active service, listener, 4/4 ping, and a successful router authentication test. That source result does not establish a fresh sanitized import or a successful run of this reconstructed template. The router's startup configuration was inspected, but the router was not reboot-tested.

[Configuration index](README.md) · [Topology](../topology.md) · [Verification](../verification/README.md) · [Evidence scope](../scope.md) · [Overview](../README.md)
