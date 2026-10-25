package net.bigpoint.darkorbit.loadingscreen.mvc.background.view.components
{
   import com.greensock.TweenLite;
   import com.greensock.layout.AlignMode;
   import com.greensock.layout.AutoFitArea;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   
   public class FlashBackgroundImage extends Sprite
   {
      
      private var _autoFitarea:AutoFitArea;
      
      private var _image:DisplayObject;
      
      public function FlashBackgroundImage()
      {
         super();
         this._autoFitarea = new AutoFitArea(this,0,0,10,10);
         this.mouseEnabled = false;
         this.alpha = 0;
      }
      
      public function setBackground(param1:DisplayObject) : void
      {
         this._image = param1;
         this.addChild(param1);
         this._autoFitarea.attach(param1,{
            "hAlign":AlignMode.CENTER,
            "vAlign":AlignMode.BOTTOM,
            "minWidth":param1.width,
            "minHeight":param1.height,
            "maxWidth":param1.width,
            "maxHeight":param1.height
         });
         TweenLite.to(this,1,{"alpha":1});
      }
      
      public function setSize(param1:Number, param2:Number) : void
      {
         this._autoFitarea.width = param1;
         this._autoFitarea.height = param2;
      }
      
      public function cleanup() : void
      {
         if(this._image)
         {
            if(this.contains(this._image))
            {
               this.removeChild(this._image);
            }
            this._image = null;
         }
         if(this._autoFitarea)
         {
            this._autoFitarea.destroy();
         }
         this._autoFitarea = null;
      }
   }
}

