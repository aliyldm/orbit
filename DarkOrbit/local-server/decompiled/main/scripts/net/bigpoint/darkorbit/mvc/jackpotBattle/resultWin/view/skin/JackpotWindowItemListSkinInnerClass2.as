package net.bigpoint.darkorbit.mvc.jackpotBattle.resultWin.view.skin
{
   import mx.events.PropertyChangeEvent;
   import mx.graphics.SolidColorStroke;
   import spark.primitives.Line;
   
   public class JackpotWindowItemListSkinInnerClass2 extends Line
   {
      
      private var _88844982outerDocument:JackpotWindowItemListSkin;
      
      public function JackpotWindowItemListSkinInnerClass2()
      {
         super();
         this.stroke = this._JackpotWindowItemListSkinInnerClass2_SolidColorStroke1_c();
      }
      
      private function _JackpotWindowItemListSkinInnerClass2_SolidColorStroke1_c() : SolidColorStroke
      {
         var _loc1_:SolidColorStroke = new SolidColorStroke();
         _loc1_.color = 2961714;
         _loc1_.weight = 1;
         _loc1_.caps = "square";
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

