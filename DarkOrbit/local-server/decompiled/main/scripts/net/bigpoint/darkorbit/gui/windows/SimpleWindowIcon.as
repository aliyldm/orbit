package net.bigpoint.darkorbit.gui.windows
{
   import com.greensock.TweenLite;
   import flash.display.BitmapData;
   import flash.events.MouseEvent;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.mvc.gui.featuresMenu.view.components.FeatureBtn;
   
   public class SimpleWindowIcon extends FeatureBtn
   {
      
      public static const OFFSET_X:int = 0;
      
      public static const OFFSET_Y:int = 7;
      
      private var _minimizable:Boolean;
      
      public function SimpleWindowIcon(param1:SWFFinisher, param2:BitmapData, param3:BitmapData, param4:Boolean = true)
      {
         super(param1,null,param2,param3,null);
         x = -OFFSET_X;
         y = -OFFSET_Y;
         this._minimizable = param4;
         this.setWindowMode(true,false);
      }
      
      override public function rollHandler(param1:MouseEvent) : void
      {
         if(this._minimizable)
         {
            iconsStates.rollHandler(param1);
         }
      }
      
      override public function mouseUpDownHandler(param1:MouseEvent) : void
      {
         if(this._minimizable)
         {
            iconsStates.mouseUpDownHandler(param1);
         }
      }
      
      public function setWindowMode(param1:Boolean, param2:Boolean = true) : void
      {
         var _loc3_:Number = param2 ? 0.4 : 0;
         if(param1)
         {
            if(param2)
            {
               background.visible = true;
               background.alpha = 1;
            }
            setVisibility(!param1,background,_loc3_);
         }
         else if(param2)
         {
            TweenLite.delayedCall(0.3,setVisibility,[!param1,background,_loc3_]);
         }
         else
         {
            setVisibility(!param1,background,_loc3_);
         }
      }
   }
}

