function blackoil_bench_pvt(name = :spe1)
    if name == :spe1
        pvt = (spe1_pvtw(), spe1_pvto(), spe1_pvdg())
        density = [786.507 1037.84 0.969758]
    else
        error("Case $name not found.")
    end
    return Dict(:pvt => pvt, :rhoS => density, :name => name)
end

function spe1_pvtw()
    tab = [2.76804e7  1.029  4.53968e-10  0.00031  0.0]
    return PVTW(tab)
end

function spe1_pvdg()
    pvdg_raw = [
        # Pressure B-factor    Viscosity
        1.01353e5  0.93576     8.0e-6
        1.82504e6  0.0678972   9.6e-6
        3.54873e6  0.0352259   1.12e-5
        6.99611e6  0.0179498   1.4e-5
        1.38909e7  0.00906194  1.89e-5
        1.73382e7  0.00726527  2.08e-5
        2.07856e7  0.00606375  2.28e-5
        2.76804e7  0.00455343  2.68e-5
        3.45751e7  0.00364386  3.09e-5
        6.21542e7  0.00216723  4.7e-5
    ]
    return PVDG([pvdg_raw])
end

function spe1_pvto()
    # Offsets
    pos = [1, 4, 7, 10, 13, 16, 19, 22, 25, 27]
    # Saturated points in terms of Rs
    keys = [
        0.1781076066790352
        16.118738404452685
        32.059369202226335
        66.07792207792205
        113.27643784786639
        138.03339517625227
        165.64007421150274
        226.1966604823747
        288.17810760667896
    ]
    # 2D table
    data = [
            1.01353e5  1.062    0.00104
            6.99611e6  1.04696  0.00111953
            3.45751e7  0.98932  0.00150902
            1.82504e6  1.15     0.000975
            8.7198e6   1.13372  0.00104956
            3.62988e7  1.0713   0.00141471
            3.54873e6  1.207    0.00091
            1.04435e7  1.18991  0.000979588
            3.80225e7  1.1244   0.00132039
            6.99611e6  1.295    0.00083
            1.38909e7  1.27666  0.000893471
            4.14699e7  1.20637  0.00120431
            1.38909e7  1.435    0.000695
            2.07856e7  1.41468  0.000748147
            4.83647e7  1.33679  0.00100843
            1.73382e7  1.5      0.000641
            2.4233e7   1.47876  0.000690018
            5.1812e7   1.39735  0.000930078
            2.07856e7  1.565    0.000594
            2.76804e7  1.54284  0.000639424
            5.52594e7  1.4579   0.000861882
            2.76804e7  1.695    0.00051
            3.45751e7  1.671    0.000549
            6.21542e7  1.579    0.00074
            3.45751e7  1.827    0.000449
            6.21542e7  1.726    0.000605
            ]
    return PVTO(Dict("key" => keys, "pos" => pos, "data" => data))
end
