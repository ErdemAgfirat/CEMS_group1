v {xschem version=3.4.6 file_version=1.2}
G {}
K {}
V {}
S {}
E {}
T {1.45 < 1.5(nom) < 1.55V} 490 -870 0 0 0.4 0.4 {}
T {4uA} 580 -120 0 0 0.4 0.4 {}
T {0.7 < 0.8(nom) < 0.9V} 330 -460 0 0 0.4 0.4 {}
T {~0.38V} 560 -500 2 1 0.3 0.3 {}
T {~0.78V} 560 -610 2 1 0.3 0.3 {}
N 600 -680 660 -680 {
lab=gate_p}
N 520 -630 520 -590 {
lab=gate_p}
N 520 -630 600 -630 {
lab=gate_p}
N 520 -650 520 -630 {
lab=gate_p}
N 600 -680 600 -630 {
lab=gate_p}
N 600 -220 600 -130 {
lab=vss}
N 600 -250 660 -250 {
lab=vss}
N 660 -250 660 -130 {
lab=vss}
N 600 -130 660 -130 {
lab=vss}
N 520 -830 520 -710 {
lab=vdd}
N 520 -830 700 -830 {
lab=vdd}
N 700 -830 700 -710 {
lab=vdd}
N 700 -680 760 -680 {
lab=vdd}
N 760 -830 760 -680 {
lab=vdd}
N 700 -830 760 -830 {
lab=vdd}
N 460 -680 520 -680 {
lab=vdd}
N 460 -830 460 -680 {
lab=vdd}
N 460 -830 520 -830 {
lab=vdd}
N 660 -560 700 -560 {
lab=vss}
N 700 -610 700 -590 {
lab=vout}
N 520 -530 520 -490 {
lab=tail}
N 600 -490 700 -490 {
lab=tail}
N 700 -530 700 -490 {
lab=tail}
N 520 -560 660 -560 {
lab=vss}
N 520 -490 600 -490 {
lab=tail}
N 660 -560 660 -250 {
lab=vss}
N 600 -490 600 -280 {
lab=tail}
N 560 -680 600 -680 {
lab=gate_p}
N 740 -560 780 -560 {
lab=vinn}
N 700 -610 840 -610 {lab=vout}
N 700 -650 700 -610 {
lab=vout}
N 440 -130 600 -130 {lab=vss}
N 440 -250 560 -250 {lab=ibias_20u}
N 440 -560 480 -560 {lab=vinp}
N 440 -830 460 -830 {lab=vdd}
C {devices/title.sym} 160 -30 0 0 {name=l5 author="(c) 2024-2025 H. Pretl, Apache-2.0 license"}
C {sg13g2_pr/sg13_lv_nmos.sym} 580 -250 2 1 {name=M5
l=5u
w=0.5u
ng=1
m=1
model=sg13_lv_nmos
spiceprefix=X
}
C {sg13g2_pr/sg13_lv_pmos.sym} 680 -680 0 0 {name=M4
l=5u
w=1.5u
ng=1
m=1
model=sg13_lv_pmos
spiceprefix=X
}
C {sg13g2_pr/sg13_lv_nmos.sym} 500 -560 2 1 {name=M1
l=5u
w=2u
ng=1
m=1
model=sg13_lv_nmos
spiceprefix=X
}
C {sg13g2_pr/sg13_lv_nmos.sym} 720 -560 2 0 {name=M2
l=5u
w=2u
ng=1
m=1
model=sg13_lv_nmos
spiceprefix=X
}
C {sg13g2_pr/sg13_lv_pmos.sym} 540 -680 0 1 {name=M3
l=5u
w=1.5u
ng=1
m=1
model=sg13_lv_pmos
spiceprefix=X
}
C {ipin.sym} 440 -250 0 0 {name=p1 lab=ibias_20u}
C {iopin.sym} 440 -830 0 1 {name=p2 lab=vdd}
C {iopin.sym} 440 -130 0 1 {name=p3 lab=vss}
C {ipin.sym} 440 -560 0 0 {name=p4 lab=vinp}
C {ipin.sym} 780 -560 2 0 {name=p5 lab=vinn}
C {opin.sym} 840 -610 0 0 {name=p6 lab=vout}
C {lab_wire.sym} 640 -680 0 0 {name=p10 sig_type=std_logic lab=gate_p}
