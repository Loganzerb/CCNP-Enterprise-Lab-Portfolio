# Path Engineering — Making the Preferred Route Predictable

Root priority chooses the reference switch; path cost helps a switch choose its route toward that root. Port priority can resolve later ties. These controls answer different questions.

| Question | Relevant material |
|---|---|
| Which distribution switch should be root? | [SW1/SW4 saved priorities](../../configs/README.md) split the preferred roots by VLAN group |
| Which route does SW3 actually select for VLAN 10? | [SW3 port roles](../root-election/SW3-show-spanning-tree-vlan-10.txt) show Gi0/0 Root/FWD at cost 20000 |
| Is long cost configured on SW5 at the later check? | [SW5 path-cost capture](SW5-pathcost-method-long.txt) explicitly reports long |
| Did a port-priority change cause a measured path change? | The original notes describe that exercise; a dedicated before/after change capture is absent |

Keep **local port cost** separate from the **total cost toward the root**. In the earlier [LACP experiment](../etherchannel/README.md), the healthy bundle has local cost 3 and total root cost 11. The one-member state has local cost 4 and total root cost 12.

Those earlier values and the later long-cost setting are different stages. Comparing them as if one change produced every number would obscure the actual evidence.

[Case 10](../../troubleshooting/10-path-cost-port-priority-engineering.md) explains the experiment and its evidence boundary.

[Verification index](../README.md) · [Module overview](../../README.md)
