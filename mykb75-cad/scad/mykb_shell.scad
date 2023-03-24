
use <ISOThread.scad>

echo(version=version());

thinwall=3;//
mouse_length=57+1;//鼠标三键长度
mouse_width=19+1;//鼠标三键宽度

inner_length=285+1;
inner_width=113.6+1;

length=inner_length+2*thinwall;//长度
width=inner_width+mouse_width+2*thinwall;//宽度
thickness=12;//厚度

bottom=-thickness/2+thinwall;  //底部平面坐标,z轴

trackPiont_x=-(inner_length-1)/2+128.2;//小红点模块并不是位于正中心

//$fn=100;


//pcb螺丝孔,相对于左上角的距离
function getNutPoints()=[

    [4,8.62], [142,8.62],  [(285-25),8.62],//上部3个螺丝

    [25,46.88], [123.448,46.88],  [(285-25),46.88],//中部三个螺丝

    //trackpoint模块附近四个螺丝
    [109.003,(113.6-47.3)], [(109.003+38.32),(113.6-47.3)],
    [99.553,(113.6-28.28)], [(99.553+57.155),(113.6-28.28)],

    //下部3个螺丝
    [25,(113.6-9.201)], [186.804,(113.6-9.201)],  [(285-20.166),(113.6-9.201)],

];

bottom_footer_points=[
    [-(inner_length-1)/2+37,((inner_width-1)/2+mouse_width/2)-23],
    [(inner_length-1)/2-37,((inner_width-1)/2+mouse_width/2)-23]
];

module pcbStuds(dia=5,h=3.5){

    for(pos=getNutPoints()){
        translate(v=[-(inner_length-1)/2+pos[0],((inner_width-1)/2+mouse_width/2)-pos[1], bottom+h/2])  //螺柱以实际pcb大小进行定位,所以减去1
            cylinder(h=h,d=dia,center=true);
    }
}

module pcbBottomFrame(h=3.5){

    widths=[19.3+16.6,19.3,19.3,19.3,18];
    base=-inner_width/2+mouse_width/2+3.5;
    offsets=[
        base,
        base+widths[0],
        base+widths[0]+widths[1],
        base+widths[0]+widths[1]+widths[2],
        base+widths[0]+widths[1]+widths[2]+widths[3]
    ];
        module lcube(size=[1,1,1]){
            difference(){
                cube(size=size,center=true);
                translate(v=[-(size[0]/2),0,0])cylinder(r=1,h=size[2],center=true);
            }
        }

        difference(){
            translate(v=[0,mouse_width/2,0])cube(size=[inner_length,inner_width,h],center=true);

            w=2;
            for(i=[0:len(offsets)-1]){
                translate(v=[0,offsets[i]+(widths[i]-w)/2,0])roundedCube(size=[inner_length-2,widths[i]-w,h],r=2);
            }

            //下部镂空
            translate(v=[0,offsets[0]-3.5/2,0]){
                //削圆角
                difference(){
                    w=3.7;
                    l=inner_length-128-w;
                    cube(size=[l,w,h],center=true);
                    translate(v=[-l/2,-w/2,0])cylinder(r=w,h=h,center=true);
                    mirror(v=[1,0,0]) translate(v=[-l/2,-w/2,0])cylinder(r=w,h=h,center=true);
                }
            }

            //右边shift卫星轴安装空间
            l=38;
            translate(v=[(inner_length-2)/2-l/2,offsets[1]-w/2,0])lcube(size=[l,3*w,h]);//宽度增加倍是需要把右边圆角消除,下同

            //Backspace卫星轴安装空间
            l=36;
            translate(v=[(inner_length-2)/2-l/2,offsets[3]-w/2,0])lcube(size=[l,3*w,h]);

        }

}

//typc孔及底部按钮孔
module typecAndButton(){
    l=10;//typec接口长度,两边圆半径2,矩形长度5.6
    thin=4;//厚度4,圆的直径

    translate(v=[-(inner_length-1)/2+25.8,inner_width/2+3,bottom+thin/2-0.25]){//typec在底部以下0.25
        rotate(a=[-90,0,0]){
            hull(){
                translate(v=[2.8,0,0])cylinder(r=thin/2,h=l,center=false);
                mirror(v=[1,0,0])translate(v=[2.8,0,0])cylinder(r=2,h=l,center=false);
            }
        }
        translate(v=[0,2,0])roundedCube(size=[15,10,thin],r=1);
    }

    //底部按钮
    translate(v=[-(inner_length-1)/2+29.15,inner_width/2+mouse_width/2-67.2,-thickness/2]){
        cylinder(r=1.2,h=thinwall,center=false);
    }
}
module mouse3key(h=3){
    translate(v=[trackPiont_x,-inner_width/2,bottom+h/2]){
        difference(){
            cube(size=[mouse_length,mouse_width,h],center=true);
            //鼠标三键,轴焊接空间
            translate(v=[-19,2,0])roundedCube(size=[13,10,h],r=2);
            translate(v=[0,2,0])roundedCube(size=[13,10,h],r=2);
            translate(v=[19,2,0])roundedCube(size=[13,10,h],r=2);
            //排线接口
            translate(v=[10,7,0])cube(size=[16,8,h],center=true);
        }
    }
}

