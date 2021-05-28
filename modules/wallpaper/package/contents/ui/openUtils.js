
function openEditPage(wallpaperViewComponent,imageUrl){
    wallpaper_root.stack.layer.push(wallpaperViewComponent)
}

function popFullView(){
    wallpaper_root.stack.layer.pop()
}
