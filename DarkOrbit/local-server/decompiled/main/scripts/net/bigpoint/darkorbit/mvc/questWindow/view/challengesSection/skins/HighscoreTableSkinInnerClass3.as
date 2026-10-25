package net.bigpoint.darkorbit.mvc.questWindow.view.challengesSection.skins
{
   import mx.events.PropertyChangeEvent;
   import mx.graphics.SolidColorStroke;
   import spark.primitives.Line;
   
   public class HighscoreTableSkinInnerClass3 extends Line
   {
      
      private var _88844982outerDocument:HighscoreTableSkin;
      
      public function HighscoreTableSkinInnerClass3()
      {
         super();
         this.stroke = this._HighscoreTableSkinInnerClass3_SolidColorStroke1_c();
      }
      
      private function _HighscoreTableSkinInnerClass3_SolidColorStroke1_c() : SolidColorStroke
      {
         var _loc1_:SolidColorStroke = new SolidColorStroke();
         _loc1_.color = 6908265;
         _loc1_.weight = 1;
         _loc1_.caps = "square";
         _loc1_.alpha = 0;
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get outerDocument() : HighscoreTableSkin
      {
         return this._88844982outerDocument;
      }
      
      public function set outerDocument(param1:HighscoreTableSkin) : void
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