module trackPiont(h=5){
    translate(v=[-(inner_length-1)/2+128.21,-(inner_width-1)/2+mouse_width/2+38.32, bottom+h/2-1.5]){//底部挖下去1.5
        union(){
            r=2;
            roundedCube(size=[30,20,h],r=r);
            translate(v=[-4,-(20/2+22/2)+4,0])roundedCube(size=[38,22,h],r=r);
            translate(v=[-30/2-r/2+0.1,-20/2+r/2+4-0.1,0])rotate(a=[0,0,90])rounde(h=h,r=r);//移动0.1让圆角和两个矩形相交
        }
    }

}

//防滑垫
module mats(dep=1.5){
    left_top_x=-length/2+14;
    left_top_y=width/2-8;
    points=[
        [left_top_x,left_top_y],    //左上角
        [-left_top_x,left_top_y],   //x轴对称,右上角
        [left_top_x,-left_top_y],   //y轴对称,左下角
        [-left_top_x,-left_top_y],  //y=x轴对称,右下角
        [trackPiont_x,-left_top_y], //鼠标中键下部
    ];
    for(p=points){
        translate(v=[p[0],p[1],-thickness/2])cylinder(r=4.1,h=dep,center=false);  //8mm的防滑胶粒
    }

}

//底部脚撑螺柱
module bottomFooters(dia=6.5,fh=1.5){

    for(bf=bottom_footer_points){
        translate(v=[bf[0],bf[1],bottom])  
            cylinder(h=fh,d=dia,center=false);
    }

}


module rounde(h=1,r=1){
    difference(){
        cube(size=[r,r,h],center=true);
        translate(v=[r/2,r/2,0])cylinder(r=r,h=h,center=true);
    }
}

module roundedCube(size=[1,1,1],r=1){
    minkowski(){
        h=1;
        cube(size=[size[0]-2*r,size[1]-2*r,size[2]-h],center=true);
        cylinder(r=r,h=h,center=true);
    }
}
module prism(a=1){
    hull(){
        translate(v=[0,0,a/2+a])cube(a,center=true);
        cube(2*a,center=true);
        translate(v=[0,0,-(a/2+a)])cube(a,center=true);
    }
}

module mykbShell(ph=3.5,mh=2,fh=1.5){
    difference(){
        union(){

            //矩形内部挖出pcb和鼠标3键空间
            difference(){
                //圆角及倒直角
                minkowski(){
                    r=3;
                    h=1;
                    a=1;
                    cube(size=[length-2*r-2*a,width-2*r-2*a,thickness-h-4*a],center=true);

                    prism(a);

                    cylinder(r=r,h=h,center=true);
                }
                translate(v=[0,mouse_width/2,thinwall/2]){//内部放置pcb空间
                    minkowski(){
                        r=2;
                        h=1;
                        union(){
                            cube(size=[inner_length-2*r,inner_width-2*r,thickness-thinwall-h],center=true);//pcb

                            //鼠标三键
                            translate(v=[trackPiont_x,-(inner_width-2*r)/2-mouse_width/2,0]){
                                cube(size=[mouse_length-2*r,mouse_width,thickness-thinwall-h],center=true);
                            }
                        }
                        cylinder(r=r,h=h,center=true);
                    }
                }
            }

            pcbStuds(dia=5,h=ph);//5mm的螺柱

            translate(v=[0,0,bottom+ph/2]){
                pcbBottomFrame(h=ph);
            }

            bottomFooters(fh=fh);
            mouse3key(mh);

        }
        typecAndButton();
        trackPiont();
        mats();
    }
}

//生成螺纹
module fasteners(){
    pcb_h=3.5;  //pcb相对于外壳底部距离
    mouse_h=2.2;  //鼠标三键pcb高度
    footer_h=2;  //底部脚撑加强凸起
    h=4;   //螺丝长度
    m2=2;
    m4=4;
    difference(){
        mykbShell(pcb_h,mouse_h,footer_h);
        for(p=getNutPoints()){
            translate(v=[-(inner_length-1)/2+p[0],((inner_width-1)/2+mouse_width/2)-p[1], bottom-(h-pcb_h)]){ 
                cylinder(h=h,d=m2*0.8,center=false);
            }
        }

        //鼠标三键固定螺丝
        y=-inner_width/2-0.5;
        translate(v=[-19/2+trackPiont_x,y, bottom-(h-mouse_h)]){ 
            cylinder(h=h,d=m2*0.8,center=false);
        }
        translate(v=[19/2+trackPiont_x,y, bottom-(h-mouse_h)]){ 
            cylinder(h=h,d=m2*0.8,center=false);
        }

        //底部脚撑螺丝孔,直接穿透
        for(bf=bottom_footer_points){
            translate(v=[bf[0],bf[1],-thickness/2])  
                cylinder(h=thinwall+footer_h,d=3.3,center=false);
        }
    }

    //for(pos=getNutPoints()){
    //    translate(v=[-(inner_length-1)/2+pos[0],((inner_width-1)/2+mouse_width/2)-pos[1], bottom-0.5]){ 
    //        thread_in(dia=m2,hi=h,thr=$fn);
    //    }
    //}
}

fasteners();




module chamfered_cube(s,c) {
    minkowski() {
        cube(s,center=true);
        prism(a=2);

        //rotate([45,0,0]) cube(c);
        //rotate([0,45,0]) cube(c);
        //rotate([0,0,45]) cube(c);
        cylinder(r=3,h=1);
    }
}

