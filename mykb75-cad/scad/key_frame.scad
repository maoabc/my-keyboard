


//按键单位长度
U=19.05;

//轴边长
kl=13.97;



//默认键盘布局
key_layout_default=[
    //ESC    F1  F2  F3  F4  F5  F6  F7  F8  F9  F10 F11 F12  DEL
    [1.5*U,  U,  U,  U,  U,  U,  U,  U,  U,  U,  U,  U,  U,  1.5*U],
    //GRV  1   2   3   4   5   6   7   8   9   0   -   =   Backspace
    [  U,  U,  U,  U,  U,  U,  U,  U,  U,  U,  U,  U,  U,      2*U],
    //TAB    Q   W   E   R   T   Y   U   I   O   P   [   ]    \
    [1.5*U,  U,  U,  U,  U,  U,  U,  U,  U,  U,  U,  U,  U,  1.5*U],
    //CAPS    A   S   D   F   G   H   J   K   L   ;   '     ENTER
    [1.75*U,  U,  U,  U,  U,  U,  U,  U,  U,  U,  U,  U,    2.25*U],
    //LSHIFT    Z   X   C   V   B   N   M   ,   .   /   UP  RSHIFT
    [2.25*U,    U,  U,  U,  U,  U,  U,  U,  U,  U,  U,  U,  1.75*U],
    //CTRL   MENU    ALT       SPACE         FN  LEFT DOWN RIGHT MOD  
    [1.25*U, 1.25*U, 1.25*U,   6.25*U,        U,   U,   U,   U,  U]

];

//计算所有数组元素的和
function add(in,i=0,ret=0) =(
        i==len(in)?ret:
        add(in,i+1,ret+in[i])
        );




//选取一行计算所有列长度
length=add(key_layout_default[0]);

//行数乘上每个键宽度得到总宽度
width=len(key_layout_default)*U;


function inch2mm(x)=x*25.4;

//绘制卫星轴左边部分
//       _____
//      |     |_
//     _|   
//    |
//    |_ 
//      |
//      |      _
//      |_   _|
//        |_|
//
//中间大矩形开始逆时针画出每一个矩形
module left(A=inch2mm(0.94),K=kl,type=0){

    l0=inch2mm(0.262);
    w0=inch2mm(0.484);

    l1=inch2mm(0.166-0.262/2);
    w1=inch2mm(0.11);
    off_y=inch2mm((0.26-0.02));

    l2=inch2mm(0.12);
    w2=inch2mm(0.53-0.484);

    l3=(A-inch2mm(0.262)-K)/2;
    w3=inch2mm(0.484-0.031*2);


    square(size=[l0,w0],center=true);
    translate(v=[-l0/2-l1,-w0/2+off_y])color("red")square(size=[l1,w1],center=false);
    translate(v=[0,-w0/2-w2/2])color("green")square(size=[l2,w2],center=true);
    if(type != 0){    //空格键卫星轴
        w3=inch2mm(0.181);
        translate(v=[l0/2+l3/2,0])color("blue")square(size=[l3,w3],center=true);
    }else{
        translate(v=[l0/2+l3/2,0])color("blue")square(size=[l3,w3],center=true);
    }

}


//小于3U的卫星轴
module spacebar2(){
    //左右卫星轴中心点之间距离
    A=inch2mm(0.94);


    union(){
        translate(v=[-A/2,0])left(A,kl);

        square(kl+0.01,center=true);     //加0.01为了消除和两边卫星轴连接处的线

        mirror(v=[1,0])translate(v=[-A/2,0])left(A,kl);
    }

}

//大于3U的卫星轴
module spacebar3(){

    //左右卫星轴中心点之间距离
    A=inch2mm(4);

    union(){
        translate(v=[-A/2,0])left(A,kl,type=1);

        square(size=kl+0.01,center=true);     //加0.01为了消除和两边卫星轴连接处的线


        mirror(v=[1,0])translate(v=[-A/2,0])left(A,kl,type=1);
    }

}




function iterAdd(in,i=0,ret=[])=(
        i==len(in)?ret:                //递归出口
        iterAdd(in,i+1,
            concat(ret,
                (i==0?in[i]:           //第一个数据
                 ret[i-1]+in[i])    //之前结果加上当前
                )
            )
        );


module keys(){
    for(i=[0:len(key_layout_default)-1]){
        row=key_layout_default[i];   //每列键大小
        offsets=iterAdd(row);        //每列坐标
        for(j=[0:len(offsets)-1]){
            off=offsets[j];      
            col=row[j];
            if(col >= 2*U && col < 3*U){   //小卫星轴
                translate(v=[off-col/2,-i*U])spacebar2();
            }else if(col > 3*U){           //空格卫星轴
                translate(v=[off-col/2,-i*U])spacebar3();
            }else{
                translate(v=[off-col/2,-i*U])square(kl,center=true);
            }
        }
    }
}

module keyFrame(){
    difference(){

        //圆角矩形
        minkowski(){
            r=2;
            square(size=[length-2*r,width-2*r],center=true);
            circle(r=r,$fn=200);

        }
        //TODO 螺丝孔方便固定或者给小红点开孔

        translate(v=[-length/2,width/2-U/2])keys();
    }
}

keyFrame();


