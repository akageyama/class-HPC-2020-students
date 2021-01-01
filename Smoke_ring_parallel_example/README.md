# assignment-smoke-ring-for-piviz

# 報告(02/06)　
1615092T 田中智也

(0206追記) リポジトリ生成時点の状態を, ブランチoriginalに復元し, originalに対してpullrequestを送りました. 


## 選択課題
課題C

## 並列化に関するデータ
- MPIプロセス数 : 12
- OpenMPスレッド数 : 2 ~ 8
- ジョブキュー名 : uv-large
- 使用ノード数 : 12 ~ 96
- 計算時間: シミュレーション結果の項で示す

## 基本パラメータ
すべてのシミュレーションを以下のパラメータで行った.
- 格子点数 : (NX,NX,NZ) = (156,52,52)
- 粘性率 : 0.03
- 粘性率 : 0.03

## プログラム変更点
- src
  - src/contants.f90
    - (+) 並列化のための定数を追加
  
  - (+)src/rank.f90
    - (+)並列化手法1のrank_divを定義
    - (+)並列化手法2のperipheralを定義
    - (+)rank__initialize : rank_divを計算
    - (+)rank__reverse : rank_divの情報からrank数を求める(rank__peripheralで用いるprivate関数)
    - (+)rank__peripheral : peripheralを計算

  - src/grid.f90
    - (+)並列化手法3のgrid_div_rangeを定義. 
    - (+)grid__determine_range : grid_div_rangeを計算

  - src/field.f90
    - (+)boundary_condition(fluid, scalar, vector) : 1対1通信(sendrecv)を実装
    - (-+)operator(curl, div, laplasian_scalar, laplasian_scalar) : MPIに対応(境界条件, ループ)
    - (-+)operator_curl : Hybrid並列化後, slicedata.f90から呼び出すときにエラーが生じた. サブルーチン化により解決. 

  - src/solver.f90
    - (+)set_drive_force_field : 実験のため, THE_FORCEの値と, 力を与える領域を変更
    - (-+)subfield(vel,vel_tm,vel_tm_divv) : 並列化後, operator_vector_divby_scalarでエラー. 関数を呼ぶことなく処理を行うことで解決.
    - (+)the_equation : MPI並列化とOpenMP並列化
    - (-+)solver__advance : MPIに対応(境界条件, ループ)
    - (+)solver__diagnosis : max vel , flow energy, total massの計算に集団通信(reduce)を実装
  
   - src/slicedata.f90
     - (+)make_single_precision_field : スライスデータの生成に集団通信(reduce)を実装. 
   
   - src/Makefile
     - (+)mpi, hybridプログラム実行のためのスクリプトを追加. vizfront上での実行のためのターゲット, runを追加. 
 
 - job
   - job/run.sh
     - (+) mpi, hybridプログラム実行のためのスクリプトを追加
   - job/params.test01.nbamelist
     - (-+) _data_sliceファイルのパスを変更, total_nroop, slicedata_nskipを実験に応じて変更
  

## 並列化手法と効果
### 並列化手法
#### MPI
X方向を3個, Y方向に2個に, Z方向を2個に分割した.  
(NX,NY,NZ) = (156,52,52)の条件のもとでは, 1つのプロセスに割り当てられる格子点数は(52,26,26)となる.   

各プロセスがMPI並列のために持つデータは次の3つである.       

1. rank_div%(x,y,z):   
x軸,y軸,z軸それぞれでのrank数を格納する.     

	e.g.  
	- if rank = 0  -> rank_div%x = 0, rank_div%y = 0, rank_div%z = 0   
	- if rank = 11 -> rank_div%x = 2, rank_div%y = 1, rank_div%z = 1  
	
2. peripheral%(x,y,z)%(upper,lower) :   
x,y,z軸それぞれで, 上に位置するプロセス, 下に位置するプロセスの2つを格納する.このとき周期境界条件に注意する.   

3. grid_div_range%(x,y,z)%(start_idx, end_idx) :  
x軸,y軸,z軸それぞれで, 割当領域の最初のインデックス, 最後のインデックスを格納する. 

	e.g.  
	- if rank = 0  -> grid_div_range%x%start_idx = 0, grid_div%x%end_idx = NX_DIV
	- if rank = 11 -> grid_div_range%xstart_idx = NX_DIV * 2 + 1, grid_div_range%x%end_idx = NX_DIV * 3    

1 ~ 3のうち, solverで用いるのは2と3である. 2は境界データの通信に, 3はループ処理に用いる.

#### OpenMP
solver.f90内で離散化したナビエ・ストークス方程式を用いて次状態を求める関数the_equationのみスレッド並列化した.   

### 並列化による効果
the_equation関数での処理にかかるCPU時間(400回試行を行った平均)  

