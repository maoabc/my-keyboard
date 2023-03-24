
//延长杆分为底部圆柱,中间圆柱,上部分长方体

//延长杆总长度等于 botttom_h+1+middle_h+1+0.5+top_h

module tp_v1(bottom_r=3,bottom_h=4,middle_r=2,middle_h=10.5,top_width=4.67,top_h=3){




    //顶部矩形的外接圆半径
    top_r=sqrt(2*pow(top_width,2))/2;


    difference(){
        union(){
                rotate_extrude($fn=500){
                    tp_ps=[
                        [0,0],[bottom_r,0],[bottom_r,bottom_h],
                        [middle_r,bottom_h+1],                    //1毫米圆角到中间圆柱体     
                        [middle_r,bottom_h+1+middle_h],           // 
                        [top_r,(bottom_h+1+middle_h)+1],          //1毫米圆角到顶部矩形外接圆
                        [top_r,((bottom_h+1+middle_h)+1)+0.5],    //顶部外接圆拉伸0.5成圆柱体

                        [0,((bottom_h+1+middle_h)+1)+0.5]         //结束
                    ];
#polygon(tp_ps);
                }
            h0=((bottom_h+1+middle_h)+1)+0.5;

            //顶部长方体,用于安装小红点
            translate(v=[0,0,h0+top_h/2]){
                cube(size=[top_width,top_width,top_h],center=true);
            }
        }

        //底部空心长方体
        
        //宽
        bw=2.44;
        bh=3;
        translate(v=[0,0,bh/2])cube(size=[bw,bw,bh],center=true);
    }
}
tp_v1();
translate(v=[10,10,0])tp_v1(bottom_r=3.5,middle_r=2.5);
translate(v=[20,10,0])tp_v1(bottom_r=3.5,middle_r=2.5);
translate(v=[30,10,0])tp_v1(bottom_r=3.5,middle_r=2.5);
translate(v=[40,10,0])tp_v1(bottom_r=3.5,middle_r=2.5);
