package net.bigpoint.darkorbit.mvc.jackpotBattle.resultWin.view.skin
{
   import mx.events.PropertyChangeEvent;
   import mx.graphics.SolidColor;
   import spark.primitives.Rect;
   
   public class JackpotWindowItemListSkinInnerClass7 extends Rect
   {
      
      private var _88844982outerDocument:JackpotWindowItemListSkin;
      
      public function JackpotWindowItemListSkinInnerClass7()
      {
         super();
         this.fill = this._JackpotWindowItemListSkinInnerClass7_SolidColor1_c();
      }
      
      private function _JackpotWindowItemListSkinInnerClass7_SolidColor1_c() : SolidColor
      {
         var _loc1_:SolidColor = new SolidColor();
         _loc1_.color = 16777215;
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get outerDocument() : JackpotWindowItemListSkin
      {
         return this._88844982outerDocument;
      }
      
      public function set outerDocument(param1:JackpotWindowItemListSkin) : void
      {
         var _loc2_:Object = this._88844982outerDocument;
         if(_loc2_ !== param1)
         {
            this._88844982outerDocument = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"outerDocument",_loc2_,param1));
            }
         }
      }
   }
}