|                   | 総時間          | 境界データの処理  |                 
| --------------- |:---------------:|:-----------------:| 
| Normal            | 0.0231[s]| 0.0010[s] |
| MPI               | 0.0062[s]| 0.0032[s] | 
| Hybrid(OpenMP+MPI)| 0.0081[s]| 0.0050[s] | 


- 3次元のMPI並列化では, 境界データの通信がボトルネックとなる. 
- Hybrid並列化で処理時間が改善しない点については, OpenMPのスレッド分割にかかる処理時間が, 分割することにより改善される時間を上回っていることが原因と見ている. リソースが確保でき次第, スレッド数を増やして実験を行う.   
    
8スレッド並列で実験したところ, 総時間は0.024となり, 2並列のときよりも処理時間が遅くなった. スレッド並列化に関しては改善の必要がある(0206追記)

## シミュレーション
smoke ringの直進, smoke ringの衝突, smoke ringの飲み込みに関するシミュレーションを行った. 
### smoke ring の直進
- 並列化方法 : MPI 12並列, OpenMP8並列, uv-large, 96ノード
- 計算時間 : 1223.45[s]
- ループ数 : 3000
- データ区切り : 100
- 力のかけ方 : THE_FORCE = 3000

可視化データはresult/elaborate.gifにある

### smoke ringの衝突
- 並列化方法 : MPI 12並列, uv-large, 12ノード
- 計算時間 : 2932.56[s]
- ループ数 : 9000
- データ区切り : 300
- 力のかけ方 : 左のリングのTHE_FORCE = 10000, 右のリングのTHE_FORCE=-10000, 左右対称

結果, 簡単な考察:  
衝突後, 右のリングは左のリングの, 左のリングは右のリングの壁となり, リングが押しつぶされる.    
リングが衝突した瞬間z軸と平行で, |z|が大きくなる方向に対して大きな力が生まれている.
それにより, 互いのエネルギーが相殺されないまま, リングが|z|の大きくなる方向に広がっていく.  

可視化データはresult/collision.gifにある. 

### smoke ringの飲み込み
- 並列化方法 : MPI 12並列, uv-large, 12ノード
- 計算時間 : 未計測
- ループ数 : 4500
- データ区切り : 50
- 力のかけ方 : 速いリングのTHE_FORCE = 10000, 遅いリングのTHE_FORCE = 3000, 遅いリングはxz平面の中心から生成

結果, 簡単な考察:  
速さの大きいリングが, 速さの小さいリングに追いつくと, 速さの小さいリングは大きいリングに飲み込まれる.   
速さの大きいリングが速さの小さいリングに追いついたとき, 接面において速度ベクトルは逆向きである.
だが, 速度ベクトルの大きさは速さの大きいリングが勝る. 
故に, 運動エネルギーは失われるが, 速さの大きいリングが速さの小さいリングを飲み込むように見える. 

可視化データはresult/chase.gifにある. 

### 速さの異なるsmoke ringの衝突
面白いと思ったシミュレーションである. 速さが同じであれば衝突しても互いに飲み込まれることはないが, 速さが異なれば, 速さの大きいほうが速さの小さいほうのリングを飲み込んでしまう. 可視化データをresult/collision_difvel.gifにおいておく

## 最後に
プログラムがとても整っていて, 並列化, 実験にあたり変更するべき点が掴みやすかったです. ハイレベルなコードに触れ学ぶことが非常に多くありました. ありがとうございました. 
最後に, プログラムの変更点のうち, operator_curlのサブルーチン化, sub_field中の operator_vector_divby_scalarの変更について少し述べておきます. 

- operator_curl   
  mpi並列のみではエラーおきず. hybrid並列化後, enstrophyの値がおかしくなる. logdataのmaxvel flow energy total massは問題なし.
  どうやらslicedata.f90内のenstrophyの計算でバグが生じている. 試しにopertor_curlをサブルーチン化すると値が正常になる.

- sub_field中のoperator_vector_divby_scalar  
  mpi並列のみで, jobをなげると途中でjobがkillされる. operator_vector_divby_scalarをはずして, sub_field計算のサブルーチン中でそのまま計算すると解決. 
  
傾向として, field__fluid_t構造体をもつデータを2つ以上引数に取る場合, functionだとバグが生じ, subroutineだと正常に動作するような感じがありました. なぜこのようなバグが生じたのか, なぜfunctionを呼び出さないことでバグが解消されたのかはわかりませんでした. 私の追加コードに何らかの問題があったのかもしれません. 

# pi-VizStudioで計算する課題


## 課題内容

pi-VizStudioで実行するためのsmoke-ringコードを用意した。
（ジョブ投入用のジョブスクリプトとjobディレクトリを追加した程度で、
元のsmoke-ringプログラム本質的には同じである。）

このシミュレーションを大規模化するために以下のA, B, Cのうち***どれか一つ***の方法で並列化せよ。


### 課題 A （難易度：低）
- Open MPでスレッド並列化せよ


