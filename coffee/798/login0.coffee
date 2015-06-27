$("body").append __inline("/html/coffee/798/login0.html")

require.async(
    ["lib/wow.js", "lib/jquery.lettering.js", "lib/jquery.textillate.js", "lib/jquery.typed.js"]
    ->
        _798 = $("#_798").show()

        _798.find('h1').textillate({ in: { effect: 'bounceInDown'}})
        setTimeout(
            ->
                _798.find('h2').css('visibility','visible').textillate({ in: { effect: 'rollIn'} })
                setTimeout(
                    ->
                        h3 = _798.find("h3").css('visibility','visible')
                        h3.find("span").typed({
                            strings: ["创建独一无二的博客、论坛 和 SNS 就是如此简单"]
                            typeSpeed: 100
                        })
                    1000
                )
            1600
        )
        new WOW().init()
)
require.async(
    "lib/particles.js"
    ->
        win = $ window
        win_size = win.height() * win.width()
        win_point_base= parseInt(win_size/22000)
        particlesJS('particles-js', {
          particles: {
            color: '#fff',
            color_random: false,
            shape: 'circle', # "circle", "edge" or "triangle"
            opacity: {
              opacity: .3,
              anim: {
                enable: false,
                speed: 1,
                opacity_min: 0,
                sync: false
              }
            },
            size: 2.5,
            size_random: true,
            nb: win_point_base*3,
            line_linked: {
              enable_auto: true,
              distance: 130,
              color: '#fff',
              opacity: .7,
              width: 1,
              condensed_mode: {
                enable: false,
                rotateX: 600,
                rotateY: 600
              }
            },
            anim: {
              enable: true,
              speed: 1
            }
          },
          interactivity: {
            enable: true,
            mouse: {
              distance: 250
            },
            detect_on: 'canvas', # "canvas" or "window"
            mode: 'grab', # "grab" of false
            line_linked: {
              opacity: .5
            },
            events: {
              onclick: {
                enable: true,
                mode: 'push', # "push" or "remove"
                nb: 4
              },
              onresize: {
                enable: true,
                mode: 'out', # "out" or "bounce"
                density_auto: false,
                density_area: 800 # nb_particles = particles.nb * (canvas width *  canvas height / 1000) / density_area
              }
            }
          },
          retina_detect: true
        })

)

