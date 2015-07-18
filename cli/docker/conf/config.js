AV.initialize("${CONFIG.LEANCLOUD.ID}", "${CONFIG.LEANCLOUD.KEY}");
AV.setProduction(false)
window.CONST = {
    CDN : "${CONFIG.CDN}",
    HOST : "${CONFIG.HOST.lower()}",
    LEANCLOUD : "https://${CONFIG.LEANCLOUD.HOST.lower()}",
    CSS_HOST : "${CONFIG.CSS_HOST}"
}