### 課題 B：（難易度：中）
- 上記課題Aに加えて（つまりOpen MPでスレッド並列化した上で）、MPIでのプロセス並列化も行え。シミュレーション領域を分割してそれぞれに一つのMPIプロセスを割り当てる領域分割の方法で並列化すること。領域分割の仕方は1次元（例えばx方向）だけでも構わないが、2次元あるいは3次元の方が望ましい。
- 可視化のために、複数の領域に分散されたデータを一つのファイルまたはプロセスに集約する必要がある。


### 課題 C：（難易度：高）
- 上記課題Bに加えて（つまりMPIとOpen MPのハイブリッド並列化を行った上で）、実際に大規模シミュレーションと可視化解析を行い、二つの渦輪が正面衝突する際に起きる現象を調べて記述せよ。


### その他
- この課題リポジトリ（assignment-smoke-ring-for-piviz）のソースコード、ドキュメント（このファイルREADME.mdを含めて）の誤字・脱字・スペルミスの修正、または来年度のための改良案などあればそれもPull Requestに含めよ。


## 提出方法

プルリクエストで提出せよ。手順は以下の通り：

1. この課題リポジトリ（class-HPC-2018/assignment-smoke-ring-for-piviz）のInvitationをacceptする。
2. この課題リポジトリをForkする。→ 自分のリポジトリ（assignment-smoke-ring-for-piviz-YOUR-NAME）ができる。
3. 自分のリポジトリをπ-VizStudio（vizfront）でcloneする。
4. プログラミング・ジョブ投入・デバッグ・可視化解析を繰り返す。（ブランチを使い、こまめにコミットすることを勧める。）
6. 最終的なコードを自分のリポジトリにGitHubにpushする
7. Pull Requestする（ブランチ名は任意）。
8. Pull Requestの内容をテキスト（Mark Down）で記述する欄には以下を記入すること。評価者の理解を助けるため、画像やグラフを入れることが望ましい（画像は入力欄にドラッグ&ドロップすればよい）
    - 【記入必須】課題A, B, Cのうちどれを選択したか
    - 【記入必須】並列化関係のデータ（MPIプロセス数、OpenMPスレッド数、ジョブキュー名、使用ノード数、計算時間）
    - 【記入任意】シミュレーション関係のデータ（実験に用いた典型的な（あるいは最大の）空間格子点数、シミュレーション領域を変更した場合はその大きさ、粘性率、熱拡散率、力の掛け方を変更した場合はその記述、その他、元のサンプルプログラムから変更したところがあれば全て）
    - 【記入任意】 並列化が実際に効いていることを立証する計算時間の測定データ（合計のプロセス数（またはスレッド数）を増やすと、シミュレーションにかかる時間が確かに減少していることがわかるデータ、またはグラフ。





# 以下はサンプルコードsmoke-ringの解説

# class-hpc-smoke-ring

A simple sample field solver, or a CFD (Computational Fluid Dynamics)
code for the class "HPC", which is for undergraduate students of
Department of Engineering, Kobe University, Japan.

## Physical Model
A gas contained in a rectangular box is driven by a localized force
near a side plane of the box. The force drives the gas fluid toward
the other side, rsulting in the formation of well-known vortex-ring,
or smoke-ring.

## Program structure

    --+--src (For the smoke-ring simulation. The output is a file
      |       named "_data_slice".)
      |
      +--job (For job submission)
      |
      +--slice_grapher (For visualization. It reads "_data_slice"
      |                 and makes an animated gif of the flow in a
      |                 a cross section.)
      |
      +--warming_up (A supplementary, simple, sample, and stand-alone,
                     simulation program. It solves 1-D Burgers
                     equation with the same numerical scheme (finite
                     difference + Runge-Kutta integration) and with
                     the same visualization method (gnuplot). Read
                     and run this program before you proceed to the
                     main smoke-ring ring codes (src and slice_grapher).

## Prerequisite

- Fortran 2003 compiler, for the simulation.
- gnuplot and ImageMagic (convert command), for the visualization.
- An animated gif viewer Here we use Safari.

## Usage

    1. [in pi-VizStudio] cd src
    2. make  (for compile)
    3. cd ../job
    4. edit param*.namelist run.sh
    5. qsub run.sh
    6. cd ../slice_grapher
    7. make (for gif-animation file)
    8. [in your local Mac] 
       scp you@vizfront:/YourDirectory/slice_grapher/Workfiles/animation.gif .

## Easy experiments

- Change the grid size (NX,NY,NZ) in src/constants.f90
- Change dissipation params in src/params.namelist


## Basic equation

Compressible Navier-Stokes equations for an ideal gas.


## Numerical method

Second-order central difference with 4-th order Runge-Kutta integration.

## Boundary condition

Periodic boundary in all (three) dimensions.

## Programing language

Fortran 2003.

## Author
Akira Kageyama, Kobe Univ., Japan
 email: sgks@mac.com | kage@port.kobe-u.ac.jp

## License

This software is released under the MIT License, see LICENSE.txt.
