

module footer(bottom_r=7.5,top_r=5,h=10,mat_r=4.1,mat_dep=2,dk=7,k=2.5,d=4){
    ps=[
        [d/2,0],[bottom_r,0],    //底部圆
        [bottom_r,h/2],        //圆柱
        [top_r,h],              //顶部圆
        [mat_r,h],
        [mat_r,h-mat_dep],
        [dk/2,h-mat_dep],
        [dk/2,(h-mat_dep)-k],  //螺帽高度
        [d/2,(h-mat_dep)-k]

    ];
        rotate_extrude($fn=200){
#polygon(ps);
        }
}
footer();
